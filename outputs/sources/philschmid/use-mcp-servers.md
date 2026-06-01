---
title: "How to Use MCP Servers"
author: Philipp Schmid
date: 2026-04-27
url: https://www.philschmid.de/use-mcp-servers
tags:
  - philschmid
  - mcp
  - tools
  - integration
---

# How to Use MCP Servers

## Summary

- Explains two correct patterns for integrating MCP servers into agent workflows
- Pattern 1: Explicit @mention injection — MCP servers stay opt-in, loaded only when user @mentions them in a prompt
- Pattern 2: Subagent MCP — servers declared in subagent definitions, scoped with `allowed_tools` for least-privilege access
- Warns against two anti-patterns: RAG-based tool selection and globally enabled MCP servers
- Notes the "dissolving harness" trend: as models improve, elaborate MCP wrapper schemas may become unnecessary

## Key Insights

- **Blindly enabling MCP servers bloats context.** Unlike Skills (progressive disclosure), every tool from every connected MCP server lands in the tool surface whether needed or not.
- **@mention injection is opt-in per request.** Server tools are injected for that request only — keeps cost low and avoids tool noise.
- **`allowed_tools` is least-privilege scoping without forking.** A code reviewer can list PRs but not push code, without needing a separate server deployment.
- **Don't use RAG for tool definitions.** Fetching tool definitions dynamically per step breaks the KV cache and can cause the model to hallucinate tools that were present in turn 1 but gone in turn 2.
- **100+ tools → context confusion.** The model hallucinates parameters or calls the wrong tool. Never enable all MCP servers globally.

## Concepts Touched

- [[mcp-servers]] — full concept page
- [[context-engineering]] — tool surface as a context management concern
- [[subagent-patterns]] — Pattern 2 (subagent MCP)
- [[agent-harness]] — MCP integration as a harness responsibility

## Notable Quotes

> "It's your responsibility to select the tools needed for the task. MCP doesn't have progressive disclosure out of the box."
