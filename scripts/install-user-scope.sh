#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
codex_home="${CODEX_HOME:-$HOME/.codex}"
skills_dir="$codex_home/skills"

mkdir -p "$skills_dir"

rsync -a --delete \
  --exclude .git \
  --exclude .DS_Store \
  --exclude skills \
  "$repo_root/" "$skills_dir/orchestrate/"

rsync -a --delete \
  "$repo_root/skills/orchestrator-setup/" \
  "$skills_dir/orchestrator-setup/"

rsync -a --delete \
  "$repo_root/skills/orchestrator-status/" \
  "$skills_dir/orchestrator-status/"

rsync -a --delete \
  "$repo_root/skills/orchestrator-recover/" \
  "$skills_dir/orchestrator-recover/"

rsync -a --delete \
  "$repo_root/skills/orchestrator-doctor/" \
  "$skills_dir/orchestrator-doctor/"

rsync -a --delete \
  "$repo_root/skills/orchestrator-update/" \
  "$skills_dir/orchestrator-update/"

python3 "$codex_home/skills/.system/skill-creator/scripts/quick_validate.py" "$skills_dir/orchestrate"
python3 "$codex_home/skills/.system/skill-creator/scripts/quick_validate.py" "$skills_dir/orchestrator-setup"
python3 "$codex_home/skills/.system/skill-creator/scripts/quick_validate.py" "$skills_dir/orchestrator-status"
python3 "$codex_home/skills/.system/skill-creator/scripts/quick_validate.py" "$skills_dir/orchestrator-recover"
python3 "$codex_home/skills/.system/skill-creator/scripts/quick_validate.py" "$skills_dir/orchestrator-doctor"
python3 "$codex_home/skills/.system/skill-creator/scripts/quick_validate.py" "$skills_dir/orchestrator-update"

echo "Installed orchestrate, orchestrator-setup, orchestrator-status, orchestrator-recover, orchestrator-doctor, and orchestrator-update into $skills_dir"
