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

"$REPOSITORY_ROOT/install.sh" --target "$PROJECT" --all --copy

test -f "$PROJECT/.hdae/manifest"
test -f "$PROJECT/.hdae/skills/hdae-development/SKILL.md"
test -f "$PROJECT/.hdae/skills/pr-issue-review/SKILL.md"
test -L "$PROJECT/.agents/skills/hdae-development"
test -L "$PROJECT/.claude/skills/pr-issue-review"
test -f "$PROJECT/.agents/skills/hdae-development/SKILL.md"

# Reinstalling an unchanged managed copy must be idempotent.
"$REPOSITORY_ROOT/install.sh" --target "$PROJECT" --all --copy

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
