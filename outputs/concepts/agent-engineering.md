---
title: Agent Engineering vs Software Engineering
tags:
  - agent-engineering
  - mindset
  - core-concept
  - evals
aliases:
  - Agentic Engineering
  - Probabilistic Engineering
sources:
  - why-engineers-struggle
  - karpathy-vibe-to-agentic
  - how-to-work-with-ai
updated: 2026-05-24
---

# Agent Engineering vs Software Engineering

## The Core Tension

Traditional software engineering is **deterministic**. Inputs + code = predictable outputs. Engineers are Traffic Controllers: they own the roads, the lights, and the laws.

Agent engineering is **probabilistic**. You are a Dispatcher. You give instructions to a driver (an LLM) who might take a shortcut, get lost, or decide to drive on the sidewalk because it "seemed faster."

> [!info] The junior engineer paradox
> Junior engineers often ship functional agents faster than senior engineers. The more senior the engineer, the less they trust the LLM's reasoning — and the more they try to "code away" the probabilistic nature. You cannot code away the probability. You must manage it.

## Vibe Coding → Agentic Engineering

Karpathy coined "vibe coding" (late 2024): raising the floor — anyone can build anything by vibing with an LLM.

**Agentic engineering** (2025–2026): preserving the quality bar of professional software while using agents to go faster. Not just "programming faster" — an engineering discipline for coordinating stochastic, powerful, imperfect agents without sacrificing correctness or security.

> [!quote] Karpathy
> "Agentic engineering is how do you coordinate agents to go faster without sacrificing your quality bar. People who are very good at this peak a lot more than 10x."

## Five Mindset Shifts for Engineers

### 1. Text is the New State

Deterministic systems force intent into binary fields and typed schemas. This destroys semantic richness.

| Software Engineering | Agent Engineering |
|---|---|
| `{ "status": "APPROVED" }` | `{ "text": "This plan looks good, but please focus on the US market." }` |
| `{ "is_celsius": true }` | `"I prefer Celsius for weather, but Fahrenheit for cooking"` |

By preserving text, downstream agents can read the full nuance and adjust dynamically. Forcing natural language into booleans lobotomizes the context.

### 2. Hand Over Control Flow

In microservices, intent maps to a route (`POST /subscription/cancel`). In agents, there's a single natural language entrypoint, and the LLM decides the control flow based on available tools, input, and instructions.

Interactions don't follow straight lines — they loop, backtrack, and pivot. Hard-coding every edge case defeats the purpose of using an agent. Trust the agent to navigate. The skill is in the system prompt and tools, not the explicit state machine.

### 3. Errors are Just Inputs

In traditional software: exception → crash immediately → fix the bug.

In agents: an agent might take 5 minutes and cost $0.50. If step 4 of 5 fails, crashing the whole execution is unacceptable. **Catch the error, feed it back to the agent, and try to recover.** An error is information, not a failure mode to suppress.

### 4. Evals Over Unit Tests

You cannot unit test an agent. Binary assertions fail for creative or reasoning tasks — "Write a summary of this email" has infinite valid outputs. Mocking the LLM means you're testing string concatenation, not the agent.

What to measure instead:

| Dimension | What it means |
|---|---|
| **Reliability (Pass^k)** | Not "Did it work?" but "How often does it work?" (3–5 trials per prompt) |
| **Quality (LLM-as-judge)** | "Is the answer helpful? Accurate? Tone correct?" |
| **Tracing** | Check intermediate steps — did the agent search the knowledge base before answering? |

> [!tip]
> If your agent succeeds 45/50 times with a quality score of 4.5/5, it can be production-ready. You're managing risk, not eliminating variance.

### 5. Design APIs for Agents (Literalists)

Humans infer context. Agents do not. Agents are **literalists** — if an ID format is ambiguous, the agent will hallucinate one.

| Bad (human-grade API) | Good (agent-grade API) |
|---|---|
| `delete_item(id)` — What is id? Int? UUID? | `delete_item_by_uuid(uuid: str)` with docstring: "Deletes an item. If not found, return a descriptive error string." |
| `get_user(id)` | `get_user_by_email_address(email_address: str)` |

Also: agents can adapt to API changes just-in-time. They read the new tool definition and adjust — something human developers can't do at runtime.

## The Taste Problem

Some dimensions remain hard to delegate:
- Aesthetics and judgment (what makes code elegant, not just correct)
- Specification and intent (describing *what* you want, not *how* to get it)
- Oversight of weird edge cases (agents make mistakes that look like a "10-year-old + PhD" in the same entity)

> [!quote] Karpathy on jaggedness
> "I simultaneously feel like I'm talking to an extremely brilliant PhD student who's been a systems programmer their entire life, and a 10-year-old. The jaggedness is really strange."

The jaggedness persists in domains outside the RL reward signal. Models improve rapidly on verifiable tasks (code, math). Softer domains (nuance, aesthetics, clarifying questions) improve more slowly.

## Practical Setup for Agentic Engineers

From Eugene Yan's workflow:
- **Context as infrastructure** — organized workspace the model can navigate with `grep`/`glob`; annotated INDEX.md per project
- **Taste as configuration** — CLAUDE.md as behavioral contract ("be direct, push back when you disagree")
- **Verification for autonomy** — post-edit hooks (ruff format, ruff check) as cheapest verification; escalate to tests, evals, LLM reviews
- **Delegation** — explain intent + constraints + success criteria upfront; let model execute end-to-end; run 3–6 sessions in parallel using git worktrees
- **Closing the loop** — mine transcripts for config updates; refactor/prune CLAUDE.md when rules overlap or conflict

## See Also
- [[agent-harness]] — the system that makes agents manageable at scale
- [[agent-skills]] — encoding taste and workflow as reusable skills
- [[evals-and-graders]] — evals over unit tests: the measurement discipline for probabilistic systems
- [[closing-the-loop]] — verification behavior that closes the quality gap
- [[inner-outer-loop]] — reliability vs learning across sessions
- [[automated-research]] — the end state: removing humans from most loops
- [[agents-evolution]] — the architectural shift (Agents 1.0 → 2.0) that made the probabilistic engineering mindset necessary
