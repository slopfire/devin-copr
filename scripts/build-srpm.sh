#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 4 ]]; then
  echo "usage: $0 VERSION TIMESTAMP_MS URL SHA256" >&2
  exit 64
fi

version="$1"
timestamp_ms="$2"
url="$3"
sha256="$4"

topdir="$PWD/rpmbuild"
mkdir -p "$topdir"/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}

./scripts/prepare-source.sh "$version" "$url" "$sha256" "$topdir/SOURCES"
install -pm0755 packaging/devin-desktop "$topdir/SOURCES/devin-desktop"
install -pm0644 packaging/devin-desktop.desktop "$topdir/SOURCES/devin-desktop.desktop"

release_date="$(date -u -d "@$((timestamp_ms / 1000))" +%Y%m%dT%H%M%S)"
changelog_date="$(date -u -d "@$((timestamp_ms / 1000))" +"%a %b %d %Y")"

./scripts/render-spec.sh "$version" "$release_date" "$changelog_date" "$topdir/SPECS/devin-desktop.spec"

rpmbuild --define "_topdir $topdir" -bs "$topdir/SPECS/devin-desktop.spec"
