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

# Incompatible update and link modes must fail before changing the target.
UPDATE_LINK_PROJECT=$TEST_ROOT/update-link-project
mkdir -p "$UPDATE_LINK_PROJECT"
git -C "$UPDATE_LINK_PROJECT" init -q
if HDAE_REPOSITORY_URL=$REPOSITORY_ROOT \
    "$REPOSITORY_ROOT/install.sh" --target "$UPDATE_LINK_PROJECT" --all --update --link \
    >"$TEST_ROOT/update-link.out" 2>&1; then
    echo 'update and link modes were accepted together' >&2
    exit 1
fi
grep -q -- '--link cannot be combined with --update or --version' \
    "$TEST_ROOT/update-link.out"
test ! -e "$UPDATE_LINK_PROJECT/.hdae"
test ! -e "$UPDATE_LINK_PROJECT/.agents"
test ! -e "$UPDATE_LINK_PROJECT/.claude"

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
grep -q "source=$STDIN_SOURCE@main" "$STDIN_PROJECT/.hdae/manifest"
"$STDIN_PROJECT/.hdae/install.sh" --target "$STDIN_PROJECT" --all --copy \
    >"$TEST_ROOT/stdin-reinstall.out"

"$REPOSITORY_ROOT/install.sh" --target "$PROJECT" --all --copy

test -f "$PROJECT/.hdae/manifest"
test -f "$PROJECT/.hdae/skills/hdae-development/SKILL.md"
test -f "$PROJECT/.hdae/skills/pr-issue-review/SKILL.md"
test -L "$PROJECT/.agents/skills/hdae-development"
test -L "$PROJECT/.claude/skills/pr-issue-review"
test -f "$PROJECT/.agents/skills/hdae-development/SKILL.md"
grep -q '^agents_bootstrap=1$' "$PROJECT/.hdae/manifest"
grep -q '^# Project instructions$' "$PROJECT/AGENTS.md"
grep -q '^Keep this user-authored instruction\.$' "$PROJECT/AGENTS.md"
test "$(grep -Fxc '<!-- hdae:context-recovery:start -->' "$PROJECT/AGENTS.md")" -eq 1
test "$(grep -Fxc '<!-- hdae:context-recovery:end -->' "$PROJECT/AGENTS.md")" -eq 1

# Reinstalling an unchanged managed copy must be idempotent.
"$REPOSITORY_ROOT/install.sh" --target "$PROJECT" --all --copy
test "$(grep -Fxc '<!-- hdae:context-recovery:start -->' "$PROJECT/AGENTS.md")" -eq 1

# The installed entry point must also support an idempotent local reinstall.
"$PROJECT/.hdae/install.sh" --target "$PROJECT" --all --copy
grep -q '^version=0.1.1$' "$PROJECT/.hdae/manifest"

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
