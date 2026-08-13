# Log

Append-only record of ingests, queries, and lint passes.

Format: `## [YYYY-MM-DD] type | description`

---

## [2026-05-24] ingest | Initial bulk ingest — 20 sources

**Sources ingested:**

philschmid series (12 articles, 2025-10 to 2026-05):
- 2025-10-12 Agents 2.0: From Shallow Loops to Deep Agents
- 2025-11-26 Why (Senior) Engineers Struggle to Build AI Agents
- 2025-12-04 Context Engineering for AI Agents: Part 2
- 2026-01-05 The Importance of Agent Harness in 2026
- 2026-02-17 Can We Close the Loop in 2026?
- 2026-02-20 Agents: Inner Loop vs Outer Loop
- 2026-02-24 Writing a Good AGENTS.md
- 2026-03-04 Practical Guide to Evaluating and Testing Agent Skills
- 2026-03-10 How Autoresearch Will Change Small Language Models Adoption
- 2026-04-13 8 Tips for Writing Agent Skills
- 2026-04-27 How to Correctly Use MCP Servers with Your AI Agents
- 2026-05-05 How Agents Manage Other Agents: Four Subagent Patterns in 2026

Misc (5 articles):
- 2026-04-04 Components of a Coding Agent (Sebastian Raschka)
- 2026-05-01 Designing, Refining, and Maintaining Agent Skills at Perplexity
- 2026-05-08 Hidden Technical Debt of AI Systems: Agent Harness (Han Lee)
- 2026-04-24 Hidden Technical Debt of AI Systems: Agent Runtime (Han Lee)
- 2026-05-03 How to Work and Compound with AI (Eugene Yan)

Karpathy (2 transcripts):
- 2026-03-20 Code Agents, AutoResearch, and the Loopy Era of AI
- 2026-04-29 From Vibe Coding to Agentic Engineering

Import AI (1 newsletter):
- 2026-05-04 Import AI 455: Automating AI Research (Jack Clark)

**Pages created:**
- overview.md
- concepts/agent-harness.md
- concepts/agent-skills.md
- concepts/subagent-patterns.md
- concepts/context-engineering.md
- concepts/inner-outer-loop.md
- concepts/agent-runtime.md
- concepts/automated-research.md
- concepts/agent-engineering.md
- concepts/closing-the-loop.md
- concepts/mcp-servers.md
- concepts/agents-evolution.md
- sources/philschmid/ (12 pages)
- sources/misc/ (5 pages)
- sources/karpathy/ (2 pages)
- sources/import-ai-455.md
- entities/people.md
- entities/tools-products.md
- index.md

---

## [2026-05-24] ingest | Bulk ingest — AI Agents, AI Startups, Machine Learning, Prompt Engineering directories (8 new sources)

**Sources ingested:**

AI Agents (3 unique sources, 2 duplicate archive dates):
- 2026-05-23 Claude Code Head Boris Cherny: Insane Growth, Tokenmaxxing, AI Agents' Next Frontier (Alex Kantrowitz interview)
- 2026-05-22 Building the Best Agentic Analytics Harness: Powered by Claude (Omni/Blobby)
- 2026-05-22 Memory and Dreaming for Self-Learning Agents (Ravi, Anthropic)

AI Startups (2 sources):
- 2026-05-19 $4B Box CEO: This Is The Best Time To Build An AI Company (Aaron Levy)
- 2026-05-19 Gary Vee: The AI Opportunity Is Real — But Most People Are Looking at It Wrong

Machine Learning (2 sources):
- 2026-05-15 Stanford CS153: Jensen Huang from NVIDIA on the Compute Behind Intelligence
- 2026-05-15 Personal AI Is the New Personal Computer (Gary Tan, YC)

Prompt Engineering (1 source):
- 2026-05-22 The Prompting Playbook (Margot Vanlar, Anthropic)

**Pages created:**
- sources/ai-agents/boris-cherny-claude-code.md
- sources/ai-agents/omni-analytics-harness.md
- sources/ai-agents/memory-and-dreaming.md
- sources/ai-startups/box-ceo-ai-company.md
- sources/ai-startups/gary-vee-ai-opportunity.md
- sources/machine-learning/jensen-huang-compute.md
- sources/machine-learning/personal-ai-gary-tan.md
- sources/prompt-engineering/prompting-playbook.md
- concepts/agent-memory.md (new concept: file-system memory + Dreaming)

**Pages updated:**
- entities/people.md (added: Boris Cherny fuller entry, Jensen Huang, Gary Tan, Aaron Levy, Margot Vanlar, Ravi, Gary Vee)
- entities/tools-products.md (added: Memory+Dreaming, Vera Rubin, Blobby, agency.org/Outshift)
- index.md (added: 4 new source sections, new concept, updated tag index and entity summaries)

---

## [2026-05-25] check | No new files found

---

## [2026-05-27] ingest | 5 new sources from ai-agents (4) and misc (1)

**Sources ingested:**
- 2026-05-26 Agents that Remember (Kevin, Anthropic) — memory store API, dreaming harness, index file optimization
- 2026-05-26 Beyond the Basics with Claude Code (Daisy Holman, Anthropic) — KV cache constraint, hooks as zero-overhead, MCP vs skills at scale
- 2026-05-26 Ship Your First Managed Agent (Isabella He, Anthropic) — Managed Agents architecture, brain/hands decoupling, BYOC
- 2026-05-26 Stop Babysitting Your Agents (Sid Boudesaria, Anthropic) — verification loops, self-improving skills, /loop, Routines, Remote Control
- 2026-05-10 Data Aggregation Is Not a Moat (Han Lee) — AI agents collapse data aggregation moats

Note: 2026-05-26 duplicates of Building the Best Agentic Analytics Harness (K4-flzsPraE) and Memory and Dreaming (IGo225tfF2I) were skipped — same video IDs as previously ingested 2026-05-22 files.

**Pages created:**
- sources/ai-agents/agents-that-remember.md
- sources/ai-agents/beyond-basics-claude-code.md
- sources/ai-agents/ship-first-managed-agent.md
- sources/ai-agents/stop-babysitting-agents.md
- sources/misc/data-aggregation-not-a-moat.md

**Pages updated:**
- concepts/agent-memory.md (added: Memory Store API section, Dreaming Implementation Details — parameters, index file, non-destructive clone, 95% cache rate, scheduling; new sources)
- concepts/agent-skills.md (added: Verification Skills section, Skills at Scale / 100K problem, Hooks vs Skills comparison; new sources)
- concepts/context-engineering.md (added: KV Cache Constraint section — eviction cost, stable/volatile placement rule)
- concepts/mcp-servers.md (added: MCP vs Skills decision rule table, Tool Search lazy loading approach)
- concepts/agent-harness.md (added: Managed Agent Harness brain/hands decoupling section — TTFT reduction, event log durability, harness maintenance cost rationale)
- entities/people.md (added: Daisy Holman, Sid Boudesaria, Isabella He, Kevin (Anthropic); updated Han Lee with data aggregation post)
- entities/tools-products.md (added: Claude Managed Agents, Claude Agents terminal, /loop, Routines, Remote Control)
- index.md (added: 4 new AI Agents rows, 1 new Misc row; updated entity summaries; added new tags)

---

## [2026-05-26] ingest | 1 new source from misc

**Sources ingested:**
- 2026-04-12 The YC Chief Who Codes 10,000 Lines A Day Has A Simple Secret (Josipa Majic Predin, Forbes)

**Pages created:**
- sources/misc/yc-chief-codes-10000-lines.md

**Pages updated:**
- concepts/agent-harness.md (added: Fat Harness Anti-Patterns section, Resolver Pattern section, autoDream confirmation; updated sources list)
- concepts/agent-skills.md (added: Skills as Method Calls section, Diarization section; updated sources list)
- entities/people.md (updated: Garry Tan entry expanded with gstack/framework/new source; added Steve Yegge entry)
- entities/tools-products.md (updated: Claude Code entry with autoDream internals; added gstack entry)
- index.md (added: new source row in Misc table; updated entity summaries with Garry Tan/Steve Yegge/gstack; updated harness + skills tag rows)

---

## [2026-05-28] ingest | 3 new sources from ai-agents

**Sources ingested:**
- 2026-05-27 Evals for Taste: Hill-Climbing a Slide-Generation Agent (Anthropic, Code with Claude London)
- 2026-05-27 Making Agentic Workflows Trustworthy and Verifiable with a Custom DSL (James Brady, Elicit)
- 2026-05-27 Tool, Skill, or Subagent: Decomposing an Agent That Outgrew Its Prompt (Will, Anthropic Applied AI)

**Pages created:**
- sources/ai-agents/evals-for-taste.md
- sources/ai-agents/trustworthy-agentic-dsl.md
- sources/ai-agents/tool-skill-subagent-decomposition.md
- concepts/evals-and-graders.md (new concept: grader types, hill-climbing, QA loops, calibration, eval saturation)

**Pages updated:**
- concepts/agent-skills.md (added: Skills as System Prompt Relief Valve section — StockPilot 400→15-line example; added evals-and-graders to See Also; updated sources list)
- concepts/subagent-patterns.md (added: When to Use Subagents decision framework — two cases; communication breakdown failure mode; Callable Agents in CMA; updated sources list)
- concepts/mcp-servers.md (added: Tool Hierarchy section — humanlike primitives first → custom tools → MCP; code execution as MCP alternative; updated sources list)
- concepts/agent-harness.md (added: DSL-Based Verifiable Harness section — AshPL, write-interpret-redraft loop, content-address store; added evals-and-graders to See Also; updated sources list)
- entities/people.md (added: Will (Anthropic Applied AI), James Brady (Elicit))
- entities/tools-products.md (added: Elicit with AshPL DSL)
- index.md (added: evals-and-graders concept row; 3 new AI Agents source rows; updated entity summaries; added evals/reliability/decomposition/dsl tags; updated graph)

---

## [2026-05-29] ingest | 1 new source from misc

**Sources ingested:**
- 2026-05-10 Codex-maxxing (Jason Liu)

**Pages created:**
- sources/misc/codex-maxxing-jason-liu.md

**Pages updated:**
- concepts/agent-memory.md (added: Vault-Based Personal Memory section — Obsidian vault + AGENTS.md instructional layer, GitHub diff as review surface, three-layer memory model; new source)
- concepts/inner-outer-loop.md (added Heartbeats row to outer loop mechanisms table; added Heartbeats section — thread-local scheduling, dynamic cadence, cross-tool feedback loop, comparison table vs /loop and Routines; new source)
- concepts/closing-the-loop.md (added Goals as Verification Oracles section — Goals vs "implement the plan," test suite oracle, Steering for mid-execution correction; updated heartbeat reference; new source)
- entities/people.md (added: Jason Liu)
- entities/tools-products.md (added: OpenAI Codex, Heartbeats (Codex))
- index.md (added: new Misc source row; updated entity summaries; added heartbeats/operating-loop/codex tags)

---

## [2026-05-30] check | No new files found

---

## [2026-05-31] check | No new files found

---

## [2026-06-01] check | No new files found

---

## [2026-06-02] check | No new files found

---

## [2026-06-04] check | No new files found

---

## [2026-06-05] check | No new files found

---

## [2026-06-06] check | No new files found

---

## [2026-06-07] healthcheck | 16 issues (1 contradiction, 0 stale, 0 orphans, 2 missing concepts, 8 cross-ref gaps, 5 data gaps)

---

## [2026-06-08] check | No new files found

---

## [2026-06-09] check | No new files found

---

## [2026-06-10] check | No new files found

---

## [2026-06-11] check | No new files found

---

## [2026-06-12] check | No new files found

---

## [2026-06-13] check | No new files found

---

## [2026-06-14] healthcheck | 18 issues (1 contradiction, 0 stale, 2 orphans, 2 missing concepts, 7 cross-ref gaps, 6 data gaps)

---

## [2026-06-16] check | No new files found

---

## [2026-06-17] check | No new files found

---

## [2026-06-18] check | No new files found

---

## [2026-06-19] check | No new files found

---

## [2026-06-20] check | No new files found

---

## [2026-06-21] healthcheck | 17 issues (1 contradiction, 0 stale, 0 orphans, 2 missing concepts, 7 cross-ref gaps, 7 data gaps)

---

## [2026-06-22] check | No new files found

---

## [2026-06-23] check | No new files found

---

## [2026-06-24] check | No new files found

---

## [2026-06-25] check | No new files found

---

## [2026-06-26] check | No new files found

---

## [2026-06-27] check | No new files found

---

## [2026-06-28] healthcheck | 19 issues (2 contradictions, 0 stale, 0 orphans, 2 missing concepts, 7 cross-ref gaps, 8 data gaps)

---

## [2026-06-29] check | No new files found

---

## [2026-06-30] check | No new files found

---

## [2026-07-01] check | No new files found

---

## [2026-07-02] check | No new files found

---

## [2026-07-03] check | No new files found

---

## [2026-07-04] check | No new files found

---

## [2026-07-05] healthcheck | 17 issues (2 contradictions, 0 stale, 0 orphans, 2 missing concepts, 4 cross-ref gaps, 9 data gaps)

---

## [2026-07-06] check | No new files found

---

## [2026-07-07] check | No new files found

---

## [2026-07-08] check | No new files found

---

## [2026-07-09] check | No new files found

---

## [2026-07-10] check | No new files found

---

## [2026-07-11] check | No new files found

---

## [2026-07-12] healthcheck | 24 issues (4 contradictions, 0 stale, 0 orphans, 3 missing concepts, 5 cross-ref gaps, 12 data gaps)

---

## [2026-07-13] check | No new files found

---

## [2026-07-14] check | No new files found

---

## [2026-07-15] check | No new files found

---

## [2026-07-21] check | No new files found

---

## [2026-07-22] check | No new files found

---

## [2026-07-23] check | No new files found

---

## [2026-07-24] check | No new files found

---

## [2026-07-25] check | No new files found

---

## [2026-07-26] healthcheck | 25 issues (4 contradictions, 0 stale, 0 orphans, 3 missing concepts, 6 cross-ref gaps, 12 data gaps)

---

## [2026-07-27] check | No new files found

---

## [2026-07-28] check | No new files found

---

## [2026-07-29] check | No new files found

---

## [2026-07-30] check | No new files found

---

## [2026-07-31] check | No new files found

---

## [2026-08-01] check | No new files found

---

## [2026-08-02] healthcheck | 21 issues (4 contradictions, 0 stale, 0 orphans, 3 missing concepts, 2 cross-ref gaps, 12 data gaps)

---

## [2026-08-03] check | No new files found

---

## [2026-08-04] check | No new files found

---

## [2026-08-05] check | No new files found

---

## [2026-08-06] check | No new files found

---

## [2026-08-07] check | No new files found

---

## [2026-08-08] check | No new files found

---

## [2026-08-09] healthcheck | 21 issues (4 contradictions, 0 stale, 0 orphans, 3 missing concepts, 2 cross-ref gaps, 12 data gaps)

---

## [2026-08-10] check | No new files found

---

## [2026-08-11] check | No new files found

---

## [2026-08-12] check | No new files found

---

## [2026-08-13] check | No new files found
