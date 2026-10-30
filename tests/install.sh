#!/bin/sh

set -eu

REPOSITORY_ROOT=$(cd "$(dirname "$0")/.." && pwd -P)
TEST_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/hdae-install-test.XXXXXX")

cleanup() {
    rm -rf "$TEST_ROOT"
}

trap cleanup EXIT HUP INT TERM

PROJECT=$TEST_ROOT/project
mkdir -p "$PROJECT"
git -C "$PROJECT" init -q
cat >"$PROJECT/AGENTS.md" <<'EOF'
# Project instructions

Keep this user-authored instruction.
EOF

# Deprecated installed-updater options must fail before changing the target and
# direct users to the external main-branch installer.
DEPRECATED_PROJECT=$TEST_ROOT/deprecated-project
mkdir -p "$DEPRECATED_PROJECT"
git -C "$DEPRECATED_PROJECT" init -q
if "$REPOSITORY_ROOT/install.sh" --target "$DEPRECATED_PROJECT" --all --update \
    >"$TEST_ROOT/deprecated-update.out" 2>&1; then
    echo 'deprecated update mode was accepted' >&2
    exit 1
fi
grep -q 'updates use the current main installer: curl -fsSL' \
    "$TEST_ROOT/deprecated-update.out"
if "$REPOSITORY_ROOT/install.sh" --target "$DEPRECATED_PROJECT" --all \
    --version v0.1.1 >"$TEST_ROOT/deprecated-version.out" 2>&1; then
    echo 'deprecated version mode was accepted' >&2
    exit 1
fi
grep -q 'updates use the current main installer: curl -fsSL' \
    "$TEST_ROOT/deprecated-version.out"
test ! -e "$DEPRECATED_PROJECT/.hdae"
test ! -e "$DEPRECATED_PROJECT/.agents"
test ! -e "$DEPRECATED_PROJECT/.claude"

# Discovery conflicts must be detected before any installation state changes.
CONFLICT_PROJECT=$TEST_ROOT/conflict-project
mkdir -p "$CONFLICT_PROJECT/.claude/skills/pr-issue-review"
git -C "$CONFLICT_PROJECT" init -q
if "$REPOSITORY_ROOT/install.sh" --target "$CONFLICT_PROJECT" --all --copy \
    >"$TEST_ROOT/conflict.out" 2>&1; then
    echo 'discovery conflict did not stop installation' >&2
    exit 1
fi
grep -q 'discovery path already exists' "$TEST_ROOT/conflict.out"
test ! -e "$CONFLICT_PROJECT/.hdae"
test ! -e "$CONFLICT_PROJECT/.agents"

# Malformed recovery markers must fail before installation changes the target.
BOOTSTRAP_CONFLICT_PROJECT=$TEST_ROOT/bootstrap-conflict-project
mkdir -p "$BOOTSTRAP_CONFLICT_PROJECT"
git -C "$BOOTSTRAP_CONFLICT_PROJECT" init -q
printf '%s\n' '<!-- hdae:context-recovery:start -->' \
    >"$BOOTSTRAP_CONFLICT_PROJECT/AGENTS.md"
if "$REPOSITORY_ROOT/install.sh" --target "$BOOTSTRAP_CONFLICT_PROJECT" \
    --codex --copy >"$TEST_ROOT/bootstrap-conflict.out" 2>&1; then
    echo 'malformed HDAE recovery markers did not stop installation' >&2
    exit 1
fi
grep -q 'incomplete or duplicate HDAE recovery markers' \
    "$TEST_ROOT/bootstrap-conflict.out"
test ! -e "$BOOTSTRAP_CONFLICT_PROJECT/.hdae"
test ! -e "$BOOTSTRAP_CONFLICT_PROJECT/.agents"

# A matching pre-existing recovery block is usable but remains user-owned.
UNOWNED_BOOTSTRAP_PROJECT=$TEST_ROOT/unowned-bootstrap-project
mkdir -p "$UNOWNED_BOOTSTRAP_PROJECT"
git -C "$UNOWNED_BOOTSTRAP_PROJECT" init -q
cp "$REPOSITORY_ROOT/AGENTS.md" "$UNOWNED_BOOTSTRAP_PROJECT/AGENTS.md"
"$REPOSITORY_ROOT/install.sh" --target "$UNOWNED_BOOTSTRAP_PROJECT" \
    --codex --copy >"$TEST_ROOT/unowned-bootstrap.out"
grep -q '^agents_bootstrap=0$' "$UNOWNED_BOOTSTRAP_PROJECT/.hdae/manifest"
test -L "$UNOWNED_BOOTSTRAP_PROJECT/.agents/skills/hdae-development"
test -L "$UNOWNED_BOOTSTRAP_PROJECT/.claude/skills/hdae-development"
"$REPOSITORY_ROOT/install.sh" --target "$UNOWNED_BOOTSTRAP_PROJECT" \
    --uninstall >"$TEST_ROOT/unowned-bootstrap-uninstall.out"
cmp -s "$REPOSITORY_ROOT/AGENTS.md" "$UNOWNED_BOOTSTRAP_PROJECT/AGENTS.md"

# The documented curl-to-shell path must install from standard input without
# treating files in the target project as the installer source.
STDIN_SOURCE=$TEST_ROOT/stdin-source
mkdir -p "$STDIN_SOURCE"
cp -R "$REPOSITORY_ROOT/skills" "$REPOSITORY_ROOT/install.sh" \
    "$REPOSITORY_ROOT/VERSION" "$STDIN_SOURCE/"
git -C "$STDIN_SOURCE" init -q
git -C "$STDIN_SOURCE" checkout -q -b main
git -C "$STDIN_SOURCE" add skills install.sh VERSION
git -C "$STDIN_SOURCE" -c user.name=HDAE -c user.email=hdae@example.invalid \
    commit -q -m 'test source'

STDIN_PROJECT=$TEST_ROOT/stdin-project
mkdir -p "$STDIN_PROJECT/skills/hdae-development" \
    "$STDIN_PROJECT/skills/pr-issue-review"
git -C "$STDIN_PROJECT" init -q
HDAE_REPOSITORY_URL=$STDIN_SOURCE sh -s -- --target "$STDIN_PROJECT" --all --copy \
    <"$REPOSITORY_ROOT/install.sh" >"$TEST_ROOT/stdin.out"
test -f "$STDIN_PROJECT/.hdae/manifest"
test -f "$STDIN_PROJECT/.agents/skills/hdae-development/SKILL.md"
test -f "$STDIN_PROJECT/.claude/skills/pr-issue-review/SKILL.md"
test ! -e "$STDIN_PROJECT/.hdae/install.sh"
grep -q '^installer_copy=0$' "$STDIN_PROJECT/.hdae/manifest"
grep -q "source=$STDIN_SOURCE@main" "$STDIN_PROJECT/.hdae/manifest"
printf '\nupdate marker\n' \
    >>"$STDIN_SOURCE/skills/hdae-development/references/hdae-method.md"
git -C "$STDIN_SOURCE" add skills/hdae-development/references/hdae-method.md
git -C "$STDIN_SOURCE" -c user.name=HDAE -c user.email=hdae@example.invalid \
    commit -q -m 'test update'
HDAE_REPOSITORY_URL=$STDIN_SOURCE sh -s -- --target "$STDIN_PROJECT" --all --copy \
    <"$REPOSITORY_ROOT/install.sh" >"$TEST_ROOT/stdin-update.out"
grep -q 'update marker' \
    "$STDIN_PROJECT/.hdae/skills/hdae-development/references/hdae-method.md"
test ! -e "$STDIN_PROJECT/.hdae/install.sh"

"$REPOSITORY_ROOT/install.sh" --target "$PROJECT" --all --copy

test -f "$PROJECT/.hdae/manifest"
test -f "$PROJECT/.hdae/skills/hdae-development/SKILL.md"
test -f "$PROJECT/.hdae/skills/pr-issue-review/SKILL.md"
test ! -e "$PROJECT/.hdae/install.sh"
test -L "$PROJECT/.agents/skills/hdae-development"
test -L "$PROJECT/.claude/skills/pr-issue-review"
test -f "$PROJECT/.agents/skills/hdae-development/SKILL.md"
grep -q '^agents_bootstrap=1$' "$PROJECT/.hdae/manifest"
grep -q '^installer_copy=0$' "$PROJECT/.hdae/manifest"
grep -q '^# Project instructions$' "$PROJECT/AGENTS.md"
grep -q '^Keep this user-authored instruction\.$' "$PROJECT/AGENTS.md"
test "$(grep -Fxc '<!-- hdae:context-recovery:start -->' "$PROJECT/AGENTS.md")" -eq 1
test "$(grep -Fxc '<!-- hdae:context-recovery:end -->' "$PROJECT/AGENTS.md")" -eq 1

# Reinstalling an unchanged managed copy must be idempotent.
"$REPOSITORY_ROOT/install.sh" --target "$PROJECT" --all --copy
test "$(grep -Fxc '<!-- hdae:context-recovery:start -->' "$PROJECT/AGENTS.md")" -eq 1

# Every accepted selector configures all supported agents, and an update repairs
# a missing managed discovery link without duplicating the canonical skills.
SELECTOR_PROJECT=$TEST_ROOT/selector-project
mkdir -p "$SELECTOR_PROJECT"
git -C "$SELECTOR_PROJECT" init -q
"$REPOSITORY_ROOT/install.sh" --target "$SELECTOR_PROJECT" --claude --copy \
    >"$TEST_ROOT/selector-install.out"
test -L "$SELECTOR_PROJECT/.agents/skills/hdae-development"
test -L "$SELECTOR_PROJECT/.claude/skills/hdae-development"
rm "$SELECTOR_PROJECT/.agents/skills/hdae-development"
"$REPOSITORY_ROOT/install.sh" --target "$SELECTOR_PROJECT" --codex --copy \
    >"$TEST_ROOT/selector-repair.out"
test -L "$SELECTOR_PROJECT/.agents/skills/hdae-development"
test -L "$SELECTOR_PROJECT/.claude/skills/hdae-development"
test "$(find "$SELECTOR_PROJECT/.hdae/skills" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')" -eq 2

# An old manifest identifies the historical self-copy as installer-managed. A
# new external reinstall removes it and records that future files are unowned.
LEGACY_PROJECT=$TEST_ROOT/legacy-project
mkdir -p "$LEGACY_PROJECT"
git -C "$LEGACY_PROJECT" init -q
"$REPOSITORY_ROOT/install.sh" --target "$LEGACY_PROJECT" --codex --copy \
    >"$TEST_ROOT/legacy-initial.out"
sed '/^installer_copy=0$/d' "$LEGACY_PROJECT/.hdae/manifest" \
    >"$TEST_ROOT/legacy-manifest"
cp "$TEST_ROOT/legacy-manifest" "$LEGACY_PROJECT/.hdae/manifest"
cp "$REPOSITORY_ROOT/install.sh" "$LEGACY_PROJECT/.hdae/install.sh"
"$REPOSITORY_ROOT/install.sh" --target "$LEGACY_PROJECT" --codex --copy \
    >"$TEST_ROOT/legacy-migrate.out"
test ! -e "$LEGACY_PROJECT/.hdae/install.sh"
grep -q '^installer_copy=0$' "$LEGACY_PROJECT/.hdae/manifest"

# A user-created file at the former path remains untouched once the manifest
# records that HDAE no longer owns an installer copy, including on uninstall.
PRESERVE_PROJECT=$TEST_ROOT/preserve-project
mkdir -p "$PRESERVE_PROJECT/.hdae"
git -C "$PRESERVE_PROJECT" init -q
printf '%s\n' '# user-owned file' >"$PRESERVE_PROJECT/.hdae/install.sh"
cp "$PRESERVE_PROJECT/.hdae/install.sh" "$TEST_ROOT/user-install.sh"
"$REPOSITORY_ROOT/install.sh" --target "$PRESERVE_PROJECT" --codex --copy \
    >"$TEST_ROOT/preserve-initial.out"
cmp -s "$TEST_ROOT/user-install.sh" "$PRESERVE_PROJECT/.hdae/install.sh"
"$REPOSITORY_ROOT/install.sh" --target "$PRESERVE_PROJECT" --codex --copy \
    >"$TEST_ROOT/preserve-reinstall.out"
cmp -s "$TEST_ROOT/user-install.sh" "$PRESERVE_PROJECT/.hdae/install.sh"
"$REPOSITORY_ROOT/install.sh" --target "$PRESERVE_PROJECT" --uninstall \
    >"$TEST_ROOT/preserve-uninstall.out"
cmp -s "$TEST_ROOT/user-install.sh" "$PRESERVE_PROJECT/.hdae/install.sh"
test ! -e "$PRESERVE_PROJECT/.hdae/manifest"
test ! -e "$PRESERVE_PROJECT/.hdae/skills"

# Local changes inside the installer-managed bootstrap must be protected.
cp "$PROJECT/AGENTS.md" "$TEST_ROOT/agents-managed"
awk '
    /^<!-- hdae:context-recovery:end -->$/ { print "local managed-block change" }
    { print }
' "$PROJECT/AGENTS.md" >"$TEST_ROOT/agents-modified"
cp "$TEST_ROOT/agents-modified" "$PROJECT/AGENTS.md"
if "$REPOSITORY_ROOT/install.sh" --target "$PROJECT" --all --copy \
    >"$TEST_ROOT/agents-modified.out" 2>&1; then
    echo 'modified AGENTS.md recovery block was not protected' >&2
    exit 1
fi
grep -q 'installer-managed HDAE block in AGENTS.md was modified' \
    "$TEST_ROOT/agents-modified.out"
cp "$TEST_ROOT/agents-managed" "$PROJECT/AGENTS.md"

# Added symlinks, including their targets, are part of the managed tree digest.
ln -s SKILL.md "$PROJECT/.hdae/skills/hdae-development/local-link"
if "$REPOSITORY_ROOT/install.sh" --target "$PROJECT" --all --copy \
    >"$TEST_ROOT/symlink.out" 2>&1; then
    echo 'added skill symlink was not detected' >&2
    exit 1
fi
rm "$PROJECT/.hdae/skills/hdae-development/local-link"

# Per-file hash utility formatting must not affect the recorded tree digest.
FORMAT_GNU_PROJECT=$TEST_ROOT/format-gnu-project
FORMAT_OPENSSL_PROJECT=$TEST_ROOT/format-openssl-project
mkdir -p "$FORMAT_GNU_PROJECT" "$FORMAT_OPENSSL_PROJECT"
git -C "$FORMAT_GNU_PROJECT" init -q
git -C "$FORMAT_OPENSSL_PROJECT" init -q
PATH="$REPOSITORY_ROOT/tests/fixtures/bin:$PATH" HDAE_TEST_HASH_FORMAT=gnu \
    "$REPOSITORY_ROOT/install.sh" --target "$FORMAT_GNU_PROJECT" --codex --copy \
    >"$TEST_ROOT/format-gnu.out"
PATH="$REPOSITORY_ROOT/tests/fixtures/bin:$PATH" HDAE_TEST_HASH_FORMAT=openssl \
    "$REPOSITORY_ROOT/install.sh" --target "$FORMAT_OPENSSL_PROJECT" --codex --copy \
    >"$TEST_ROOT/format-openssl.out"
gnu_digest=$(sed -n 's/^skills_digest=//p' "$FORMAT_GNU_PROJECT/.hdae/manifest")
openssl_digest=$(sed -n 's/^skills_digest=//p' "$FORMAT_OPENSSL_PROJECT/.hdae/manifest")
test "$gnu_digest" = "$openssl_digest"

# Local changes must prevent an implicit replacement.
printf '\nlocal test change\n' >>"$PROJECT/.hdae/skills/hdae-development/SKILL.md"
if "$REPOSITORY_ROOT/install.sh" --target "$PROJECT" --all --copy \
    >"$TEST_ROOT/modified.out" 2>&1; then
    echo 'modified installation was not protected' >&2
    exit 1
fi

"$REPOSITORY_ROOT/install.sh" --target "$PROJECT" --uninstall --force
test ! -e "$PROJECT/.hdae/skills"
test ! -e "$PROJECT/.agents/skills/hdae-development"
test ! -e "$PROJECT/.claude/skills/pr-issue-review"
test -f "$PROJECT/AGENTS.md"
grep -q '^# Project instructions$' "$PROJECT/AGENTS.md"
grep -q '^Keep this user-authored instruction\.$' "$PROJECT/AGENTS.md"
if grep -Fq '<!-- hdae:context-recovery:' "$PROJECT/AGENTS.md"; then
    echo 'uninstall left the installer-managed AGENTS.md block behind' >&2
    exit 1
fi

# Link mode must expose both skills from a project-local HDAE checkout.
LINK_PROJECT=$TEST_ROOT/link-project
mkdir -p "$LINK_PROJECT/.hdae"
git -C "$LINK_PROJECT" init -q
cp -R "$REPOSITORY_ROOT/skills" "$REPOSITORY_ROOT/install.sh" \
    "$REPOSITORY_ROOT/VERSION" "$LINK_PROJECT/.hdae/"
"$LINK_PROJECT/.hdae/install.sh" --target "$LINK_PROJECT" --all --link
test -L "$LINK_PROJECT/.agents/skills/hdae-development"
test -f "$LINK_PROJECT/.agents/skills/hdae-development/SKILL.md"

echo 'HDAE installer tests passed'
