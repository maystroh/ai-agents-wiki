---
title: "Codex-maxxing"
author: "[[Jason Liu]]"
date: 2026-05-10
url: https://jxnl.co/writing/2026/05/10/codex-maxxing/
tags:
  - memory
  - outer-loop
  - heartbeats
  - operating-loop
  - codex
  - long-running-agents
  - misc
sources:
  - Misc/Codex-maxxing - Jason Liu.md
updated: 2026-05-29
---

# Codex-maxxing

## Summary

- Jason Liu reframes Codex from a coding tool to a **long-running work platform** built around five components: durable threads, memory outside the thread, tools that can act on the computer, ways to steer, and a surface to review artifacts.
- **Heartbeats** are thread-local automations that let a thread schedule itself — the Chief of Staff thread checks Slack + Gmail every 30 minutes and pre-drafts replies; a feedback loop on animations runs every 15 minutes across three tool boundaries (Slack → Remotion → @computer).
- **Vault-based memory** grounds long threads in an Obsidian vault (committed to GitHub) — the diff of memory updates is the review surface; the vault holds rolling context that outlives any thread or compaction event.
- **Goals** are the completion-oracle mechanism: a well-formed Goal includes a real success criterion (e.g., pass the original library's test suite) that the agent can keep pushing against — not a Markdown plan to "implement."
- **Steering** lets you inject the next message after a tool call while the agent is still working, building a queue of intent before walking away — the unit of work becomes an "operating loop," not a single prompt/response.

## Key Insights

### The Operating Loop Frame

Liu's central reframe: *work should have an operating loop, not just a prompt.* An operating loop has:
1. A durable thread (compacted, not abandoned)
2. Memory outside the thread (vault, disk-backed)
3. Tools that can act on the computer
4. Ways to steer and resume
5. A surface to review the artifact

When all five are in place, "pinned threads start to feel less like chats and more like different workers reading from the same notebook."

### Heartbeats as Thread-Local Cron

Heartbeats are distinct from external cron jobs — they are *thread-local* and *self-scheduling*. A thread can:
- Schedule itself with multiple cadences
- Adjust cadence dynamically based on state (every 30 min normally → every 1 min once a support agent joins)
- Run until a condition is met, not just on a fixed schedule
- Work across tool boundaries within a single feedback loop

This makes them a first-class outer loop mechanism, not external infrastructure.

**Chief of Staff example:**
```
Every 30 minutes, check Slack and Gmail for unanswered messages.
Prioritize what matters most.
If someone asks a question, research deeply and draft a reply (but don't send).
```

**Cross-tool feedback loop example (animation):**
Heartbeat every 15 min → read Slack feedback → re-render via Remotion → post via `@computer` (because MCP couldn't upload files). Single loop crossing three tool boundaries, no human in the middle.

### Vault Memory vs Thread Memory vs Codex Memories

Three distinct memory layers:
| Layer | What | Scope | Review surface |
|---|---|---|---|
| Vault (disk-backed) | Obsidian vault, GitHub repo | Cross-thread, persistent | Git diff |
| Thread memory | In-context conversation history | Per-thread | None (implicit) |
| Codex Memories | First-party Codex recall layer | Cross-thread, managed | Settings panel |

The vault is the **source of truth**: inspectable, editable, diffable. Codex Memories are a recall layer *on top* of the vault for stable preferences and project conventions.

### Goals and the Verification Oracle

A Goal is not a task description — it is a bounded loop with a success criterion the agent can check autonomously:

> "Ambition without verification is just a wish."

**Weak goal:** "implement the plan in this Markdown file"
**Strong goal:** "migrate Rich to Rust; it must pass all unit tests from the original Python library"

The test suite is the oracle. The agent can determine when it is done without human judgment at each step.

### Steering: Queue Intent, Don't Wait

Steering is mid-execution message injection — you can keep adding intent to the queue while the agent is still processing a tool call. Combined with Heartbeats, the pattern is:
1. Start task, voice-steer while reviewing artifacts
2. Queue next steps while current step runs
3. Walk away with the queue shaped
4. Heartbeats keep work moving after you leave

### Long Thread Cost

Durable threads are not free. Revisiting a thread that has left the cache means paying full (uncached) token cost for the conversation history. For workstreams where continuity matters, Liu judges this worth it — but it's a real tradeoff versus a fresh short thread.

## Concepts Touched

- [[inner-outer-loop]] — Heartbeats as thread-local outer loop scheduling; operating loop frame
- [[agent-memory]] — Vault-based memory, three memory layers, GitHub diff as review surface
- [[closing-the-loop]] — Goals as verification-oracle completion; steering as mid-execution correction
- [[agent-harness]] — Operating loop as harness design frame; durable thread + tools + memory + steering
- [[context-engineering]] — Compaction for long-running threads; cache cost tradeoffs

## Notable Quotes

> "The work no longer has to pause just because I changed locations. A thread can keep going, and I can keep just enough attention on it to unblock the next move."

> "Memory as files. Files force the agent to compress experience into a form that can survive the thread."

> "Execution is only as good as the goal and the verification you give it. Ambition without verification is just a wish."

> "When I come back to Slack, replies are often already sitting in drafts. I still decide what gets sent, but the expensive part of gathering context is done."
