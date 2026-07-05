---
title: AI Agents Wiki — Index
tags:
  - index
  - navigation
updated: 2026-07-05
aliases:
  - index
---

# AI Agents Wiki — Index

> [!info] How to use this wiki
> Start with [[overview]] for the central thesis and landscape map. Then dive into concept pages for depth. Source pages are one-per-article summaries. Entity pages cover key people and tools.

---

## Concept Pages

Core concepts synthesized across all sources. Each page integrates multiple sources into a coherent treatment.

| Page | Description |
|---|---|
| [[concepts/agents-evolution\|Agents 1.0 → 2.0]] | The architectural shift from shallow reactive loops to deep planning agents with four pillars |
| [[concepts/agent-harness\|Agent Harness]] | The orchestration layer between model and environment — the OS to the model's CPU |
| [[concepts/agent-skills\|Agent Skills]] | Progressive-disclosure extensions (SKILL.md) — the modular alternative to monolithic system prompts |
| [[concepts/subagent-patterns\|Subagent Patterns]] | Four canonical delegation patterns: Inline Tool, Fan-Out, Agent Pool, Teams |
| [[concepts/context-engineering\|Context Engineering]] | Finding minimal effective context; four strategies; the pre-rot threshold |
| [[concepts/inner-outer-loop\|Inner Loop vs Outer Loop]] | Inner: verify within task. Outer: carry lessons across sessions. |
| [[concepts/closing-the-loop\|Closing the Loop]] | Agent self-verification — scaffolded today, spontaneous tomorrow |
| [[concepts/agent-runtime\|Agent Runtime & Sandbox]] | Execution environments, Firecracker, training vs production runtimes, async gaps |
| [[concepts/automated-research\|Automated AI Research]] | Autoresearch loops, Karpathy's 700 experiments, Jack Clark's 60% by 2028 |
| [[concepts/agent-engineering\|Agent Engineering]] | Mindset shifts for probabilistic systems; five shifts from deterministic thinking |
| [[concepts/mcp-servers\|MCP Servers]] | Model Context Protocol — two patterns, context bloat risks, dissolving harness trend |
| [[concepts/agent-memory\|Agent Memory Architecture]] | File-system memory, Dreaming (automated outer loop), multi-agent scopes, production results |
| [[concepts/evals-and-graders\|Evals & Graders]] | Three grader types, hill-climbing workflow, QA loops, calibration, eval saturation |

---

## Overview & Schema

| Page | Description |
|---|---|
| [[overview]] | High-level synthesis: central thesis, ASCII stack, 10 trends, open questions |
| [[CLAUDE.md]] | Schema and conventions — directory structure, page format, workflows |
| [[log]] | Append-only ingest/query/lint log |

---

## Health Reports

Weekly deep audits: contradictions, stale claims, orphans, missing concepts, cross-reference gaps, and data gaps.

| Report | Date |
|---|---|
| [[health-reports/LATEST\|Latest Health Report]] | Always current |
| [[health-reports/2026-07-05\|Health Report 2026-07-05]] | 2026-07-05 |
| [[health-reports/2026-06-28\|Health Report 2026-06-28]] | 2026-06-28 |
| [[health-reports/2026-06-21\|Health Report 2026-06-21]] | 2026-06-21 |
| [[health-reports/2026-06-14\|Health Report 2026-06-14]] | 2026-06-14 |
| [[health-reports/2026-06-07\|Health Report 2026-06-07]] | 2026-06-07 |

---

## Source Pages — Philipp Schmid

| Page | Date | Topic |
|---|---|---|
| [[sources/philschmid/agents-2.0-deep-agents\|Agents 2.0: Deep Agents]] | 2025-10-12 | Shallow → Deep agents, four pillars |
| [[sources/philschmid/why-engineers-struggle\|Why Engineers Struggle]] | 2025-11-26 | Mindset shifts, Traffic Controller vs Dispatcher |
| [[sources/philschmid/context-engineering-part-2\|Context Engineering Part 2]] | 2025-12-04 | Four strategies, hierarchical tool surface, prompt shape |
| [[sources/philschmid/agent-harness-2026\|Agent Harness 2026]] | 2026-01-05 | Harness components, Bitter Lesson, first-party advantage |
| [[sources/philschmid/closing-the-loop\|Closing the Loop]] | 2026-02-17 | Scaffolded vs spontaneous verification, Spotify approach |
| [[sources/philschmid/inner-loop-vs-outer-loop\|Inner vs Outer Loop]] | 2026-02-20 | Weak vs strong inner loop, outer loop mechanisms |
| [[sources/philschmid/writing-good-agents\|Writing Good AGENTS.md]] | 2026-02-24 | ETH Zurich data, what to include/exclude, 160× tool usage |
| [[sources/philschmid/testing-skills\|Testing Skills]] | 2026-03-04 | Trigger tests, over-triggering, skill retirement |
| [[sources/philschmid/autoresearch\|AutoResearch]] | 2026-03-10 | Autoresearch loop, git as memory, eval bottleneck |
| [[sources/philschmid/agent-skills-tips\|Agent Skills Tips]] | 2026-04-13 | Description as trigger condition, skill hierarchy, retirement pattern |
| [[sources/philschmid/use-mcp-servers\|Use MCP Servers]] | 2026-04-27 | @mention injection, subagent MCP, allowed_tools |
| [[sources/philschmid/subagent-patterns-2026\|Subagent Patterns 2026]] | 2026-05-05 | Four patterns, escalation rule, result isolation protocol |

---

## Source Pages — Karpathy

| Page | Date | Topic |
|---|---|---|
| [[sources/karpathy/code-agents-autoresearch\|Code Agents & AutoResearch]] | 2026-03-20 | 700 experiments, nanochat 11% speedup, distributed autoresearch |
| [[sources/karpathy/vibe-to-agentic-engineering\|Vibe Coding → Agentic Engineering]] | 2026-04-29 | Agentic engineering definition, jaggedness, 10× claim |

---

## Source Pages — Misc

| Page | Author | Topic |
|---|---|---|
| [[sources/misc/hidden-debt-harness\|Hidden Debt: Agent Harness]] | Unknown | Harness technical debt, thin harness principle |
| [[sources/misc/hidden-debt-runtime\|Hidden Debt: Agent Runtime]] | Unknown | Sandboxing rationale, Firecracker, async gaps, runtime shift |
| [[sources/misc/components-of-a-coding-agent\|Components of a Coding Agent]] | Han Lee | Component decomposition, first-party advantage, Letta Code |
| [[sources/misc/agent-skills-perplexity\|Agent Skills at Perplexity]] | Perplexity | Skill lifecycle, trigger rate monitoring, production case study |
| [[sources/misc/how-to-work-with-ai\|How to Work with AI]] | Eugene Yan | Context as infrastructure, taste as config, parallel sessions |
| [[sources/misc/yc-chief-codes-10000-lines\|YC Chief Codes 10,000 Lines: Thin Harness Explained]] | Josipa Majic Predin | Garry Tan's thin harness framework, gstack, Claude Code leak, resolver pattern |
| [[sources/misc/data-aggregation-not-a-moat\|Data Aggregation Is Not a Moat]] | Han Lee | AI agents collapse data aggregation moats; value shifts to trust, provenance, AI/ML models |
| [[sources/misc/codex-maxxing-jason-liu\|Codex-maxxing]] | Jason Liu | Operating loop frame, Heartbeats as thread-local cron, vault memory, Goals with oracles, Steering |

---

## Source Pages — AI Agents

| Page | Date | Channel | Topic |
|---|---|---|---|
| [[sources/ai-agents/boris-cherny-claude-code\|Boris Cherny: Claude Code Growth & Next Frontier]] | 2026-05-23 | Alex Kantrowitz | Tokenmaxxing, Auto Mode, parallel agents, 250% code output |
| [[sources/ai-agents/omni-analytics-harness\|Omni: Agentic Analytics Harness (Blobby)]] | 2026-05-22 | Claude | Error recovery, consolidate-the-brain, SQL vs proprietary |
| [[sources/ai-agents/memory-and-dreaming\|Memory and Dreaming for Self-Learning Agents]] | 2026-05-22 | Claude | File-system memory, Dreaming, Managed Agents, 97% / 6× results |
| [[sources/ai-agents/agents-that-remember\|Agents that Remember]] | 2026-05-26 | Claude | Memory store API, dreaming multi-agent harness, index file, non-destructive process |
| [[sources/ai-agents/beyond-basics-claude-code\|Beyond the Basics with Claude Code]] | 2026-05-26 | Claude | KV cache constraint, hooks as zero-overhead, MCP vs skills at scale, 100K skill problem |
| [[sources/ai-agents/ship-first-managed-agent\|Ship Your First Managed Agent]] | 2026-05-26 | Claude | Brain/hands decoupling, TTFT reduction, event log durability, BYOC |
| [[sources/ai-agents/stop-babysitting-agents\|Stop Babysitting Your Agents]] | 2026-05-26 | Claude | Verification loops, self-improving skills, /loop, Routines, Remote Control |
| [[sources/ai-agents/evals-for-taste\|Evals for Taste: Hill-Climbing a Slide-Generation Agent]] | 2026-05-27 | Claude | Grader types, hill-climbing, QA loop, calibration, model selection via evals |
| [[sources/ai-agents/trustworthy-agentic-dsl\|Trustworthy Agentic Workflows with a Custom DSL]] | 2026-05-27 | Claude | AshPL DSL, mechanism matters, legible process, content-address memoization |
| [[sources/ai-agents/tool-skill-subagent-decomposition\|Tool, Skill, or Subagent: Agent Decomposition]] | 2026-05-27 | Claude | Decomposition framework, humanlike primitives, 400→15-line system prompt, hill-climbing |

---

## Source Pages — AI Startups

| Page | Date | Channel | Topic |
|---|---|---|---|
| [[sources/ai-startups/box-ceo-ai-company\|Box CEO Aaron Levy: Best Time to Build AI Company]] | 2026-05-19 | Silicon Valley Girl | 3-year window, accountability gap, internet of agents |
| [[sources/ai-startups/gary-vee-ai-opportunity\|Gary Vee: AI Opportunity Most People Are Missing]] | 2026-05-19 | Silicon Valley Girl | Architects vs masons, hyper micro wealth, analog value |

---

## Source Pages — Machine Learning

| Page | Date | Channel | Topic |
|---|---|---|---|
| [[sources/machine-learning/jensen-huang-compute\|Jensen Huang: Compute Behind Intelligence]] | 2026-05-15 | Stanford Online | Co-design 1M×, Vera Rubin, always-on compute, energy |
| [[sources/machine-learning/personal-ai-gary-tan\|Gary Tan: Personal AI Is the New Personal Computer]] | 2026-05-15 | Y Combinator | Boil the ocean, $200 blog rebuild, OpenClaw Ferrari |

---

## Source Pages — Prompt Engineering

| Page | Date | Channel | Topic |
|---|---|---|---|
| [[sources/prompt-engineering/prompting-playbook\|The Prompting Playbook (Anthropic)]] | 2026-05-22 | Claude | Eval-driven prompts, XML hygiene, output contracts, harness vs prompt failures |

---

## Source Pages — Import AI

| Page | Date | Topic |
|---|---|---|
| [[sources/import-ai-455\|Import AI 455 — Automating AI Research]] | 2026-05-04 | Jack Clark's 60% forecast, benchmark trajectories, Lego vs relativity |

---

## Entity Pages

| Page | Description |
|---|---|
| [[entities/people\|People]] | Philipp Schmid, Karpathy, Jack Clark, Eugene Yan, Han Lee, Tobi Lütke, Boris Cherny, Jensen Huang, Garry Tan, Aaron Levy, Margot Vanlar, Ravi, Gary Vee, Steve Yegge, Daisy Holman, Sid Boudesaria, Isabella He, Kevin (Anthropic), Will (Anthropic Applied AI), James Brady (Elicit), Jason Liu |
| [[entities/tools-products\|Tools & Products]] | Claude Code, Manus, Letta, E2B, Firecracker, MCP, OpenClaw, Perplexity Computer, Devin, LangChain, Memory+Dreaming, Vera Rubin, Blobby, agency.org, gstack, Claude Managed Agents, Claude Agents (terminal), /loop, Routines, Remote Control, Elicit (AshPL), OpenAI Codex, Heartbeats (Codex) |

---

## Graph of Key Relationships

```
agent-harness ←──────────────── agent-skills (modular extension)
     │                                │
     ├── context-engineering          │
     ├── subagent-patterns ───────────┤
     ├── agent-runtime                │
     └── inner-outer-loop ───── closing-the-loop
          │         │
          │         └── agent-memory ← (Dreaming = automated outer loop)
          │
          └── automated-research ← agent-engineering
                                          │
                                   agents-evolution

evals-and-graders ←──── agent-skills (skill evals)
     │
     ├── agent-engineering (measurement mindset)
     └── closing-the-loop (QA loops as in-task evals)
```

---

## Tag Index

| Tag | Pages |
|---|---|
| `core-concept` | agents-evolution, agent-harness, agent-skills, context-engineering, agent-engineering, automated-research, agent-memory |
| `harness` | agent-harness, hidden-debt-harness, agent-harness-2026, omni-analytics-harness, yc-chief-codes-10000-lines |
| `skills` | agent-skills, testing-skills, agent-skills-tips, agent-skills-perplexity, yc-chief-codes-10000-lines |
| `context-engineering` | context-engineering, context-engineering-part-2, subagent-patterns, prompting-playbook |
| `runtime` | agent-runtime, hidden-debt-runtime, jensen-huang-compute |
| `autoresearch` | automated-research, autoresearch, code-agents-autoresearch, import-ai-455 |
| `mcp` | mcp-servers, use-mcp-servers |
| `reliability` | closing-the-loop, inner-outer-loop, memory-and-dreaming |
| `memory` | agent-memory, memory-and-dreaming, inner-outer-loop |
| `agent-engineering` | agent-engineering, why-engineers-struggle, vibe-to-agentic-engineering, boris-cherny-claude-code |
| `prompt-engineering` | prompting-playbook |
| `compute` | jensen-huang-compute |
| `industry-perspective` | box-ceo-ai-company, gary-vee-ai-opportunity, personal-ai-gary-tan |
| `philschmid` | All 12 sources/philschmid/ pages |
| `karpathy` | sources/karpathy/ pages |
| `anthropic` | boris-cherny-claude-code, memory-and-dreaming, prompting-playbook, agents-that-remember, beyond-basics-claude-code, ship-first-managed-agent, stop-babysitting-agents, evals-for-taste, tool-skill-subagent-decomposition |
| `managed-agents` | memory-and-dreaming, agents-that-remember, ship-first-managed-agent, tool-skill-subagent-decomposition |
| `verification` | stop-babysitting-agents, closing-the-loop |
| `background-loops` | stop-babysitting-agents |
| `competitive-landscape` | data-aggregation-not-a-moat |
| `evals` | evals-and-graders, evals-for-taste, tool-skill-subagent-decomposition, testing-skills |
| `reliability` | trustworthy-agentic-dsl, closing-the-loop, inner-outer-loop, memory-and-dreaming |
| `decomposition` | tool-skill-subagent-decomposition |
| `dsl` | trustworthy-agentic-dsl |
| `heartbeats` | codex-maxxing-jason-liu, inner-outer-loop |
| `operating-loop` | codex-maxxing-jason-liu |
| `codex` | codex-maxxing-jason-liu |
