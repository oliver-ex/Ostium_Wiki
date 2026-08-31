#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
site_root="$(cd "$script_dir/.." && pwd)"
vault_content="${1:-$site_root/../Ostium_Campaign_Wiki/content}"

if [[ ! -d "$vault_content" ]]; then
  echo "Vault content directory not found: $vault_content" >&2
  exit 1
fi

rsync -av --delete \
  --exclude='_GM/' \
  --exclude='_Templates/' \
  --exclude='.obsidian/' \
  "$vault_content/" \
  "$site_root/content/"

if find "$site_root/content" -type d \( -name '_GM' -o -name '_Templates' -o -name '.obsidian' \) -print -quit | grep -q .; then
  echo "Privacy check failed: a private or excluded directory exists in website content." >&2
  exit 1
fi

echo "Player-safe Ostium content synchronized."
