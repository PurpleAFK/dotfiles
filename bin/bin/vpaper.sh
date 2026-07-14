#!/usr/bin/env bash
# vpaper <citekey>  →  ~/convergence/paper/<citekey>.md
set -euo pipefail
VAULT="$HOME/convergence"
KEY="${1:?usage: vpaper <citekey>}"
BIB="$VAULT/refs/library.bib"
FILE="$VAULT/paper/$KEY.md"

# Verify the key exists in the bib file
if ! grep -q "^@[a-zA-Z]\+{$KEY," "$BIB" 2>/dev/null; then
  echo "warning: citekey '$KEY' not found in $BIB" >&2
fi

if [ ! -f "$FILE" ]; then
  cp "$VAULT/_templates/paper.md" "$FILE"
  sed -i "s|citekey:|citekey: $KEY|g; s|<% tp.date.now(\"YYYY-MM-DD\") %>|$(date +%F)|g" "$FILE"
fi
exec nvim "$FILE"
