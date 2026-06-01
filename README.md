# ai-agents-wiki

A curated, living knowledge base tracking AI agent engineering concepts — architectures, best practices, and tooling — sourced from blogs, transcripts, and newsletters. Two cron-driven Claude agents maintain it daily with no human intervention.

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
  Mon–Sat 2 AM ──► scripts/ingest.sh ──► claude < prompts/ingest-prompt.md
                       │
                       ├──────────────────────────────────►  outputs/
                       │   writes pages, updates              (Obsidian vault)
                       │   log.md + index.md
                       │
                       │  (if new content found)
                       ├──► scripts/update-advisor-prompt.sh ►  prompts/advisor-prompt.md
                       │                                          advisor-prompt-history/
                       │
                       └──► git commit + push

  Mon–Sat 3 AM ──► scripts/advisor.sh ──► claude < prompts/advisor-prompt.md
                       │
                       └──────────────────────────────────►  leb-news-analysis/
                                                               docs/advisor/LATEST.md

  Sunday  2 AM ──► scripts/healthcheck.sh ──► claude < prompts/healthcheck-prompt.md
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
  ├── scripts/
  │   ├── ingest.sh                   ← Mon–Sat 2 AM cron entry point
  │   ├── advisor.sh                  ← Mon–Sat 3 AM cron entry point
  │   ├── healthcheck.sh              ← Sunday 2 AM cron entry point
  │   └── update-advisor-prompt.sh   ← refreshes advisor-prompt.md after ingest
  ├── prompts/
  │   ├── ingest-prompt.md            ← ingest agent prompt
  │   ├── advisor-prompt.md           ← advisor agent prompt (auto-updated)
  │   ├── healthcheck-prompt.md       ← health-check agent prompt
  │   └── update-advisor-prompt-prompt.md ← prompt for the updater agent
  ├── advisor-prompt-history/         ← daily snapshots of advisor-prompt.md (last 15 kept)
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
