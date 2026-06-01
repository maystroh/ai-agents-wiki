# AIAgentsWiki — Schema & Conventions

## Purpose
A persistent wiki tracking the state of AI agent engineering — architectures, best practices, tooling, and the evolving landscape of agentic systems. Built from curated sources (blog posts, transcripts, papers, newsletters) dated 2025–2026.

## Directory Structure

```
wikis/AIAgentsWiki/
├── input_files.json    ← Watched paths (exact files + wildcard dirs)
├── ingest.sh           ← Cron entry point (runs daily at 2 AM UTC)
├── ingest-prompt.md    ← Self-contained prompt used by ingest.sh
├── cron-logs/          ← One log file per run, last 30 kept
└── outputs/
    ├── CLAUDE.md           ← This file. Schema and conventions.
    ├── index.md            ← Full catalog of all wiki pages (updated on every ingest)
    ├── log.md              ← Append-only ingest/query/lint log
    ├── overview.md         ← High-level synthesis and evolving thesis
    ├── concepts/           ← One page per key concept or theme
    ├── sources/            ← One summary page per source document
    │   ├── philschmid/
    │   ├── misc/
    │   ├── karpathy/
    │   ├── ai-agents/
    │   ├── ai-startups/
    │   ├── machine-learning/
    │   ├── prompt-engineering/
    │   └── (one file per standalone source)
    └── entities/           ← People, tools, products referenced across sources
```

## Page Conventions

### Concept pages (`concepts/`)
- **Filename**: kebab-case, e.g. `agent-harness.md`
- **Frontmatter**: `title`, `tags`, `sources` (list of source filenames), `updated`
- **Sections**: Definition → Why it matters → Key patterns/variants → Tensions & tradeoffs → Related concepts → Sources
- Cross-reference with `[[page-name]]` wikilinks

### Source summary pages (`sources/`)
- **Frontmatter**: `title`, `author`, `date`, `url`, `tags`
- **Sections**: Summary (3–5 bullets) → Key insights → Concepts touched → Notable quotes
- One page per source. Never modify the raw source.

### Entity pages (`entities/`)
- People: role, affiliation, key claims/contributions
- Tools: what it is, key capabilities, when to use

## Wikilink Convention
Use `[[filename-without-extension]]` for cross-references. Use `[[filename|Display text]]` when the display text differs from the filename.

## Tagging
Tags live in frontmatter. Common tags: `harness`, `skills`, `context-engineering`, `subagents`, `runtime`, `evals`, `autoresearch`, `mcp`, `agent-engineering`.

## Automated Ingest (Daily Cron)

A cron job runs every day at **2 AM UTC**:
```
/home/ubuntu/knowledge-base-data/wikis/AIAgentsWiki/ingest.sh
```
It calls `claude --print --dangerously-skip-permissions` with `ingest-prompt.md`.

**What it does:**
1. Reads `input_files.json` — expands wildcard paths (`/*`) recursively via `find`
2. Reads `log.md` to determine what has already been ingested
3. Diffs to find new files only
4. For each new file: creates source page, updates concept pages and entities
5. Updates `index.md` and appends to `log.md`
6. If nothing is new, writes a one-line `check` entry to `log.md`

**To add new sources:** edit `input_files.json` — add exact file paths or new `<dir>/*` wildcard entries. The next cron run picks them up automatically.

**To run manually:**
```bash
/home/ubuntu/knowledge-base-data/wikis/AIAgentsWiki/ingest.sh
```

**Run history:** `cron-logs/runs.md` — persistent append-only table of every launch (never deleted). Columns: timestamp, outcome (✓ ok / ✗ failed), link to detail log.

**Detail logs:** `cron-logs/<timestamp>.log` — full claude output per run (last 30 retained).

## Daily Advisor (3 AM UTC)

A second cron job runs at **3 AM UTC** (one hour after ingest, so it sees fresh wiki content):
```
/home/ubuntu/knowledge-base-data/wikis/AIAgentsWiki/advisor.sh
```

**What it does:** Acts as an AI agent engineering expert that reads the latest wiki and compares it against the Radar Beirut project (`/home/ubuntu/leb-news-analysis`), then writes a structured morning report.

**Report output:**
- `/home/ubuntu/leb-news-analysis/docs/advisor/LATEST.md` — always the most recent report
- `/home/ubuntu/leb-news-analysis/docs/advisor/YYYY-MM-DD.md` — dated archive

**Report sections:**
1. What I understood about the project today
2. 💡 Feature Ideas — grounded in wiki concepts, specific to the project
3. ❓ Questions to investigate
4. 🔍 Gap analysis — wiki concepts not yet in the project
5. 🧠 Single best recommendation for the week

**Run history:** `cron-logs/advisor-runs.md` (persistent)
**Detail logs:** `cron-logs/advisor-<timestamp>.log` (last 30 retained)

**To run manually:**
```bash
/home/ubuntu/knowledge-base-data/wikis/AIAgentsWiki/advisor.sh
```

## Manual Ingest Workflow
1. Read source → discuss key takeaways
2. Write source summary in `sources/<category>/`
3. Update relevant concept pages
4. Update `index.md`
5. Append to `log.md`

## Query Workflow
1. Read `index.md` to identify relevant pages
2. Read those pages
3. Synthesize answer (can be filed back as a new page or section)

## Lint Checks
- Orphan pages (no inbound links)
- Concept pages missing key sources
- Stale claims superseded by newer sources
- Missing cross-references between tightly related pages
