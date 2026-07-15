#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 4 ]]; then
  echo "usage: $0 VERSION RELEASE_DATE CHANGELOG_DATE OUTPUT_SPEC" >&2
  exit 64
fi

version="$1"
release_date="$2"
changelog_date="$3"
output_spec="$4"

mkdir -p "$(dirname "$output_spec")"

sed -e "s/@VERSION@/$version/g" \
    -e "s/@RELEASE_DATE@/$release_date/g" \
    -e "s/@CHANGELOG_DATE@/$changelog_date/g" \
    devin-desktop.spec.in > "$output_spec"
