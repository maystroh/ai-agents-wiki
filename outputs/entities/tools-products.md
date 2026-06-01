---
title: Tools & Products — Key Systems in AI Agent Engineering
tags:
  - entities
  - tools
  - products
updated: 2026-05-29
---

# Tools & Products — Key Systems in AI Agent Engineering

## Claude Code

**Type:** Coding agent / agentic IDE integration  
**By:** Anthropic  
**What it is:** Anthropic's first-party coding agent. Claude is post-trained against Claude Code's interaction patterns, making those patterns native model behavior rather than context-learned. Available as CLI, desktop app (Mac/Windows), web (claude.ai/code), and IDE extensions (VS Code, JetBrains).

**Key capabilities:** Persistent filesystem access, shell tool, file editor, MCP server integration, Skills (SKILL.md), CLAUDE.md behavioral contract  
**Confirmed internals (from March 2026 source leak):** Self-healing query loop, background memory daemon (autoDream), concurrency-safe tool batching, compile-time feature gating, context management system  
**When to use:** Coding tasks where you want the strongest first-party integration with Claude  
**Limitation:** Letta Code beats it on memory-intensive tasks (specialized post-training)

**See:** [[agent-harness]], [[agent-skills]]

---

## Manus

**Type:** General-purpose deep agent framework  
**By:** Monica AI  
**What it is:** One of the first publicly demonstrated Agent 2.0 systems. Combines explicit planning, sub-agent delegation, persistent memory (filesystem), and extreme context engineering. Cited as a reference implementation of the four-pillar architecture.

**Key capabilities:** Multi-step task planning, orchestrator/sub-agent topology, read/write filesystem access  
**See:** [[agents-evolution]]

---

## Letta (formerly MemGPT)

**Type:** Memory-optimized agent framework  
**By:** Letta team  
**What it is:** Framework specializing in persistent, external memory for agents. Letta Code is a coding-specific variant post-trained for memory-intensive tasks — outperforms Claude Code on tasks requiring recall across long sessions.

**Key claim:** Memory is a dimension where third-party specialization can beat first-party harnesses  
**See:** [[agent-harness]], [[inner-outer-loop]]

---

## E2B (Code Sandbox)

**Type:** Agent sandbox / execution environment  
**By:** E2B  
**What it is:** Cloud sandbox for running agent-generated code. Built on Firecracker microVMs (~150ms cold start). Open-source SDK. The most commonly cited sandbox provider in agent development.

**Isolation:** Firecracker (VM-level)  
**Cold start:** ~150ms  
**See:** [[agent-runtime]]

---

## Firecracker

**Type:** MicroVM hypervisor  
**By:** Amazon Web Services  
**What it is:** KVM-based microVM with ~125ms boot time and ~5MB VMM overhead. The de facto isolation primitive for agent sandboxes. "VM-level isolation" in vendor marketing almost always means Firecracker.

**Used by:** E2B, Vercel Sandbox, Fly.io, AWS Lambda  
**See:** [[agent-runtime]]

---

## MCP (Model Context Protocol)

**Type:** Protocol / standard  
**By:** Anthropic  
**What it is:** Shared interface for exposing tools to LLM agents, introduced late 2024. MCP servers expose callable tools via a standardized protocol that agents can discover and call at runtime.

**Two patterns:** @mention injection (opt-in per request) vs subagent-scoped with `allowed_tools`  
**Key risk:** No built-in progressive disclosure — all server tools load into context unless scoped  
**See:** [[mcp-servers]]

---

## OpenClaw

**Type:** Autonomous agent harness  
**What it is:** An agent harness that adds heartbeat-style proactive behavior — agents check and act on tasks without being prompted, and carry learnings across sessions via persistent memory. Representative of the "outer harness" / persistent agent paradigm.

**See:** [[inner-outer-loop]], [[closing-the-loop]]

---

## Perplexity Computer

**Type:** Agentic computer-use system  
**By:** Perplexity AI  
**What it is:** Perplexity's computer-use agent with scoped skills for web browsing, code execution, and information retrieval. Documented their skill design, lifecycle, and monitoring approach as a production case study.

**See:** [[agent-skills]], [[sources/misc/agent-skills-perplexity]]

---

## Devin

**Type:** Autonomous software engineering agent  
**By:** Cognition  
**What it is:** One of the first commercially deployed autonomous coding agents. Notable for Cognition's investment in hypervisor-level snapshotting to handle async gaps (agent waiting on CI results). The async gaps problem and its solution are widely cited.

**Key technical contribution:** Hibernate-and-resume via hypervisor snapshots — solves the idle-compute problem for long-horizon tasks  
**See:** [[agent-runtime]]

---

## LangChain / LangGraph

**Type:** Agent orchestration framework  
**By:** LangChain Inc.  
**What it is:** Popular third-party framework for building agent workflows. Popularized the "Deep Agents" terminology. LangGraph is their graph-based orchestration layer for complex multi-agent workflows.

**Trade-off:** Generic framework; no first-party post-training advantage; high flexibility  
**See:** [[agent-harness]], [[agents-evolution]]

---

## nanochat / nanoGPT

**Type:** Minimal GPT-2 training codebase  
**By:** Andrej Karpathy  
**What it is:** Karpathy's minimal GPT-2 implementation used as the target for his 700-experiment autoresearch study. The codebase was already well-tuned; the autoresearch loop still found an 11% speedup.

**See:** [[automated-research]], [[sources/karpathy/code-agents-autoresearch]]

---

## QMD (Query Model for Distillation)

**Type:** Query-expansion model  
**By:** Tobi Lütke / Shopify  
**What it is:** Shopify's query-expansion model used as the target for Lütke's overnight autoresearch experiment. Result: 0.8B model outperformed 1.6B baseline after 37 experiments in 8 hours.

**See:** [[automated-research]]

---

## Memory + Dreaming (Anthropic Managed Agents)

**Type:** Agent memory infrastructure  
**By:** Anthropic  
**What it is:** Two-component memory system for Anthropic's Managed Agents platform. Memory is file-system based — Claude navigates it using native file manipulation. Dreaming is an out-of-band background process that reads cross-session transcripts and globally optimizes memory between sessions.

**Memory scopes:** Read-only org-wide (shared) + read-write agent-local (private)  
**Concurrency:** Optimistic concurrency control with version history and attribution  
**Production results:** Racketin 97% fewer first-pass errors; Harvey 6× completion rate  
**Key insight:** The outer loop can be fully automated via Dreaming  
**See:** [[inner-outer-loop]], [[sources/ai-agents/memory-and-dreaming]]

---

## Vera Rubin

**Type:** GPU architecture  
**By:** NVIDIA  
**What it is:** NVIDIA's 2026 GPU architecture designed specifically for agent workloads. Key innovation: a dedicated low-latency CPU co-located with the GPU to handle agent tool calls (file reads, API calls, bash commands), whose latency profile differs fundamentally from matrix multiplication. Also includes direct storage-to-GPU fabric to reduce memory bandwidth bottleneck for long-context operations.

**Why it matters for agents:** Standard GPU architectures optimize for matrix ops; agent workloads mix GPU-heavy inference with CPU-heavy tool execution. Vera Rubin co-designs both in the same chip.  
**See:** [[agent-runtime]], [[sources/machine-learning/jensen-huang-compute]]

---

## Blobby (Omni Analytics Agent)

**Type:** Agentic analytics assistant  
**By:** Omni (25-person company)  
**What it is:** Production analytics agent built over 18 months by Omni's engineering team. Primary contributions: documented the error-recovery pattern as the highest-leverage improvement, the "consolidate the brain" principle against naive orchestrator/sub-agent splits, and the value of using SQL (vs proprietary query languages) to leverage model training data.

**Key lessons:**
1. Error recovery is the highest-leverage architectural improvement
2. Don't split orchestrator/sub-agent when outer agent can't predict inner agent's constraints
3. Prefer languages with rich model training data (SQL) over proprietary formats  
**See:** [[agent-harness]], [[subagent-patterns]], [[sources/ai-agents/omni-analytics-harness]]

---

## agency.org / Outshift (Cisco)

**Type:** Agent-to-agent discovery and transaction infrastructure  
**By:** Outshift (Cisco's venture unit) / agency.org consortium  
**What it is:** Infrastructure project for building an "internet of agents" — protocols that allow agents to discover other agents, negotiate capabilities, and transact tasks at internet scale. Analogous to how REST APIs enabled service-to-service communication.

**See:** [[subagent-patterns]], [[sources/ai-startups/box-ceo-ai-company]]

---

## gstack

**Type:** Claude Code configuration / open-source harness template  
**By:** Garry Tan (Y Combinator President)  
**What it is:** MIT-licensed Claude Code configuration instantiating the thin harness, fat skills architecture. Accumulated 66,000 GitHub stars within weeks of release; forked 9,100+ times. Installs in ~30 seconds.

**Key design choices:**
- Skill files as method calls (markdown = programming language, human judgment = runtime)
- CLAUDE.md as 200-line pointer file with runtime resolvers (not 20,000-line inline document)
- Explicit thin harness discipline: no god-tools, no bloated MCP surface
- Diarization skills for deep profile analysis (used for YC Startup School matching)

**Why it matters:** First widely-adopted public instantiation of the thin harness principle; validated that the architecture is replicable outside Anthropic's internal tooling.  
**See:** [[agent-harness]], [[agent-skills]], [[sources/misc/yc-chief-codes-10000-lines]]

---

## Claude Managed Agents

**Type:** Hosted agent infrastructure platform  
**By:** Anthropic  
**What it is:** Anthropic's production agent harness — the layer above the Agent SDK that handles hosting, scaling, compaction, caching, sandboxing, and observability. Developers define agents (persona + tools), environments (compute sandbox), and sessions (event log binding the two). The agent loop runs server-side; tool execution runs in a decoupled environment.

**Key architecture:** Brain/hands decoupling — agent loop separate from tool execution. Benefits: credential isolation (vaults), >90% P95 TTFT reduction via environment pre-warming, event log durability (sessions survive crashes).

**Primitives:**
- **Agent:** system prompt + model + tool definitions (the brain)
- **Environment:** compute sandbox + network allowlist + MCP tunnels (the hands)
- **Session:** event log binding agent + environment; streams events (not tokens)
- **Memory stores + Dreaming:** persistent file-system memory + async consolidation harness
- **Outcomes:** rubric-based goal specification replacing step-by-step instructions
- **Vaults:** encrypted credential storage, per-user/per-session scoping
- **Bring your own compute (BYOC):** released May 2026 — tool execution in developer's own infrastructure

**Production impact:** 10–15× faster to production vs rolling your own harness  
**See:** [[agent-harness]], [[agent-memory]], [[sources/ai-agents/ship-first-managed-agent]], [[sources/ai-agents/agents-that-remember]]

---

## Claude Agents (Terminal View)

**Type:** Multi-agent management interface (terminal)  
**By:** Anthropic  
**What it is:** Run `claude agents` (not `claude`) to get a session management view in the terminal — lists all active sessions across surfaces, sorted by attention requirement (sessions needing input appear at top). Supports pinning, renaming, reordering, and jumping into any session.

**Replaces:** TMux + work trees + manual session tracking for multi-agent parallelism  
**See:** [[sources/ai-agents/stop-babysitting-agents]]

---

## /loop Command (crontool)

**Type:** Background recurring task primitive (Claude Code)  
**By:** Anthropic  
**What it is:** Runs a prompt at a specified interval without human involvement. Internal name: `crontool`; `/loop` is the user-facing alias. Claude wakes up on schedule, runs the prompt, and continues until it determines the task is complete or no longer relevant. Essential for: babysitting PRs, updating docs, triaging feedback, keeping CI green.

**Complements:** Routines (remote version via Claude Code Web)  
**See:** [[concepts/inner-outer-loop]], [[sources/ai-agents/stop-babysitting-agents]], [[sources/ai-agents/beyond-basics-claude-code]]

---

## Routines (Claude Code Web)

**Type:** Remote background loop infrastructure  
**By:** Anthropic  
**What it is:** /loop but running remotely in Claude Code Web containers. Supports time-based triggers (nightly, every 6 hours) and event-based triggers. Used by the Claude Code team for: daily doc updates, issue/feedback summaries posted to Slack every 6 hours.

**See:** [[sources/ai-agents/stop-babysitting-agents]]

---

## Remote Control (Claude Code)

**Type:** Mobile agent oversight interface  
**By:** Anthropic  
**What it is:** Run `/remote-control` in any Claude Code session → the session appears on your phone app. Sends notifications when Claude needs input. Enables 30-second check-ins from anywhere (meetings, commute) without opening a laptop. Essential companion to /loop and Routines for truly hands-off agentic work.

**See:** [[sources/ai-agents/stop-babysitting-agents]], [[sources/ai-agents/beyond-basics-claude-code]]

---

## Elicit (with AshPL)

**Type:** Scientific research AI platform  
**By:** Elicit  
**What it is:** AI-powered research tool for scientific literature analysis, systematic reviews, and high-stakes empirical decision-making. Distinguished by a focus on rigor, data provenance, and trustworthy processes over speed.

**AshPL (æshPL):** Elicit's custom domain-specific language for encoding agentic research workflows. A Turing-incomplete, purely functional, typed, reactive subset of Python with domain-specific primitives (paper retrieval, clinical trial lookup, web search, enrichment, curation/filtering).

**Core execution model:**
- Curator (LLM) writes AshPL programs in a sandbox
- Python service validates syntax, type-checks, interprets the AST
- Content-address store memoizes computed expressions — whole program re-executed each loop but previously computed steps are cached
- Write → interpret → redraft cycle enables iterative research without drift

**Why DSL:** Forces legible, inspectable plans; ensures the system actually follows the stated process; makes iteration additive rather than disruptive.

**See:** [[agent-harness]], [[sources/ai-agents/trustworthy-agentic-dsl]]

---

## OpenAI Codex

**Type:** Long-running agent platform  
**By:** OpenAI  
**What it is:** OpenAI's agentic work platform (distinct from the Codex API/model). Designed for knowledge work and coding tasks with first-class support for long-running, persistent agent sessions. Key differentiators vs point-in-time chat tools: durable threads with compaction, Heartbeats, Goals, Steering, Side Panel, Connectors, and computer/browser use.

**Key capabilities:**
- **Durable threads with compaction** — pinned megathreads per workstream; compaction keeps them running without carrying every old message in full
- **Heartbeats** — thread-local recurring automations (see below)
- **Goals** — long-running tasks with external success criteria; the agent keeps pushing until the oracle is satisfied
- **Steering** — inject intent into the message queue while the agent is still running a prior step
- **Side panel** — inspect, annotate, and operate artifacts (Markdown, spreadsheets, HTML, Slidev, Remotion) in the same surface the agent acts on
- **Connectors** — `$slack`, `$gmail`, `$calendar` for working with real work surfaces
- **Computer / browser use** — `$browser` (local), `@chrome` (signed-in browser), `@computer` (desktop GUI)

**See:** [[sources/misc/codex-maxxing-jason-liu]], [[inner-outer-loop]], [[closing-the-loop]]

---

## Heartbeats (Codex)

**Type:** Thread-local recurring automation primitive  
**By:** OpenAI (Codex feature)  
**What it is:** A scheduling mechanism native to Codex threads. Unlike external cron jobs, Heartbeats live inside the thread — the thread schedules itself. Key properties: dynamic cadence (the thread can change its own interval based on state), multiple parallel schedules per thread, and cross-tool execution within a single feedback loop.

**Design contrast with /loop (Claude Code):** /loop is user-initiated and session-scoped; Heartbeats are thread-self-set and can run until a condition is met, not just on a fixed schedule.

**Canonical example — Chief of Staff thread:**
```
Every 30 minutes: check Slack + Gmail for unanswered messages,
research deeply, draft replies (don't send). Adjust to every 1 minute
once a specific contact joins the thread.
```

**See:** [[inner-outer-loop]] (Heartbeats in the outer loop mechanisms table), [[sources/misc/codex-maxxing-jason-liu]]

---

## See Also
- [[entities/people]] — the researchers and engineers behind these tools
