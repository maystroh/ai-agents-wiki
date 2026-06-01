---
title: "Ship Your First Managed Agent"
author: "Isabella He (Member of Technical Staff, Applied AI Team, Anthropic)"
date: 2026-05-26
url: https://www.youtube.com/watch?v=19HDQ9HppOA
tags:
  - managed-agents
  - agent-harness
  - agent-runtime
  - production
  - anthropic
  - ai-agents
  - brain-hands-decoupling
sources:
  - "AI Agents/Claude/2026-05-26"
updated: 2026-05-27
---

# Ship Your First Managed Agent

## Summary

- Workshop (Code With Claude, May 2026) walking through shipping an incident-response agent on Claude Managed Agents — from blank repo to production-capable agent
- Managed Agents evolution: Messages API → Agent SDK → **Claude Managed Agents** (hosted agent loop with sandboxing, observability, context management, compaction/caching handled by Anthropic)
- Three core primitives: **Agent** (persona/capabilities = the brain), **Environment** (compute/sandboxing = the hands), **Sessions** (bind agent + environment; work in events, not token in/out)
- Key architectural decision: **decouple agent loop (brain) from tool execution (hands)** — security isolation + >90% P95 TTFT reduction
- Managed Agents platform shipped 10–15× faster to production vs. rolling your own harness; harnesses must evolve with models (the `sonnet-4-5 context anxiety` example shows maintenance cost)

## Key Insights

- **Why Managed Agents?** Harnesses aren't one-time builds — they must evolve alongside model behavior. When Sonnet 4.5 introduced "context anxiety" (early task termination with room remaining), Anthropic added harness mitigations. When Opus 4.5 fixed the behavior, that harness work became obsolete. Managed Agents absorbs this maintenance work.
- **Three primitives, not one.** Agent = system prompt + model + tools (the what). Environment = container + network allowlist + MCP tunnels (the where). Session = event log binding the two together. Keeping these separate makes each composable and swappable.
- **Brain/hands decoupling.** Separating the agent loop from tool execution brings two concrete benefits: (1) credentials live in encrypted vaults, never touching the inference container; (2) environments can be pre-warmed — eliminating per-session container spin-up time. Result: >90% reduction in P95 TTFT.
- **Sessions speak events, not tokens.** Rather than request/response (tokens in, tokens out), sessions produce events: user messages, tool calls, tool results, agent responses. Events append to a persistent log. A crashed container doesn't restart the agent loop — it resumes by replaying the event log.
- **Bring your own compute.** Announced at Code With Claude London 2026: developers can now run tool execution in their own containers and infrastructure rather than Anthropic's managed environment. The "wire protocol" (JSON tool definitions) stays the same; you swap the execution backend.
- **MCP tunnels for private servers.** Claude MCP tunnels allow MCP servers to run in private environments rather than on the public network — critical for enterprise security requirements.
- **Outcomes as goal specification.** Beyond tool calling: Managed Agents supports defining a rubric (`outcomes`) for what the agent should produce. The agent then decides which tool calls to make to reach the defined outcome — evaluation rubric replaces step-by-step instructions.
- **Vaults for credential management.** Encrypted credential store separate from the inference container. Per-user, per-session credential scoping without rolling your own secrets manager. Enabled by the brain/hands separation architecture.
- **Webhooks for event-driven resumption.** Sessions can listen for external webhooks and resume based on external events — e.g., a CI system signals completion, the agent resumes to process the result.
- **Context engineering remains developer responsibility.** Even with Managed Agents handling compaction/caching, the developer controls what files are uploaded to sessions, what context the agent operates over. "Context engineering is a huge portion of where developers spend time."

## Concepts Touched

- [[concepts/agent-harness]] — Managed Agents as a production harness; brain/hands decoupling; the maintenance cost of rolling your own harness
- [[concepts/agent-runtime]] — container architecture, TTFT reduction, bring-your-own-compute, event log as reliability mechanism
- [[concepts/context-engineering]] — developer responsibility for context even in managed environments
- [[concepts/agent-memory]] — memory and dreaming as advanced Managed Agents features
- [[concepts/subagent-patterns]] — sub-agents as Managed Agents primitive for context isolation and parallelism
- [[entities/tools-products]] — Claude Managed Agents platform primitives

## Notable Quotes

> "Harnesses should evolve alongside your agents. Back when we were building on Sonnet 4.5, we noticed it emitted context anxiety — it started wrapping up tasks early even when it still had room in its context window. When Opus 4.5 came out, we saw this behavior go away, making all that harness work essentially obsolete."

> "Claude Managed Agents is the fastest way to build production-ready agents on Claude. We've seen people build 10 to 15 times faster to production."

> "The key design decision: decoupling the agent loop from tool execution. This separation brings concrete benefits on security, reliability, latency — over 90% reduction in P95 TTFT."

> "Instead of responding in tokens in and tokens out, [sessions work] in units of events — user messages, tool calls, agent responses. Every event can be logged from an observability perspective and streamed back to the user."

> "Context engineering is a huge portion of where we see developers spending the majority of their time — managing what types of files are uploaded, how the agent processes those files."
