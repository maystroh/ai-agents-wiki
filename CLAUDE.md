# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

An automated AI Agents Wiki — a curated, living knowledge base tracking AI agent engineering concepts (architectures, best practices, tooling) sourced from blog posts, transcripts, and newsletters dated 2025–2026. Two cron-driven Claude agents maintain it daily.

## Running the Agents Manually

```bash
# Run the ingest agent (Mon–Sat 2 AM UTC)
/home/ubuntu/knowledge-base-data/wikis/AIAgentsWiki/ingest.sh

# Run the advisor agent (Mon–Sat 3 AM UTC, after ingest)
/home/ubuntu/knowledge-base-data/wikis/AIAgentsWiki/advisor.sh

# Run the weekly health-check agent (Sunday 2 AM UTC)
/home/ubuntu/knowledge-base-data/wikis/AIAgentsWiki/healthcheck.sh

# Run the advisor-prompt updater in isolation (normally called by ingest.sh automatically)
/home/ubuntu/knowledge-base-data/wikis/AIAgentsWiki/update-advisor-prompt.sh
```

All cron scripts call `claude --print --dangerously-skip-permissions` with a prompt file. Logs land in `cron-logs/`. Run history is in `cron-logs/runs.md`, `cron-logs/advisor-runs.md`, and `cron-logs/healthcheck-runs.md` (append-only, never deleted). The last 30 detail logs per agent are retained.

## Adding New Source Files

Edit `input_files.json`. Entries are either exact file paths or `<dir>/*` wildcard patterns. The next ingest run picks them up automatically by diffing against `outputs/log.md`.

## Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                            AI Agents Wiki                               │
│               Automated, cron-driven AI knowledge base                  │
└─────────────────────────────────────────────────────────────────────────┘

                      ┌───────────────────────────┐
                      │    /raw/ source files      │
                      │  blogs · transcripts ·     │
                      │  newsletters               │
                      └─────────────┬─────────────┘
                                    │  watched via input_files.json
                                    ▼
  Mon–Sat 2 AM ──► ingest.sh ──► claude < ingest-prompt.md
                       │
                       ├──────────────────────────────────►  outputs/
                       │   writes pages, updates              (Obsidian vault)
                       │   log.md + index.md
                       │
                       │  (if new content found)
                       ├──► update-advisor-prompt.sh ──────►  advisor-prompt.md
                       │                                        advisor-prompt-history/
                       │
                       └──► git commit + push

  Mon–Sat 3 AM ──► advisor.sh ──► claude < advisor-prompt.md
                       │
                       └──────────────────────────────────►  leb-news-analysis/
                                                               docs/advisor/LATEST.md

  Sunday  2 AM ──► healthcheck.sh ──► claude < healthcheck-prompt.md
                       │
                       ├──────────────────────────────────►  outputs/health-reports/
                       │   LATEST.md + YYYY-MM-DD.md           (contradictions, stale
                       │                                        claims, orphans, gaps)
                       │
                       └──► git commit + push

  Logs: cron-logs/runs.md · cron-logs/advisor-runs.md · cron-logs/healthcheck-runs.md
        (append-only, last 30 detail logs per agent kept)

─────────────────────────────────────────────────────────────────────────

  AIAgentsWiki/
  ├── input_files.json                ← watched source paths
  ├── ingest.sh                       ← Mon–Sat 2 AM cron entry point
  ├── ingest-prompt.md                ← ingest agent prompt
  ├── advisor.sh                      ← Mon–Sat 3 AM cron entry point
  ├── advisor-prompt.md               ← advisor agent prompt (auto-updated)
  ├── advisor-prompt-history/         ← daily snapshots (last 15 kept)
  ├── update-advisor-prompt.sh        ← refreshes advisor-prompt.md after ingest
  ├── update-advisor-prompt-prompt.md ← prompt for the updater agent
  ├── healthcheck.sh                  ← Sunday 2 AM cron entry point
  ├── healthcheck-prompt.md           ← health-check agent prompt
  ├── cron-logs/                      ← run history + detail logs
  └── outputs/                        ← the wiki (Obsidian vault)
      ├── CLAUDE.md                   ← wiki schema & page conventions
      ├── log.md                      ← append-only ingest ledger
      ├── index.md                    ← full page catalog
      ├── overview.md                 ← high-level synthesis
      ├── concepts/                   ← one page per key concept
      ├── sources/                    ← one page per source file
      ├── entities/
      │   ├── people.md
      │   └── tools-products.md
      └── health-reports/             ← weekly audit reports
          ├── LATEST.md
          └── YYYY-MM-DD.md
```

The raw source files live at `/home/ubuntu/knowledge-base-data/raw/` (outside this repo).

The advisor agent also reads and writes to `/home/ubuntu/leb-news-analysis/` (a separate project). Its output is `/home/ubuntu/leb-news-analysis/docs/advisor/LATEST.md` and dated copies alongside it. The advisor skips itself if there are no new commits in `leb-news-analysis` in the last 24 hours.

## Wiki Page Conventions

Before creating or editing any page in `outputs/`, read `outputs/CLAUDE.md` for the authoritative schema. Key points:

- **Concept pages**: frontmatter with `title`, `tags`, `sources`, `updated`; sections: Definition → Why it matters → Key patterns → Tensions & tradeoffs → Related concepts → Sources
- **Source pages**: frontmatter with `title`, `author`, `date`, `url`, `tags`; sections: Summary (3–5 bullets) → Key insights → Concepts touched → Notable quotes
- **Wikilinks**: `[[filename-without-extension]]` or `[[filename|Display text]]`
- `outputs/log.md` is the ingest ledger — always append, never rewrite history

## How the Ingest Agent Works

1. Reads `input_files.json`, expands `/*` wildcards via `find`
2. Reads `log.md` to find already-ingested files
3. For each new file: creates `sources/<category>/<slug>.md`, updates relevant `concepts/` pages and `entities/` pages
4. Updates `index.md` and appends to `log.md`
5. If nothing is new, writes a one-line `check` entry to `log.md` and stops
