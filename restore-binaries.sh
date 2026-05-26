#!/usr/bin/env bash
# Restore binary files that were base64-encoded during MCP-based import.
#
# Files ending in `.b64`          -> decoded in place (drop the .b64 suffix).
# Files ending in `.b64.part-NN-of-MM` -> chunks concatenated then decoded.
#
# After running, the original binary files exist alongside the .b64* shards.
# By default the .b64 shards are kept; pass --clean to delete them.
set -euo pipefail

CLEAN=0
[[ "${1:-}" == "--clean" ]] && CLEAN=1

# 1) Plain .b64 files
while IFS= read -r -d '' f; do
  out="${f%.b64}"
  base64 -d "$f" > "$out"
  echo "restored: $out"
  [[ $CLEAN -eq 1 ]] && rm -f "$f"
done < <(find . -type f -name '*.b64' ! -name '*.b64.part-*' -print0)

# 2) Chunked .b64.part-NN-of-MM
#    Group by stripping the .part-NN-of-MM suffix.
declare -A SEEN
while IFS= read -r -d '' f; do
  base="${f%.b64.part-*}"
  if [[ -z "${SEEN[$base]:-}" ]]; then
    SEEN[$base]=1
    # Concatenate all parts in lexical order, decode
    cat "$base".b64.part-* | base64 -d > "$base"
    echo "restored: $base"
    if [[ $CLEAN -eq 1 ]]; then
      rm -f "$base".b64.part-*
    fi
  fi
done < <(find . -type f -name '*.b64.part-*' -print0)

echo "done."
