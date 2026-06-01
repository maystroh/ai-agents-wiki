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
  2 AM UTC ──► ingest.sh ──► claude < ingest-prompt.md
                   │
                   ├─────────────────────────────────────►  outputs/
                   │   writes pages, updates log.md            (Obsidian vault)
                   │
                   │  (if new content found)
                   ├──► update-advisor-prompt.sh ─────────►  advisor-prompt.md
                   │                                           advisor-prompt-history/
                   │
                   └──► git commit + push

  3 AM UTC ──► advisor.sh ──► claude < advisor-prompt.md
                   │
                   └─────────────────────────────────────►  leb-news-analysis/
                                                              docs/advisor/LATEST.md

  Logs: cron-logs/runs.md · cron-logs/advisor-runs.md  (append-only, last 30 detail logs kept)

─────────────────────────────────────────────────────────────────────────

  AIAgentsWiki/
  ├── input_files.json                ← watched source paths
  ├── ingest.sh                       ← 2 AM UTC cron entry point
  ├── ingest-prompt.md                ← ingest agent prompt
  ├── advisor.sh                      ← 3 AM UTC cron entry point
  ├── advisor-prompt.md               ← advisor agent prompt (auto-updated)
  ├── advisor-prompt-history/         ← daily snapshots (last 15 kept)
  ├── update-advisor-prompt.sh        ← refreshes advisor-prompt.md after ingest
  ├── update-advisor-prompt-prompt.md ← prompt for the updater agent
  ├── cron-logs/                      ← run history + detail logs
  └── outputs/                        ← the wiki (Obsidian vault)
      ├── CLAUDE.md                   ← wiki schema & page conventions
      ├── log.md                      ← append-only ingest ledger
      ├── index.md                    ← full page catalog
      ├── overview.md                 ← high-level synthesis
      ├── concepts/                   ← one page per key concept
      ├── sources/                    ← one page per source file
      └── entities/
          ├── people.md
          └── tools-products.md
```
