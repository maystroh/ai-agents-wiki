#!/usr/bin/env bash
# Daily wiki ingest — runs claude -p with the ingest prompt
# Cron: 0 2 * * *  (2 AM UTC)

set -euo pipefail

WIKI_DIR="/home/ubuntu/knowledge-base-data/wikis/AIAgentsWiki"
LOG_DIR="$WIKI_DIR/cron-logs"
RUNS_LOG="$LOG_DIR/runs.md"
PROMPT_FILE="$WIKI_DIR/prompts/ingest-prompt.md"
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
LOG_FILE="$LOG_DIR/${TIMESTAMP}.log"

mkdir -p "$LOG_DIR"

# Initialise runs.md on first run
if [ ! -f "$RUNS_LOG" ]; then
  printf '# Wiki Ingest — Run History\n\nAppend-only log of every launch.\n\n| Timestamp (UTC) | Outcome | Detail log |\n|---|---|---|\n' > "$RUNS_LOG"
fi

echo "[$TIMESTAMP] Starting wiki ingest..." | tee "$LOG_FILE"

EXIT_CODE=0
/home/ubuntu/.local/bin/claude \
  --print \
  --dangerously-skip-permissions \
  --add-dir /home/ubuntu/knowledge-base-data \
  < "$PROMPT_FILE" \
  >> "$LOG_FILE" 2>&1 || EXIT_CODE=$?

END_TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)

if [ "$EXIT_CODE" -eq 0 ]; then
  OUTCOME="✓ ok"
else
  OUTCOME="✗ failed (exit $EXIT_CODE)"
fi

echo "[$END_TIMESTAMP] Done — $OUTCOME" | tee -a "$LOG_FILE"

# Append one row to the persistent runs log
printf '| %s | %s | %s |\n' "$TIMESTAMP" "$OUTCOME" "${TIMESTAMP}.log" >> "$RUNS_LOG"

# Keep only last 30 individual run logs (runs.md is never deleted)
ls -t "$LOG_DIR"/*.log 2>/dev/null | tail -n +31 | xargs -r rm --

# If new content was ingested, update advisor-prompt.md to reflect new concepts/entities
if [ "$EXIT_CODE" -eq 0 ]; then
  LAST_LOG_HEADER=$(grep '^## \[' "$WIKI_DIR/outputs/log.md" 2>/dev/null | tail -1)
  if echo "$LAST_LOG_HEADER" | grep -q '] ingest |'; then
    UPDATE_TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    echo "[$UPDATE_TIMESTAMP] New content detected — updating advisor-prompt.md..." | tee -a "$LOG_FILE"
    "$WIKI_DIR/scripts/update-advisor-prompt.sh" >> "$LOG_FILE" 2>&1 \
      || echo "[$UPDATE_TIMESTAMP] Advisor-prompt update failed (non-fatal)" | tee -a "$LOG_FILE"
  fi

  # Commit and push any wiki changes (new content or log-only check entry)
  COMMIT_TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  echo "[$COMMIT_TIMESTAMP] Committing and pushing wiki changes..." | tee -a "$LOG_FILE"
  GIT_ROOT=$(git -C "$WIKI_DIR" rev-parse --show-toplevel 2>/dev/null) || true
  if [ -n "$GIT_ROOT" ]; then
    git -C "$GIT_ROOT" add --all >> "$LOG_FILE" 2>&1 \
      && git -C "$GIT_ROOT" commit -m "wiki ingest: $TIMESTAMP" >> "$LOG_FILE" 2>&1 \
      && git -C "$GIT_ROOT" push >> "$LOG_FILE" 2>&1 \
      && echo "[$COMMIT_TIMESTAMP] Git push succeeded." | tee -a "$LOG_FILE" \
      || echo "[$COMMIT_TIMESTAMP] Git commit/push failed (non-fatal)." | tee -a "$LOG_FILE"
  else
    echo "[$COMMIT_TIMESTAMP] Not a git repository — skipping commit." | tee -a "$LOG_FILE"
  fi
fi
