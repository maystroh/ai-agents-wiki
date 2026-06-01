---
title: Overview — AI Agents Wiki
updated: 2026-05-24
tags: [overview, synthesis]
---

# AI Agents Wiki — Overview

## Thesis

We are in the middle of a rapid architectural shift in how AI systems are built and deployed. The "model era" — where progress was measured by benchmark scores on single-turn outputs — is giving way to the "agent era," where the system surrounding the model matters as much as the model itself.

The central insight across nearly all sources in this wiki: **the model is the CPU; the harness is the operating system.** A powerful model running in a weak harness underperforms a slightly weaker model in a well-engineered harness. The competitive advantage is moving from pre-training to runtime design, skills, and evaluation infrastructure.

At the same time, a countervailing force is at work: **as models improve, the harness should shrink.** Every piece of scaffolding you built to compensate for 2024-era model weaknesses is technical debt that tomorrow's model will make obsolete. The winning strategy is "thin harness, fat skills" — minimal runtime infrastructure, but rich, modular, maintainable skill libraries.

## The Stack (As of 2026)

```
┌──────────────────────────────────┐
│  Skills / Prompts (SKILL.md)     │  Cheapest to change. Daily cadence.
│  Agent configuration (AGENTS.md) │  Human-written. Encodes taste & workflow.
├──────────────────────────────────┤
│  Agent Harness                   │  Medium cost. Weekly cadence.
│  (context mgmt, tool loop,       │  Claude Code, OpenClaw, LangChain, etc.
│   sub-agent topology, verifiers) │
├──────────────────────────────────┤
│  Foundation Model (LLM)          │  Most expensive. Quarterly updates.
│  + Post-training on harness      │  Labs own this layer.
├──────────────────────────────────┤
│  Agent Runtime / Sandbox         │  Infrastructure. Firecracker, E2B, Modal.
│  (compute, filesystem, tools,    │  Slow-moving but critical for correctness.
│   isolation, state management)   │
└──────────────────────────────────┘
```

## Key Trends (2025–2026)

### 1. From Shallow to Deep Agents
Agents 1.0 were simple reactive loops: user prompt → LLM → tool call → repeat. These break at ~15+ steps. Agents 2.0 ([[agents-evolution]]) add: explicit planning, hierarchical delegation via sub-agents, persistent memory external to the context window, and extreme context engineering.

### 2. The Harness is the OS
The [[agent-harness]] sits between the model and the environment. It handles: system prompts, tool surfaces, rollout protocols, context management, memory, sub-agent topology, guardrails, verifiers, and observability. First-party harnesses (Claude Code, Codex) outperform third-party ones on the same model because the model was post-trained against that harness's specific tool schemas and loop shape. Exception: Letta Code beats Claude Code on Opus 4.5 by investing heavily in memory — a dimension Claude Code underweights.

### 3. Context Engineering is the Discipline
[[context-engineering]] is not about putting more in context — it's about finding the minimal effective context for the next step. Key techniques: compaction (strip reversible info), summarization (lossy compression at rot threshold), sub-agent isolation (share context by communicating, not communicate by sharing context), hierarchical tool surfaces (atomic tools → sandbox utilities → code packages).

### 4. Skills are the Cheapest Optimization Surface
[[agent-skills]] (SKILL.md) are modular, progressive-disclosure extensions. The description is a routing trigger, not documentation. Bodies should be under 500 lines, start with "Load when..." and focus on gotchas the model doesn't already know. Perplexity runs a three-tier cost model: Index (~100 tokens per skill, always paid) → Load (~5,000 tokens) → Runtime (unbounded, conditional). "Every Skill is a tax."

### 5. Sub-agent Orchestration Patterns
Four patterns, ordered by orchestration complexity: [[subagent-patterns]]: (1) Inline tool — simplest, any model; (2) Fan-out — spawn + wait, needs model that can interleave work; (3) Agent Pool — persistent stateful agents with messaging; (4) Teams — agents talk to each other directly. Start at Pattern 1. Move up only when the simpler pattern demonstrably fails.

### 6. Inner Loop vs Outer Loop
[[inner-outer-loop]]: Inner loop = verify within a single task (write tests, run, read errors, fix, re-run). Outer loop = carry lessons across sessions (memory, skills, rules files). Most agents today only do the inner loop. The outer loop — where agents actually learn from failures — is still rare.

### 7. Automated AI Research
[[automated-research]]: AI agents can now run hundreds of ML training experiments overnight (Karpathy's autoresearch, Tobi Lütke's 0.8B model beating a 1.6B). Jack Clark (Import AI 455) estimates 60%+ probability of fully automated AI R&D by 2028. The eval is the bottleneck: if you can't evaluate it, you can't auto-research it.

### 8. The Bitter Lesson Applies to Harnesses
Rich Sutton's Bitter Lesson (general methods beat hand-coded intelligence over time) applies directly to agent harnesses. Manus rewrote their harness 5 times in 6 months; LangChain rewrote open-deep-research 4 times. The right posture: treat each production harness as a 90-day artifact. Build to delete. The structure you add for today's model capability will be eaten by the next model release.

### 9. Agent Engineering ≠ Software Engineering
[[agent-engineering]]: Senior engineers often struggle because they try to force deterministic patterns onto probabilistic systems. Key mindset shifts: text is the new state (preserve semantic richness, don't force booleans), hand over control flow to the model, treat errors as inputs (not exceptions), use evals not unit tests, design APIs for agents (verbose, explicit, "idiot-proof" semantic typing).

### 10. Toward Automated AI R&D
The METR time horizon plot tells the story: AI task independence has gone from 30 seconds (GPT-3.5, 2022) to 4 minutes (GPT-4, 2023), 40 minutes (o1, 2024), 6 hours (GPT 5.2, 2025), 12 hours (Opus 4.6, 2026). Labs are openly targeting automated AI R&D (OpenAI: "automated AI research intern by Sep 2026"; Anthropic: automated alignment researchers). This is the trajectory that everything in this wiki is headed toward.

## Open Questions

- When does the outer loop (agents learning across sessions) become reliable enough to trust in production?
- At what point do first-party harnesses lose their advantage as models generalize better?
- How do multi-agent teams avoid coordination failures (deadlocks, conflicting edits, lost context)?
- What eval infrastructure is needed for long-horizon tasks that take hours or days?
- Can taste/aesthetics judgment be trained into models, or does it remain a human-in-the-loop requirement?

## See Also
- [[agent-harness]] · [[agent-skills]] · [[subagent-patterns]] · [[context-engineering]]
- [[inner-outer-loop]] · [[closing-the-loop]] · [[agent-runtime]] · [[automated-research]]
- [[agent-engineering]] · [[agents-evolution]] · [[mcp-servers]]
- [[entities/people]] · [[entities/tools-products]]
