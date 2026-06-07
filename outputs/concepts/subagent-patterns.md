---
title: Subagent Orchestration Patterns
tags:
  - subagents
  - orchestration
  - core-concept
aliases:
  - Subagent Patterns
  - Multi-agent Patterns
sources:
  - subagent-patterns-2026
  - context-engineering-part2
  - components-coding-agent
  - agents-2.0
  - tool-skill-subagent-decomposition
updated: 2026-05-28
---

# Subagent Orchestration Patterns

## Why Subagents?

Context pollution is the enemy of reliability. As an agent's context grows, reasoning quality degrades. Subagents solve this by **isolating tasks** into fresh contexts with focused instructions and their own tools.

The key insight from Manus/GoLang concurrency applied to agents: **"Share memory by communicating, not communicate by sharing memory."** Each subagent gets only the context it needs to perform its discrete task.

> [!note] Start with Pattern 1
> Most tasks that feel like they need multi-agent systems work fine with a well-prompted inline tool call. Only escalate when the simpler pattern demonstrably fails.

## The Four Patterns

Ordered by control complexity and model capability required:

---

### Pattern 1 — Inline Tool: Subagent as a Function Call

The simplest pattern. The main agent calls a tool that spawns a subagent and returns the result as a tool response. From the main agent's perspective, calling a subagent is identical to calling `read_file` or `run_command`.

```json
[
  { "role": "assistant", "tool_calls": [
    { "name": "call_agent", "arguments": {
      "task": "Review PR #42 for security issues",
      "agent": "security-reviewer"
    }}
  ]},
  { "role": "tool", "name": "call_agent",
    "content": "Found 2 issues: auth token not validated..." }
]
```

**Sync vs Async variants:**
- *Sync*: Tool call blocks; result arrives as normal tool response.
- *Async*: Tool returns immediately with agent ID; result arrives later as an injected notification message.

**When to use:** Self-contained work — research lookups, code reviews, file analysis, test generation.

**Limitations:** No way to send follow-up instructions, check progress, or cancel. If the subagent misunderstands, you find out only when the result comes back.

**Model requirement:** Works with any tool-capable model.

---

### Pattern 2 — Fan-Out: Spawn and Wait

The main agent spawns multiple subagents and collects results via a `wait_agent` tool. Spawning and collecting are separate steps, giving the model control over timing.

```json
[
  { "role": "assistant", "tool_calls": [
    { "name": "spawn_agent", "arguments": { "task": "Refactor auth module", "agent": "backend-engineer" }},
    { "name": "spawn_agent", "arguments": { "task": "Update auth tests",    "agent": "test-writer" }},
    { "name": "read_file",   "arguments": { "path": "docs/auth-spec.md" }}
  ]},
  ...
  { "role": "assistant", "tool_calls": [
    { "name": "wait_agent", "arguments": { "timeout": 300 }}
  ]},
  { "role": "tool", "name": "wait_agent",
    "content": "2 agents completed: agent-a refactored 3 files, agent-b updated 12 tests" }
]
```

**When to use:** Multiple independent parallel tasks. The main agent doesn't need intermediate results from one subagent to start another.

**Limitations:** Requires a model that reasons about *when* to wait. A model that calls `wait_agent` immediately after every spawn gets no benefit over Pattern 1.

**Model requirement:** Model must interleave its own work between spawn and wait.

---

### Pattern 3 — Agent Pool: Persistent Agents with Messaging

Long-lived subagents that persist across interactions. The main agent communicates via `send_message` / `wait_agent`. Agents retain conversation history — the main agent can send follow-up instructions to the same agent multiple turns later.

Tool surface: `spawn_agent`, `send_message`, `wait_agent`, `list_agents`, `kill_agent`

**When to use:** Multi-step workflows where specialists need to collaborate (researcher + writer; coder + reviewer). The main agent routes information between them.

**Limitations:** Main agent must track multiple agent states. Smaller models lose track of which agent has which context, or forget to `kill_agent`. Frontier models handle 2–4 agents okay.

**Model requirement:** Must track multi-agent state across turns.

---

### Pattern 4 — Teams: Agents Talk to Each Other

Agents message each other directly without going through the main agent. The main agent sets up the team, kicks off a lead, and steps back. Agents coordinate via direct messaging or shared mailboxes.

```json
[
  { "role": "assistant", "tool_calls": [
    { "name": "spawn_agent", "arguments": { "role": "planner",     "tools": ["read_file", "send_message"] }},
    { "name": "spawn_agent", "arguments": { "role": "implementer", "tools": ["write_file", "send_message"] }},
    { "name": "spawn_agent", "arguments": { "role": "reviewer",    "tools": ["read_file",  "send_message"] }}
  ]},
  { "role": "assistant", "tool_calls": [
    { "name": "send_message", "arguments": {
      "to": "agent-planner",
      "message": "Plan and coordinate feature X. Teammates: agent-implementer, agent-reviewer. Report when done."
    }}
  ]},
  ... (main agent waits; all coordination is invisible)
  { "role": "tool", "name": "wait_agent",
    "content": "agent-planner: Feature X complete. 3 files changed, all tests passing." }
]
```

**When to use:** Large tasks where coordination logic exceeds what a single agent can manage step-by-step.

**Limitations:** Every team member needs frontier-class capability. Infrastructure challenges: cycle detection (A waits on B, B waits on A), file conflict resolution, shutdown coordination. Hard to debug — failure cascades are difficult to trace.

**Model requirement:** All agents must be frontier-class.

---

## Comparison

| Pattern | Key Tool(s) | Main Agent Role | Agent Lifetime | Model Tier |
|---|---|---|---|---|
| Inline Tool | `call_agent` | Caller | Single task | Any |
| Fan-Out | `spawn`, `wait` | Dispatcher | Single task | Mid |
| Agent Pool | `spawn`, `send`, `wait`, `list`, `kill` | Coordinator | Multi-turn | High |
| Teams | All + cross-agent `send_message` | Supervisor | Persistent | Frontier (all) |

> [!tip] Escalation rule
> Start at Pattern 1. Move to 2 for genuinely parallel independent work. Move to 3 when agents need to collaborate across steps. Use 4 only when a single agent can't manage the coordination.

## Result Collection Changes Across Patterns

- **Pattern 1**: Result inline as tool response
- **Pattern 2**: Results batched via `wait_agent` (returns all completed since last call)
- **Pattern 3**: Results delivered incrementally per message
- **Pattern 4**: Only what agents explicitly report back; inter-agent conversation is invisible

## When to Use Subagents — A Decision Framework

Anthropic's Applied AI team distills two and only two strong cases for subagents (Will, 2026):

1. **Parallelism / throw a lot of Claude at a problem** — deep research, fan-out document analysis, codebase exploration, simultaneous independent workstreams. Multiple minds on the same problem, faster and more thorough than sequential single-agent.

2. **Fresh perspective** — one Claude instance shouldn't both write and review its own work. A second instance with no context from the first is better positioned to critique. The code writer / code reviewer separation is the canonical example; applies to any creator / critic split.

> [!warning] Resist the default to subagents
> Frontier models (Claude Opus 4.x, etc.) have become capable enough to manage more information in a single context than earlier models. Many subagents that existed in legacy systems can be collapsed back into the main agent, simplifying the architecture without sacrificing performance. "We just don't need as many sub-agents" as models improve.

Common misuse: subagent as a tool wrapper to isolate context that doesn't actually need isolation. This adds communication overhead, introduces orchestrator/subagent breakdown failure modes, and fragments logging without providing a genuine fresh perspective or meaningful parallelism.

### The Communication Breakdown Problem

A frequently cited failure mode: the subagent completes the task correctly, but its communication of results back to the orchestrator is imprecise, formatted wrong, or loses critical details. The eval fails even though the subagent was right.

Design implication: invest as much in the output contract (how the subagent reports results) as in the subagent's capability. Structured output formats, explicit schemas, and validation at the handoff boundary reduce communication failures.

## Callable Agents in Claude Managed Agents

Legacy pattern: expose a subagent as a **tool** — orchestrator calls a tool that spawns the subagent and returns the result. The orchestrator's context stays clean, but logging and observability are fragmented (separate transcripts, difficult to correlate).

CMA pattern: **callable agents** as a native capability. Subagents are defined and invoked natively within the CMA session; their activity is visible in the same session log as the orchestrator. This gives unified observability without requiring custom transcript collection across multiple independent agent containers.

## The Future

> [!quote] Karpathy on multi-agent work
> "It's not about a single session with your agent. Multiple agents — how do they collaborate in teams — everyone's trying to figure out what that looks like."

The mechanism works today. The communication quality is still the bottleneck: lead agents don't always know what context to pass, what instructions to write, or what the subagent is missing.

## See Also
- [[agent-harness]] — the infrastructure that implements these patterns
- [[context-engineering]] — why context isolation matters for subagents
- [[agents-evolution]] — subagents as Pillar 2 of Agents 2.0
- [[agent-memory]] — multi-agent memory scopes (org-wide read-only, agent-local read-write, optimistic concurrency)
- [[mcp-servers]] — how MCP tools are scoped per subagent
