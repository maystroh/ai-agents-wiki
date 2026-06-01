---
title: "Hidden Technical Debt of AI Systems: Agent Harness"
author: Unknown
date: 2025
tags:
  - misc
  - harness
  - technical-debt
  - infrastructure
---

# Hidden Technical Debt of AI Systems: Agent Harness

## Summary

- Frames the agent harness as a source of hidden technical debt: investment in harness engineering is systematically devalued by model improvements
- Catalogs debt patterns: over-specified rollout protocols, hardcoded tool routing, context management logic that duplicates model capability
- Argues for the "thin harness" principle: move logic to Skills and system prompts, not harness code
- Covers MCP's context bloat problem: every enabled MCP server adds to the tool surface whether needed or not

## Key Insights

- **Harness debt compounds faster than application debt.** A model update that absorbs a harness feature makes the harness code actively harmful — it now adds latency and bugs to behavior the model handles natively.
- **Three forms of hidden debt:** (1) Logic that mirrors model capability, (2) Context management that fights the model's native compression, (3) Tool routing that bypasses the model's own tool selection.
- **MCP bloat is structural, not accidental.** The protocol doesn't provide progressive disclosure; you have to engineer it in with scoping and `allowed_tools`.
- **The test for a harness component:** "Would a better model make this component unnecessary?" If yes, treat it as temporary.

## Concepts Touched

- [[agent-harness]] — full treatment, including the Bitter Lesson
- [[mcp-servers]] — MCP bloat discussion
- [[context-engineering]] — context management as harness responsibility

## Notable Quotes

> "A harness component that mirrors what a better model would do natively is not an asset — it's a liability waiting to be paid."
