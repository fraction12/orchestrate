#!/usr/bin/env bash
set -euo pipefail

repo_url="${ORCHESTRATE_REPO_URL:-https://github.com/fraction12/orchestrate.git}"
ref="${ORCHESTRATE_REF:-main}"
tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/orchestrate-update.XXXXXX")"
clone_dir="$tmp_dir/orchestrate"

cleanup() {
  rm -rf "$tmp_dir"
}
trap cleanup EXIT

echo "Fetching Orchestrator from $repo_url ($ref)"

git clone --quiet --depth 1 "$repo_url" "$clone_dir"
git -C "$clone_dir" fetch --quiet --depth 1 origin "$ref"
git -C "$clone_dir" checkout --quiet FETCH_HEAD

commit="$(git -C "$clone_dir" rev-parse --short HEAD)"

bash "$clone_dir/scripts/install-user-scope.sh"

echo "Updated Orchestrator skills from $repo_url at $commit"
