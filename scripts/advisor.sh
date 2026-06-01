#!/usr/bin/env bash
# Daily AI advisor — reads wiki + leb-news-analysis, writes morning report
# Cron: 0 3 * * *  (3 AM UTC, after 2 AM ingest)

set -euo pipefail

WIKI_DIR="/home/ubuntu/knowledge-base-data/wikis/AIAgentsWiki"
LOG_DIR="$WIKI_DIR/cron-logs"
RUNS_LOG="$LOG_DIR/advisor-runs.md"
PROMPT_FILE="$WIKI_DIR/prompts/advisor-prompt.md"
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
LOG_FILE="$LOG_DIR/advisor-${TIMESTAMP}.log"
OUTPUT_DIR="/home/ubuntu/leb-news-analysis/docs/advisor"

mkdir -p "$LOG_DIR" "$OUTPUT_DIR"

# Initialise advisor runs log on first run
if [ ! -f "$RUNS_LOG" ]; then
  printf '# Advisor — Run History\n\nAppend-only log of every advisor launch.\n\n| Timestamp (UTC) | Outcome | Detail log |\n|---|---|---|\n' > "$RUNS_LOG"
fi

# Skip if no new commits in leb-news-analysis in the last 24 hours
RECENT_COMMITS=$(git -C /home/ubuntu/leb-news-analysis log --since="24 hours ago" --oneline 2>/dev/null)
if [ -z "$RECENT_COMMITS" ]; then
  echo "[$TIMESTAMP] No new commits in leb-news-analysis in the last 24 hours — skipping." | tee "$LOG_FILE"
  printf '| %s | %s | %s |\n' "$TIMESTAMP" "⏭ skipped (no new commits)" "advisor-${TIMESTAMP}.log" >> "$RUNS_LOG"
  exit 0
fi

echo "[$TIMESTAMP] Starting advisor run..." | tee "$LOG_FILE"

EXIT_CODE=0
/home/ubuntu/.local/bin/claude \
  --print \
  --dangerously-skip-permissions \
  --add-dir /home/ubuntu/knowledge-base-data \
  --add-dir /home/ubuntu/leb-news-analysis \
  < "$PROMPT_FILE" \
  >> "$LOG_FILE" 2>&1 || EXIT_CODE=$?

END_TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)

if [ "$EXIT_CODE" -eq 0 ]; then
  OUTCOME="✓ ok"
else
  OUTCOME="✗ failed (exit $EXIT_CODE)"
fi

echo "[$END_TIMESTAMP] Done — $OUTCOME" | tee -a "$LOG_FILE"

# Append one row to the persistent advisor runs log
printf '| %s | %s | %s |\n' "$TIMESTAMP" "$OUTCOME" "advisor-${TIMESTAMP}.log" >> "$RUNS_LOG"

# Keep only last 30 individual advisor logs
ls -t "$LOG_DIR"/advisor-*.log 2>/dev/null | tail -n +31 | xargs -r rm --

# Commit and push new advisor doc to GitHub (only on success)
if [ "$EXIT_CODE" -eq 0 ]; then
  REPO=/home/ubuntu/leb-news-analysis
  git -C "$REPO" pull origin main >> "$LOG_FILE" 2>&1 \
    || echo "[$END_TIMESTAMP] WARNING: git pull --rebase failed." | tee -a "$LOG_FILE"
  # Keep only the last 4 dated advisor reports (YYYY-MM-DD.md); remove older ones from git
  find "$REPO/docs/advisor" -maxdepth 1 -name '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9].md' \
    | sort | head -n -4 \
    | xargs -r git -C "$REPO" rm -f --ignore-unmatch --
  git -C "$REPO" add docs/advisor/
  if ! git -C "$REPO" diff --cached --quiet; then
    git -C "$REPO" commit -m "chore(advisor): daily report ${TIMESTAMP}"
    git -C "$REPO" push origin main >> "$LOG_FILE" 2>&1 \
      && echo "[$END_TIMESTAMP] Pushed advisor doc to GitHub." | tee -a "$LOG_FILE" \
      || echo "[$END_TIMESTAMP] WARNING: git push failed." | tee -a "$LOG_FILE"
  fi
fi
