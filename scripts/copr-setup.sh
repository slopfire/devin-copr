#!/usr/bin/env bash
set -euo pipefail

# Create the COPR project and set GitHub Actions secrets.
# Requires copr-cli and gh to be authenticated.

project="${1:-devin-desktop}"
username=$(python3 - <<'PY'
import configparser, pathlib
c = configparser.ConfigParser()
c.read(pathlib.Path.home() / '.config' / 'copr')
print(c['general']['username'])
PY
)
copr_project="$username/$project"

copr-cli create \
  --chroot fedora-40-x86_64 \
  --chroot fedora-41-x86_64 \
  --chroot fedora-42-x86_64 \
  "$project"

gh secret set COPR_CONFIG --body ~/.config/copr
gh secret set COPR_PROJECT --body "$copr_project"
