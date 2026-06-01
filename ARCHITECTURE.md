╔══════════════════════════════════════════════════════════════════════════════════╗
║                      AIAgentsWiki — Architecture & Data Flow                    ║
╚══════════════════════════════════════════════════════════════════════════════════╝

 ┌──────────────────────────────────────────────────────────────────────────────┐
 │  RAW SOURCES  /knowledge-base-data/raw/                                      │
 │                                                                               │
 │  philschmid/   AI Agents/   Karpathy/   Misc/   Import_AI/   …              │
 └───────────────────────────────┬──────────────────────────────────────────────┘
                                  │  ▲ paths watched via input_files.json
                                  │
                       ┌──────────▼──────────┐
    2:00 AM UTC ──────►│    ingest.sh        │◄── cron
                       └──────────┬──────────┘
                                  │ calls claude --print
                       ┌──────────▼────────────────────────────┐
                       │  Claude — Ingest Agent                 │◄── ingest-prompt.md
                       │                                        │
                       │  1. expand input_files.json wildcards  │
                       │  2. diff discovered files vs log.md    │
                       │  3. for each new file:                 │
                       │       · create sources/<cat>/<slug>.md │
                       │       · patch relevant concepts/       │
                       │       · patch entities/                │
                       │  4. update index.md                    │
                       │  5. append to log.md                   │
                       └──────────┬────────────────────────────┘
                                  │ writes
                       ┌──────────▼────────────────────────────────────────┐
                       │  outputs/  (Obsidian vault)                        │
                       │                                                     │
                       │  index.md      ← full page catalog                 │
                       │  log.md        ← append-only ingest ledger         │
                       │  overview.md   ← evolving synthesis & thesis       │
                       │  concepts/     ← one .md per key concept           │
                       │  sources/      ← one .md per source document       │
                       │  entities/     ← people.md  tools-products.md      │
                       └────────────────────────────────────────────────────┘
                                  │
                       ┌──────────▼──────────────────────────────┐
                       │  ingest.sh: check log.md last header    │
                       └──────────┬──────────────────────────────┘
                    "check |"     │     "ingest |"
            (nothing new) ◄───────┴──────────► (new content found)
                  stop                                 │
                                           ┌──────────▼──────────────────┐
                                           │  update-advisor-prompt.sh   │
                                           │                              │
                                           │  1. cp advisor-prompt.md ───┼──► advisor-prompt-history/
                                           │        → YYYY-MM-DD.md      │     YYYY-MM-DD.md
                                           │        (keep last 15)       │     (last 15 days)
                                           │  2. call updater agent      │
                                           └──────────┬───────────────────┘
                                                      │ calls claude --print
                                           ┌──────────▼────────────────────────────────┐
                                           │  Claude — Prompt Updater Agent             │◄── update-advisor-
                                           │                                            │    prompt-prompt.md
                                           │  reads: log.md (latest ingest block)      │
                                           │  reads: index.md + new concept/entity pages│
                                           │  writes: advisor-prompt.md                │
                                           │    · adds new concepts/ to reading list   │
                                           │    · adds new entities/ if any            │
                                           │    · no-op if nothing structurally new    │
                                           └──────────┬─────────────────────────────────┘
                                                      │ patches (or leaves unchanged)
                                           ┌──────────▼──────────────────┐
                                           │  advisor-prompt.md          │
                                           │  (self-updating — always    │
                                           │   lists current concept     │
                                           │   pages to read)            │
                                           └──────────┬───────────────────┘
                                                      │
                                           ┌──────────▼──────────┐
                    3:00 AM UTC ──────────►│    advisor.sh        │◄── cron
                                           └──────────┬───────────┘
                                                      │ skips if no new commits
                                                      │ in leb-news-analysis (24h)
                                                      │ calls claude --print
                                           ┌──────────▼────────────────────────────────┐
                                           │  Claude — Advisor Agent                    │◄── advisor-prompt.md
                                           │                                            │
                                           │  reads: wiki overview + concepts + log     │
                                           │  reads: leb-news-analysis/                 │
                                           │    CLAUDE.md · ARCHITECTURE.md · git log  │
                                           │    pipeline stages · prompts · plans       │
                                           │  writes: morning advisory report           │
                                           └──────────┬─────────────────────────────────┘
                                                      │ writes
                                           ┌──────────▼──────────────────────┐
                                           │  leb-news-analysis/docs/advisor/ │
                                           │                                   │
                                           │  LATEST.md    ← always current   │
                                           │  YYYY-MM-DD.md ← dated archive   │
                                           └───────────────────────────────────┘

 ┌──────────────────────────────────────────────────────────────────────────────┐
 │  OBSERVABILITY  cron-logs/                                                   │
 │                                                                               │
 │  runs.md             append-only ingest run history      (never pruned)      │
 │  advisor-runs.md     append-only advisor run history     (never pruned)      │
 │  TIMESTAMP.log       full claude output per ingest run   (last 30 kept)      │
 │  advisor-TIMESTAMP.log  full claude output per advisor   (last 30 kept)      │
 └──────────────────────────────────────────────────────────────────────────────┘
