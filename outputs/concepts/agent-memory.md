---
title: Agent Memory Architecture
tags:
  - memory
  - dreaming
  - outer-loop
  - managed-agents
  - context-engineering
  - core-concept
aliases:
  - memory-and-dreaming
  - agent-memory
sources:
  - sources/ai-agents/memory-and-dreaming.md
  - sources/ai-agents/agents-that-remember.md
  - sources/misc/how-to-work-with-ai.md
  - sources/philschmid/inner-loop-vs-outer-loop.md
  - sources/misc/codex-maxxing-jason-liu.md
updated: 2026-05-29
---

# Agent Memory Architecture

## Definition

Agent memory is the mechanism by which an agent retains and retrieves information across sessions. Unlike context (which resets per conversation), memory is persistent external state that an agent can read, write, and update over time.

> [!info] Memory vs Context
> Context is ephemeral: it exists for one session and then disappears. Memory is durable: it persists across sessions, agents, and time. The distinction matters because context engineering (how you fill the window) and memory architecture (how you build external state) require different design decisions.

## Two Memory Architectures

### File-System Memory (Anthropic Managed Agents)

Anthropic's approach: give the agent a writable filesystem and let Claude navigate it using its native file-manipulation capabilities. No vector database, no retrieval layer, no embeddings.

**Why this works:** Claude has extensive training on filesystem operations. It can read, write, update, and navigate directory structures without new abstractions. Memory becomes a first-class part of the task environment, not a separate subsystem.

**Memory scopes in multi-agent settings:**
- **Read-only org-wide:** Shared knowledge accessible to all agents in an organization
- **Read-write agent-local:** Private working memory for a specific agent instance
- **Concurrency:** Optimistic concurrency control with version history and attribution

### Annotated Index (Eugene Yan pattern)

Per-project memory via a handwritten `INDEX.md`: a structured summary of what the project contains, where things are, and what decisions have been made. The agent reads this on session start to restore context.

**See:** [[inner-outer-loop]] for how this fits the outer loop pattern.

### Vault-Based Personal Memory (Jason Liu pattern)

A personal Obsidian vault committed to a GitHub repo serves as the durable memory layer across all threads and workstreams:

```
vault/
├── AGENTS.md       ← instructions: write down what you learn
├── TODO.md
├── people/
├── projects/
├── agent/
└── notes/
```

**AGENTS.md as the instructional layer.** The vault's top-level AGENTS.md tells the model *how* to write to it: "as you learn more about people, make progress on projects, make a decision, or close an open loop, update the relevant pages in the vault." This separates the memory architecture (what exists) from the operating instructions (when and what to write).

**GitHub diff as the review surface.** Because the vault is a GitHub repo, every memory update produces a diff. The diff is the accountability mechanism — you can read what the agent thought was important enough to remember, accept or reject it, and avoid "evergreen threads quietly accumulating vibes in conversation history."

**Two-layer memory model.** The vault is the source of truth: inspectable, editable, diffable. First-party platform memory features (e.g., Codex Memories via Settings > Personalization > Memories) are a recall layer *on top* — for stable preferences, recurring workflows, project conventions, and known pitfalls when starting a new thread.

**Thread memory is finite.** Long-running threads incur higher cost when revisited (likely outside cache). The vault ensures that even if a thread compacts badly, expires, or becomes too expensive to maintain, the useful knowledge survives outside it.

**See:** [[inner-outer-loop]] for how this fits the outer loop pattern; [[sources/misc/codex-maxxing-jason-liu]] for the detailed pattern.

## Memory Store API (Managed Agents)

The implementation details of memory stores in Claude Managed Agents (from the May 2026 Code With Claude workshop):

- **Creation:** Memory stores are created via API with a `name` and optional `description`. They appear in the Anthropic Console as browseable filesystems.
- **Mount configuration:** When attaching to a session, two parameters govern behavior:
  - `prompt` — steers the agent toward what to record (e.g., "remember investment theses" for an investment agent)
  - `access` — defaults to `read_write`; set to `read_only` to prevent session writes (e.g., shared org-wide knowledge)
- **Native navigation.** The memory store mounts as a filesystem in the session container. Claude uses `bash`, `grep`, and file reads — not a retrieval API — to navigate it. Versioning is built in: every file write creates a new version.
- **Scoping strategy.** A single memory store need not be per-org — you can scope per user, per workspace, or per use case. The API doesn't enforce a topology; you define the boundaries.
- **Manual seeding.** The Console allows manual file creation in memory stores — useful for bootstrapping domain knowledge before agent sessions begin.

## Dreaming: The Automated Outer Loop

"Dreaming" is Anthropic's name for the background process that updates memory between sessions:

1. Agent completes sessions → transcripts accumulate
2. Out-of-band Dreaming process reads cross-session transcripts
3. Dreaming identifies patterns, distills lessons, prunes outdated entries
4. Memory store is globally updated with the synthesized learnings
5. Next session starts with optimized memory

> [!quote] Ravi (Anthropic API Knowledge Team)
> "Dreaming is an out-of-band process that reads your transcripts from the past week and globally optimizes your memory."

This is the infrastructure version of what [[inner-outer-loop]] describes conceptually: the outer loop carries lessons across sessions, and Dreaming automates it.

### Dreaming Implementation Details (from May 2026 workshop)

**Multi-agent architecture:** The dreaming harness is itself a multi-agent system — one orchestrator spawns one sub-agent per session transcript you pass. Exhaustive by design: with 100 transcripts, 100 sub-agents run.

**Non-destructive process:** Dreaming clones the input memory store into an output store before writing. The input store is never modified. You inspect the diff in Console, then optionally retire the input store after validating the output.

**Index file creation:** Dreaming's first action is to produce an index file with slugs referencing memory files. Future agents read the index first (cheap), then jump to the relevant file — more efficient than a broad `grep` over all memory files.

**Model choice:** You can configure the dream job to use `claude-opus-4-7` (higher quality) or `claude-sonnet-4-6` (lower cost). You can also pass custom instructions to steer the dreaming harness (e.g., "focus on capturing specific identifiers" or "enforce this directory structure").

**Token economics:** Dreaming is token-intensive but ~95% of tokens are cached (repetitive harness structure). Off-hours batch pricing (50% discount) is planned. Volume scales with number of transcripts × content depth, not just transcript count.

**Scheduling strategy.** Typical cadence: nightly or weekly, over the last N sessions (10–100). Daily dreaming over recent sessions is viable given the caching efficiency.

## Why It Matters

**Production results from Anthropic's Managed Agents:**
- Racketin (legal tech): 97% decrease in first-pass errors
- Harvey (legal AI): 6× completion rate improvement

These numbers suggest memory isn't an incremental improvement — it's a qualitative shift in agent reliability for long-horizon tasks.

## Key Patterns

### Pattern 1: File-Based Memory Navigation

```
session_start:
  read memory/INDEX.md        # orient
  read memory/project_state/  # current context
  
session_end:
  write memory/transcript.md  # raw record
  update memory/INDEX.md      # structured summary
```

### Pattern 2: Dreaming (Async Memory Optimization)

```
[out of band, nightly or weekly]
dreaming_process:
  read transcripts/[last_N_sessions]
  identify: recurring patterns, errors, resolutions
  update: memory/lessons.md, memory/INDEX.md
  prune: stale or superseded entries
  promote: high-confidence learnings to org-wide scope
```

### Pattern 3: Multi-Agent Shared Memory

When multiple agents operate on the same project:
- Org-wide read-only memory provides shared ground truth
- Agent-local read-write memory allows independent experimentation
- Version history prevents silent overwrites; attribution tracks who changed what
- Optimistic concurrency: agents write and detect conflicts after-the-fact, rather than locking upfront

## Tensions & Tradeoffs

| Tension | File System | Vector DB |
|---|---|---|
| Access pattern | Navigated by agent | Retrieved by similarity |
| Claude's comfort | Native file ops | New abstraction layer |
| Staleness handling | Agent must prune explicitly | Embedding drift can be silent |
| Cost | Storage cheap; context reads on demand | Embedding compute on write |
| Debuggability | Human-readable files | Requires specialized tooling |

> [!warning] Memory Bloat
> Without Dreaming or regular pruning, memory stores grow stale and large. Too much memory in context creates the same rot problem as too much context: the important signal is buried. Memory architecture must include a pruning/distillation mechanism.

## Relationship to the Outer Loop

Memory architecture is the implementation of the outer loop. Without persistent memory:
- Every session starts from scratch
- Lessons from failures must be manually re-taught each time
- The agent cannot compound learning across work

With memory + Dreaming:
- Session start restores relevant context automatically
- Failures generate transcript records that feed Dreaming
- Dreaming distills failures into memory updates
- Next session has fewer first-pass errors

**See:** [[inner-outer-loop]] for the conceptual framework; [[closing-the-loop]] for verification patterns.

## Related Concepts

- [[inner-outer-loop]] — Memory is the substrate the outer loop operates on
- [[context-engineering]] — Memory determines what's available; context engineering determines what to load
- [[agent-harness]] — Memory is typically a harness-managed resource, not in the model
- [[automated-research]] — Autoresearch uses git as memory; same principle, research domain
- [[agents-evolution]] — Persistent memory is Pillar 3 of Agents 2.0; the architectural motivation for why memory architecture matters
- [[subagent-patterns]] — Multi-agent memory scopes (org-wide read-only, agent-local read-write) are a key design input for multi-agent orchestration patterns

## Sources

- [[sources/ai-agents/memory-and-dreaming]] — Anthropic's Memory + Dreaming architecture (Ravi)
- [[sources/ai-agents/agents-that-remember]] — Technical implementation: memory store API, dreaming parameters, index file, non-destructive process (Kevin, Anthropic)
- [[sources/misc/how-to-work-with-ai]] — Annotated INDEX.md as per-project memory (Eugene Yan)
- [[sources/philschmid/inner-loop-vs-outer-loop]] — Outer loop mechanisms including memory
- [[sources/misc/codex-maxxing-jason-liu]] — Vault-based personal memory, AGENTS.md instructional layer, GitHub diff review, two-layer memory model (Jason Liu)
