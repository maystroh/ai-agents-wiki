# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

An automated AI Agents Wiki — a curated, living knowledge base tracking AI agent engineering concepts (architectures, best practices, tooling) sourced from blog posts, transcripts, and newsletters dated 2025–2026. Two cron-driven Claude agents maintain it daily.

## Running the Agents Manually

```bash
# Run the ingest agent (normally 2 AM UTC)
/home/ubuntu/knowledge-base-data/wikis/AIAgentsWiki/ingest.sh

# Run the advisor agent (normally 3 AM UTC, after ingest)
/home/ubuntu/knowledge-base-data/wikis/AIAgentsWiki/advisor.sh

# Run the advisor-prompt updater in isolation (normally called by ingest.sh automatically)
/home/ubuntu/knowledge-base-data/wikis/AIAgentsWiki/update-advisor-prompt.sh
```

Both cron scripts call `claude --print --dangerously-skip-permissions` with a prompt file. Logs land in `cron-logs/`. Run history is in `cron-logs/runs.md` and `cron-logs/advisor-runs.md` (append-only, never deleted). The last 30 detail logs per agent are retained.

## Adding New Source Files

Edit `input_files.json`. Entries are either exact file paths or `<dir>/*` wildcard patterns. The next ingest run picks them up automatically by diffing against `outputs/log.md`.

## Architecture

```
wikis/AIAgentsWiki/
├── input_files.json               ← watched source paths
├── ingest.sh                      ← daily ingest cron entry point (2 AM UTC)
├── ingest-prompt.md               ← self-contained prompt for the ingest agent
├── advisor.sh                     ← daily advisor cron entry point (3 AM UTC)
├── advisor-prompt.md              ← self-contained prompt for the advisor agent
├── update-advisor-prompt.sh       ← called by ingest.sh after new content is found
├── update-advisor-prompt-prompt.md← prompt for the advisor-prompt updater agent
├── advisor-prompt-history/        ← daily snapshots of advisor-prompt.md (last 15 kept)
├── cron-logs/                     ← run history and detail logs
└── outputs/                       ← the wiki itself (Obsidian vault)
    ├── CLAUDE.md         ← wiki schema and page conventions (read this before editing wiki pages)
    ├── index.md          ← full catalog of all pages (updated every ingest)
    ← log.md              ← append-only ingest log (source of truth for what's been ingested)
    ├── overview.md       ← high-level synthesis and evolving thesis
    ├── concepts/         ← one page per key concept
    ├── sources/          ← one summary page per source, mirroring raw dir structure
    └── entities/         ← people.md and tools-products.md
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
