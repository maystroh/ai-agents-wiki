---
title: "Beyond the Basics with Claude Code"
author: "Daisy Holman (Engineer, Claude Code team, Anthropic)"
date: 2026-05-26
url: https://www.youtube.com/watch?v=tuY2ChJIx48
tags:
  - agent-harness
  - context-engineering
  - mcp
  - skills
  - hooks
  - plugin-architecture
  - kv-cache
  - anthropic
  - ai-agents
sources:
  - "AI Agents/Claude/2026-05-26"
updated: 2026-05-27
---

# Beyond the Basics with Claude Code

## Summary

- Advanced Claude Code talk (Code With Claude, May 2026) focused on customizing agentic harnesses for large-scale software engineering — monorepos, thousands of engineers, 100K+ skills
- Three things agents need that vanilla Claude Code can't provide: **access** (Slack, CI, dashboards, design docs), **knowledge** (institutional memory, codebase conventions), **tooling** (IDE equivalent for agents)
- Context window is fixed at ~1M tokens and not growing; the KV cache constraint fundamentally changes how you should structure system prompts — stable shared content at the front, volatile per-task content at the back
- Four plugin primitives analyzed for large-scale use: MCP (doesn't scale without shell), Skills (partial scale — description always loaded), Hooks (zero-overhead — runs outside context), Agents/sub-agents (offloads tokens but description tax remains)
- Future directions: Claude-to-Claude communication, /loop for background recurring tasks, Auto Mode as permission layer for overnight work, Claude Agents terminal view as orchestration dashboard

## Key Insights

- **If Claude can't do everything you can do, it can't do your job with you.** The thesis: Claude needs access to everything you have — Slack threads (the why behind decisions), CI results, dashboards, meeting notes, internal docs. The gap between what Claude sees and what you see is the quality gap.
- **Context window is a fixed target.** At ~1M tokens, context windows haven't grown in a year even as models improved. Treating context as unlimited is an engineering mistake. The constraint is real.
- **The KV cache breaks naive eviction.** Changing anything in the early prompt invalidates cached tokens for everything that follows — making cached tokens 10× cheaper than uncached irreversible. You can't LRU-evict tools mid-task without paying the full uncached cost. Rule: stable shared content (system prompt, core tools) goes first; volatile per-task content goes at the end.
- **MCP was designed for chatbots, not shell-equipped coding agents.** MCP handles auth and transport, but it was built assuming the LLM has no shell. If you have a CLI, wrap it in a skill instead of an MCP server (except for public-facing integrations to non-technical customers).
- **Tool search = lazy-loaded MCP.** Anthropic's approach to scaling MCP: only tool names go in the system prompt; schemas are fetched on demand. Limitation: Claude doesn't know to search unless the user mentions a keyword (Slack, email), so generic tools still need upfront schemas.
- **Skills = lazy system prompts.** The description (always loaded, ~100–400 tokens per skill) is the index-tier cost. The body is pay-per-use. At 100,000 skills in a monorepo, the index-tier cost dominates. Skill hierarchy (sub-skills) is coming soon.
- **Hooks = zero-overhead abstractions.** Hooks run outside the context window — no token cost unless they inject content. You can have 100,000 hooks; if 99,995 don't trigger, you pay nothing. This is the "red squigglies" for agents — nudging without hard-blocking, at true zero overhead.
- **Tools that scale with intelligence vs compensate for lack of intelligence.** Prefer the former: overridable nudges, linters, red squigglies. Avoid the latter: hard blocks that constrain agent behavior regardless of context.
- **Plugin CLAUDE.md is rejected by design.** Allowing plugins to inject unconditional system prompt text would be expensive and every plugin would do it. Instead, plugins can use session-start hooks — making the cost explicit and visible.
- **Async + parallelism = context switching discipline.** The future of software engineering is managing many agents in parallel. Work trees (different checkouts, different agents) + persistent long-lived sessions = the daily workflow. Session rename + color = human memory aids.
- **Claude-to-Claude communication via sendMessageTool.** Any Claude session should be able to message any other Claude on the same account (with permission). The agent you're working with is itself a tool-wielding colleague — treat it as one.

## Concepts Touched

- [[concepts/context-engineering]] — KV cache constraint, stable/volatile placement, "don't pay for what you don't use"
- [[concepts/mcp-servers]] — MCP at scale, tool search lazy loading, MCP vs skills decision rule
- [[concepts/agent-skills]] — skills scaling limit, hook as zero-overhead alternative, description tax
- [[concepts/agent-harness]] — three pillars of harness customization: access, knowledge, tooling
- [[concepts/subagent-patterns]] — Claude-to-Claude messaging, sub-agent context isolation
- [[concepts/inner-outer-loop]] — /loop as background recurring task mechanism; async/parallel as the new normal

## Notable Quotes

> "If Claude can't do everything you can do, it can't do your job with you."

> "Context windows aren't really growing. The frontier of context windows hasn't changed in a year — and the models have gotten way better. So you kind of have a fixed target."

> "If you go and change something really early in the prompt, you're going to end up paying for uncached tokens — which cost 10 times as much — for all of the rest of your context window after that change."

> "Hooks can't do everything. They're not perfect. But they are an actual zero overhead abstraction. We give you event types to trigger on, and then we just call this script."

> "MCP was designed in an era where LLMs were much simpler — primarily to work with chatbots. Your chatbot doesn't have access to files on your computer. It can't run commands. It can't use a CLI."

> "The fastest way to make your agent better at your codebase isn't a smarter model, it's a tighter feedback loop."

> "If you have 100,000 hooks and 99,995 of them don't trigger, don't match, or don't return any text — your only constraint is your computer."
