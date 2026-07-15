#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 4 ]]; then
  echo "usage: $0 VERSION URL SHA256 SOURCES_DIR" >&2
  exit 64
fi

version="$1"
url="$2"
sha256="$3"
sources_dir="$4"

asset="Devin-linux-x64-${version}.tar.gz"
target="$sources_dir/$asset"

mkdir -p "$sources_dir"
curl --fail --location --retry 3 --output "$target" "$url"
echo "$sha256  $target" | sha256sum -c
