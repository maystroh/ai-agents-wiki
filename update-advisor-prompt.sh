#!/usr/bin/env bash
# Update advisor-prompt.md after a new ingest.
# Archives the current version, calls claude to patch it, prunes old archives.
# Called by ingest.sh — do not run on a schedule directly.

set -euo pipefail

WIKI_DIR="/home/ubuntu/knowledge-base-data/wikis/AIAgentsWiki"
HISTORY_DIR="$WIKI_DIR/advisor-prompt-history"
PROMPT_FILE="$WIKI_DIR/advisor-prompt.md"
UPDATE_PROMPT="$WIKI_DIR/update-advisor-prompt-prompt.md"
DATE=$(date -u +%Y-%m-%d)
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)

mkdir -p "$HISTORY_DIR"

# Archive today's version (overwrite if run more than once today)
cp "$PROMPT_FILE" "$HISTORY_DIR/${DATE}.md"
echo "[$TIMESTAMP] Archived advisor-prompt.md → advisor-prompt-history/${DATE}.md"

# Keep only the last 15 daily archives
ls -t "$HISTORY_DIR"/*.md 2>/dev/null | tail -n +16 | xargs -r rm --

echo "[$TIMESTAMP] Running advisor-prompt updater..."

/home/ubuntu/.local/bin/claude \
  --print \
  --dangerously-skip-permissions \
  --add-dir /home/ubuntu/knowledge-base-data \
  < "$UPDATE_PROMPT"

echo "[$TIMESTAMP] Advisor-prompt update complete."
