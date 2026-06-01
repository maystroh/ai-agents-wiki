---
title: MCP Servers — Model Context Protocol
tags:
  - mcp
  - tools
  - integration
  - core-concept
aliases:
  - MCP
  - Model Context Protocol
sources:
  - use-mcp-servers
  - hidden-debt-harness
  - tool-skill-subagent-decomposition
updated: 2026-05-28
---

# MCP Servers — Model Context Protocol

## What is MCP?

The **Model Context Protocol (MCP)** is a shared interface for exposing tools to LLM agents, introduced by Anthropic in late 2024. MCP servers expose callable tools via a standardized protocol that agents can discover and call at runtime.

Unlike native tools built into the harness, MCP servers live outside the harness and must be connected. This has a critical implication: **blindly enabling MCP servers bloats your context**, which leads to higher cost and worse performance.

> [!warning] MCP bloat vs Skills progressive disclosure
> Agent Skills use progressive disclosure — only the index-tier description loads until triggered. MCP servers don't have this out of the box. Every tool from every connected MCP server lands in your tool surface, whether you need it or not. It's your responsibility to select the tools needed for the task.

## Two Correct Patterns

### Pattern 1 — Explicit MCP: Inline Tool Injection

MCP servers stay **opt-in**. Servers are referenced in prompts with `@mentions`. The agent resolves, fetches, and injects tools before the model request. Nothing loads unless requested.

**Flow:**
1. User writes `@github` or `@slack` in a prompt
2. Agent resolves `@mention` to registered MCP server URL
3. Fetches tool schemas from the server
4. Injects into `tools[]` array of the API request
5. Model decides what to call

```typescript
async function handlePrompt(prompt: string) {
  const mentions = parseMentions(prompt); // ["@github", "@slack"]
  const servers = mentions.map(m => mcpServers.resolve(m));
  const mcpTools = await Promise.all(servers.map(s => s.listTools()));
  const response = await llmCall({
    prompt,
    tools: [...nativeTools, ...mcpTools],
  });
}
```

**When to use:** MCP usage is occasional and user-driven. Someone asks a question that needs Slack or GitHub data — they `@mention` the server, it gets pulled in for that request only. Keeps costs low, avoids tool noise on tasks that don't need external integrations.

---

### Pattern 2 — Subagent MCP: Scoped Per Agent

MCP servers declared in subagent definitions and automatically available at runtime alongside native tools. Each subagent has its own config specifying which MCP servers it uses, and crucially, which tools within those servers it's allowed to call (`allowed_tools`).

```yaml
# code_reviewer.md
---
name: code-reviewer
model: gemini-3-flash
mcp_servers:
  - url: https://github-mcp.example
    allowed_tools:
      - list_pulls
      - list_reviews
      - get_diff
---
You are a code reviewer. Review open PRs...
```

**Why `allowed_tools` matters:** Least-privilege scoping without forking the MCP server. The code reviewer can read PRs but not push code.

**When to use:** The use case dictates the tools. A code review agent always needs GitHub. A support agent always needs Zendesk. The MCP servers are part of what the agent *is*, not something a user opts into per request.

## MCP vs Skills: The Decision Rule

MCP was designed for chatbots (stateless, no shell access, serverless). Claude Code is a coding agent with a shell. This changes the calculus significantly.

**Rule of thumb (from Anthropic's Claude Code team, May 2026):**
> If you already have a CLI, wrap it in a skill — not an MCP server. MCP is for public-facing integrations to non-technical customers, or for services you genuinely don't control.

| Scenario | Use MCP | Use Skill |
|---|---|---|
| Your team already has a CLI tool | | ✓ |
| Shipping integration to non-technical external users | ✓ | |
| Developer already has source access + auth | | ✓ |
| Auth and transport need standardized handling | ✓ | |
| Third-party services (Slack, GitHub, email) | ✓ | |
| Internal domain knowledge / runbooks | | ✓ |

The key insight: MCP handles auth + transport, which matters when your users don't have shell access. If your users are developers in your company's codebase, they already have auth and can use the CLI directly — a skill that tells Claude how to use that CLI is simpler and cheaper.

## Tool Search — Lazy-Loaded MCP

Anthropic's approach to scaling MCP beyond ~20 servers: **tool search** (lazy loading).

Instead of injecting all tool schemas into the system prompt, only tool names go in upfront. Claude is told it has a `search_tools` capability; when it needs a specific tool, it searches for it and receives the schema on demand.

**Limitation:** Claude only knows to search if the context provides a keyword hint (user says "Slack" → Claude searches for Slack tool). Generic tools (bash, file edit) still need their schemas upfront. There's no free lunch — more description = more likely to trigger search, less description = cheaper but less reliable.

## The Tool Hierarchy: Humanlike Primitives First

Anthropic's internal guidance for agent tool design (from Applied AI team practice with customers, 2026):

```
Start → Humanlike primitives (code execution, file system, web search, todo list)
            ↓ remove what you don't need
       Add custom tools (agent-specific, not shared)
            ↓ only when primitives are insufficient
       Add MCP servers (only when shared by multiple agents/clients)
```

The rationale for **humanlike primitives first**: Claude is post-trained on human computer use patterns. Code execution, file navigation, and web search are how people work — Claude uses these primitives better than it uses custom tool APIs, and adding code execution often makes custom retrieval/analysis tools unnecessary.

**The MCP anti-pattern:** Many teams rush to MCP first, ending up with a chaotic ecosystem of overlapping MCP servers that pollute context and create tool selection confusion. MCP should be the last resort for standardization across multiple clients — not the default tool delivery mechanism.

**Code execution as MCP alternative:** Giving Claude a bash tool to write and run code (Python scripts, CLI invocations, API calls) can replace entire categories of MCP tools. Claude writes a script, runs it, reads the output — rather than receiving a custom MCP-formatted response. No schema design, no server maintenance, and the approach scales as Claude models improve at code.

| Tool Type | When to use |
|---|---|
| Humanlike primitives (bash, file, web, todo) | Always start here; remove if not applicable |
| Custom tools | When a specific agent needs capabilities not in primitives |
| MCP servers | When multiple agents/clients need shared, standardized, governed tool access |

## What to Avoid

> [!danger] Don't use RAG to manage tool definitions
> Fetching tool definitions dynamically per step (based on semantic similarity) creates a shifting context that breaks the KV cache. The model may "hallucinate" tools that were present in turn 1 but disappeared in turn 2.

> [!warning] Don't enable all MCP servers globally
> A global MCP tool surface of 100+ tools leads to Context Confusion — the model hallucinates parameters or calls wrong tools. Scope MCP servers to the agents/requests that actually need them.

## MCP and the Dissolving Harness

As models improve at reading raw API specs and writing helper code themselves (see [[agent-harness]]), the case for elaborate MCP wrapper schemas weakens. Browser Use's argument: don't wrap Chrome's DevTools Protocol — the model has read thousands of CDP examples and can write the helper it needs on the fly.

MCP won't disappear, but the elaborate tool-schema engineering that accompanies it may. The stable layer is the protocol (shared interface); the unstable layer is how many hand-crafted tool definitions you need to pre-expose.

## See Also
- [[agent-skills]] — Skills as the alternative/complementary extension mechanism
- [[agent-harness]] — how MCP tools are integrated into the harness
- [[context-engineering]] — why tool surface size affects context quality
- [[subagent-patterns]] — Pattern 2 (subagent MCP) maps to Subagent MCP pattern
