#!/usr/bin/env bash
set -euo pipefail
VAULT="$HOME/convergence"
TITLE="${*:?usage: vcp <problem slug or title>}"
SLUG="$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | tr -c '[:alnum:]' '-' | sed -E 's/-+/-/g; s/^-|-$//g')"
FILE="$VAULT/cp/postmortems/$(date +%F)-$SLUG.md"
mkdir -p "$(dirname "$FILE")"
if [ ! -f "$FILE" ]; then
  cp "$VAULT/_templates/cp-problem.md" "$FILE"
  sed -i "s|{{title}}|$TITLE|g; s|<% tp.date.now(\"YYYY-MM-DD\") %>|$(date +%F)|g" "$FILE"
fi
exec nvim "$FILE"
