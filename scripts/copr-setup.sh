#!/usr/bin/env bash
set -euo pipefail

# Create the COPR project and set GitHub Actions secrets.
# Requires copr-cli and gh to be authenticated.

project="${1:-devin-desktop}"
username=$(sed -nE 's/^[[:space:]]*username[[:space:]]*[:=][[:space:]]*//p' ~/.config/copr | head -n1 | tr -d '[:space:]')
[[ -n "$username" ]] || { echo "failed to parse username from ~/.config/copr" >&2; exit 1; }
copr_project="$username/$project"

copr-cli create \
  --chroot fedora-rawhide-x86_64 \
  --chroot fedora-44-x86_64 \
  --chroot fedora-43-x86_64 \
  "$project"

gh secret set COPR_CONFIG --body ~/.config/copr
gh secret set COPR_PROJECT --body "$copr_project"
