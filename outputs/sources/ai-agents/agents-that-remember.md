---
title: "Agents that Remember"
author: "Kevin (Anthropic Engineer)"
date: 2026-05-26
url: https://www.youtube.com/watch?v=geUv4CjPpxI
tags:
  - memory
  - dreaming
  - managed-agents
  - anthropic
  - ai-agents
  - memory-stores
sources:
  - "AI Agents/Claude/2026-05-26"
updated: 2026-05-27
---

# Agents that Remember

## Summary

- Workshop from Code With Claude (May 2026) demonstrating Claude Managed Agents memory stores and the Dreaming feature via hands-on CLI and Console walkthrough
- A **memory store** is a persistent file-system-like store attached to sessions; Claude navigates it using bash and grep natively — no new abstraction layer
- **Dreaming** is a batch multi-agent harness: an orchestrator spawns one sub-agent per input session transcript, fact-checks and consolidates memory, and writes to a cloned output store — non-destructive by design
- Dreaming creates an **index file** in the output store so future agents can orient quickly (check index → targeted reads) rather than doing broad searches
- Dream jobs support model selection (opus-4-7 or sonnet-4-6), optional custom instructions to steer focus, and expose ~95% cache hit rates; batching options forthcoming

## Key Insights

- **Memory is file-system, not vector DB.** Memory stores mount as a filesystem in the session container. Claude uses bash, grep, and file reads — the same skills it already has — to navigate memory. No embedding pipeline, no retrieval layer.
- **Scoping memory per use case.** Memory stores can be scoped per organization, per user, or per workspace. Access control defaults to read/write; setting `access: read_only` lets sessions read but not modify the store.
- **The prompt parameter steers what gets remembered.** When mounting a memory store on a session, you can pass a `prompt` field that steers the agent toward what to record — useful for investment agents, task-specific memory, or domain-specific retention.
- **Non-destructive dreaming.** The dream process clones the input memory store into an output store before writing. Your original data is never touched. This makes the output reviewable before you retire the input store.
- **Dreaming creates an index.** After consolidation, the output store contains an index file with slugs pointing to individual memory files. Future agents read the index first (cheap), then jump to the specific file they need — more efficient than a wide grep.
- **One sub-agent per transcript.** The dreaming harness spawns one sub-agent per session transcript you pass. Exhaustive by design: if you pass 100 transcripts, 100 sub-agents run in parallel, ensuring no transcript is skimmed.
- **Token economics of dreaming.** Dreaming is token-intensive (exhaustive by design), but ~95% of tokens are cached since the harness is highly repetitive in structure. Batch pricing (50% discount via off-hours scheduling) is planned.
- **Human-in-the-loop review.** The console shows a diff of what dreaming changed. Operators can inspect, edit, or reject dream outputs before swapping the output store into production sessions.

## Concepts Touched

- [[concepts/agent-memory]] — technical implementation of memory stores and dreaming pipeline
- [[concepts/inner-outer-loop]] — dreaming is the automated outer loop; one sub-agent per transcript
- [[concepts/subagent-patterns]] — dreaming harness is an orchestrator + fan-out pattern at memory distillation time
- [[concepts/context-engineering]] — index file as efficient memory navigation; prompt parameter as steering
- [[entities/tools-products]] — Claude Managed Agents memory store and dreaming as product primitives

## Notable Quotes

> "A memory store is a persistent file-system-like store that attaches to sessions and gives agents the ability to read and write information across sessions."

> "Dreaming is an asynchronous job that runs in the background — it looks over your previous sessions represented as transcripts, does fact-checking, organizes and consolidates duplicate information so your memory stores don't grow unbounded."

> "While we don't actually touch the input memory store at all — this is a non-destructive process. What we do is clone your input memory store into what's called an output memory store."

> "By design we actually want it to be exhaustive. We spawn one sub-agent per input session. So we're expecting about a 95% cache hit rate on most dream sessions."

> "If Claude is creating subdirectories to organize memory files, you can edit these memory files directly if you wanted to. If Claude wrote something that was incorrect or maybe you just wanted to add more information, you can do that."
