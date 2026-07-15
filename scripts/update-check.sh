#!/usr/bin/env bash
set -euo pipefail

api_url="https://windsurf-stable.codeium.com/api/update/linux-x64/stable/latest"
last_built_file="packaging/last-built.json"
force="${FORCE:-false}"

json=$(curl --fail --silent --show-error --location "$api_url")
version=$(jq -r '.windsurfVersion' <<<"$json")
timestamp=$(jq -r '.timestamp' <<<"$json")
commit=$(jq -r '.version' <<<"$json")
url=$(jq -r '.url' <<<"$json")
sha256=$(jq -r '.sha256hash' <<<"$json")

echo "version=$version"
echo "timestamp=$timestamp"
echo "commit=$commit"
echo "url=$url"
echo "sha256=$sha256"

if [[ "$force" == "true" ]]; then
  echo "should_build=true"
  exit 0
fi

if [[ ! -f "$last_built_file" ]]; then
  echo "should_build=true"
  exit 0
fi

last_version=$(jq -r '.windsurfVersion' <"$last_built_file")
last_timestamp=$(jq -r '.timestamp' <"$last_built_file")
last_commit=$(jq -r '.version' <"$last_built_file")

if [[ "$version" != "$last_version" || "$timestamp" != "$last_timestamp" || "$commit" != "$last_commit" ]]; then
  echo "should_build=true"
else
  echo "should_build=false"
fi
