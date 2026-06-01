---
title: "Making Agentic Workflows Trustworthy and Verifiable with a Custom DSL"
author: James Brady (Elicit)
date: 2026-05-27
url: https://www.youtube.com/watch?v=qOjleN2-50c
tags:
  - reliability
  - verifiability
  - dsl
  - agent-engineering
  - agent-harness
  - anthropic
sources: trustworthy-agentic-dsl
updated: 2026-05-28
---

# Making Agentic Workflows Trustworthy and Verifiable with a Custom DSL

## Summary

- The **mechanism** by which an agent produces output matters as much as the output itself — identical results from a weak model vs a rigorous multi-step agent are fundamentally different objects from a trust perspective.
- Elicit (scientific research AI) built a custom domain-specific language called **AshPL** (æshPL) to make agentic research workflows legible, verifiable, and faithfully executed — three properties that natural language plans cannot guarantee.
- AshPL is Turing-incomplete, purely functional, reactive, and an opinionated subset of Python; its domain-specific primitives cover scientific research operations (paper retrieval, clinical trial lookup, web search, enrichment, curation).
- The core execution engine is a **write → interpret → redraft** loop between a curator (LLM writing AshPL in a sandbox) and a Python interpreter; the whole program is re-executed each loop, with a **content-address store** providing memoization.
- Not a recommendation for everyone — reach for a DSL when your product's trust model demands legibility, iteration fidelity, and faithful execution of a verifiable plan.

## Key Insights

### The Mechanism Matters

Two systems that produce identical output should not be trusted equally if their processes differ. An older model producing a static security analysis vs a current frontier model that has done tool use, critique, and redrafting represents fundamentally different epistemic weight — even if the output string is identical.

This is especially important in high-stakes domains (scientific research, legal analysis, clinical decisions) where users need to know *how* the answer was produced, not just *what* it is.

### Three Design Desiderata That Led to a DSL

Elicit identified three requirements before choosing a DSL:

1. **Legible process** — the research algorithm is readable and spot-checkable by both humans and other agents (critique agents can verify it).
2. **Iteration retains fidelity** — adding layers, new directions, or refinements doesn't cause the agent to drift from the original intent or get confused.
3. **Faithful execution** — once agreed on a plan, the system must actually execute it rather than improvising.

Natural language planning satisfies none of these reliably. A DSL satisfies all three.

### AshPL — The Language

- **Based on Python** (a subset) — LLMs have seen many Python examples; they don't need to learn new syntax, just the restricted subset
- **Turing-incomplete** — no loops, no recursion, no mutation; purely functional and reactive
- **Typed** — fast static type checking enables cheap error correction before execution
- **Domain primitives** — built-in operations for retrieving academic papers, clinical trials, web searches, document enrichment, filtering/screening
- **Opinionated** — deliberately removes unhelpful Python features and adds domain-specific ones

### The Execution Engine

```
curator (LLM in sandbox)
    ↓ writes AshPL
Python service
    ↓ parses + validates syntax + type checks
        → if errors: kick back to curator cheaply
    ↓ interprets (walks AST)
        → content-address store: hash expressions, cache results
    ↓ emit results
curator / user
    ↓ redraft AshPL (adding new steps, refinements)
    ↓ reinterpret whole program from top
        → almost all expressions are already cached
```

The whole program is re-executed each time — this makes cohesion guarantees easy. Executing only new snippets is where drift creeps in. The content-address store makes re-execution fast: previously computed expressions are looked up by hash rather than recomputed.

### Architecture Components

| Component | Role |
|---|---|
| UI (browser) | User interaction |
| Event log (append-only) | Durable state; distributed data structure |
| Python service | Message broker; interprets HPL; type checker |
| Sandbox (curator) | LLM that writes/redrafts AshPL |
| Wrapper | Abstraction layer for swapping harnesses and models |
| Gateway | LLM API routing; credential isolation (prevents prompt injection of env vars) |
| Content-address store | Memoization; enables full re-interpretation cheaply |

### What Makes This System Work (Engineering Checklist)

James Brady's list of what actually needed to be built beyond the DSL itself:

1. **DSL on a known base language** (Python — strong LLM training coverage)
2. **Wrapper for harness/model swapping** — able to switch between Agent SDK, pydantic-AI, and other harnesses without rewriting the curator
3. **Interrupt handling** — user can add requests mid-execution; they gracefully flow back to curator for plan redrafting
4. **Session rehydration** — resume sessions from event log; not natively supported by any harness
5. **Credential isolation** — gateway layer prevents user-injected prompts from exfiltrating API keys
6. **Message handling** — model outputs must be captured and routed, not dropped to stdout
7. **Event sourcing** — recommended pattern; adds resilience and auditability
8. **Dedicated eval team** — hard to eval a system that writes and executes programs on the fly; invest heavily here

> "A surprisingly small amount of work went into the DSL compared to everything else. Everything else is conventional software engineering to really turn it into a system that works."

### Speed vs Rigor Trade-Off

Elicit is firmly on the rigor side of the spectrum. The research tool will take hours building deep analysis rather than seconds giving surface answers. This is an explicit product choice, not a technical limitation. Different products sit at different points on this continuum — there is no universally "correct" mechanism.

### Graphical Plan Representation

The AshPL program can be rendered as a visual graph (derived directly from the AST, not a decorative visualization). Users can inspect the steps taken, spot where the plan looks skewed, and request additions or corrections in natural language. The plan is literally executable, not aspirational.

## Concepts Touched

- [[agent-harness]] — DSL-based harness as an alternative to natural language loop; wrapper/harness swapping pattern
- [[closing-the-loop]] — write → interpret → redraft as a verification loop
- [[context-engineering]] — content-address memoization as a context management technique
- [[subagent-patterns]] — critique agents can inspect AshPL for missed steps

## Notable Quotes

> "The mechanism, the *how* of how an answer is produced, is as important — and important in a different way — compared to just the final output itself."

> "It is literally the plan, which is executable. That's what lets us really be sure we're following through on the plan as stated."

> "My pitch is not that you should go and use a DSL. My pitch is that you should care a lot about the mechanism. Because the mechanism matters."

> "A table in Elicit is a fundamentally different thing to a table that's just been burbled out from a model."
