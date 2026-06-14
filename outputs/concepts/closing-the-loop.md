---
title: Closing the Loop — Agent Self-Verification
tags:
  - reliability
  - verification
  - self-awareness
  - core-concept
aliases:
  - Loop Closing
  - Self-verification
sources:
  - closing-the-loop
  - inner-outer-loop
  - how-to-work-with-ai
  - codex-maxxing-jason-liu
updated: 2026-05-29
---

# Closing the Loop — Agent Self-Verification

## What "Closing the Loop" Means

An agent closes its loop when it doesn't return to the user until it has **verified its own work against external signals** — not based on its own judgment of correctness, but based on the compiler, the test runner, the filesystem, or another LLM call.

> [!quote]
> "The good ones feel like working with a colleague. They plan, check, and try to catch their own mistakes and only then tell you it's done." — Philipp Schmid

## Examples of Loop Closing

- **Code changes →** agent runs `npm test`, reads the error trace, fixes the edge case, re-runs until green — before telling you it's done
- **File writes →** agent reads the file back after writing to confirm the diff matches intent
- **Requirements →** agent compares final output against original task list to check nothing was missed

## Self-Awareness as a Prerequisite

Two things separate agents that close loops from those that don't:

1. **Self-awareness** — functional understanding of constraints (context window size, available tools), own mechanics (which tool to use when), and calibrated uncertainty ("this regex is complex, I should test it")
2. **Closing the loop** — the willingness to call verification tools before declaring done

Self-awareness here is not consciousness — it's operational self-knowledge that produces better meta-task behavior. Anthropic's introspection research (Oct 2025) showed Claude can distinguish between artificially injected outputs and its own generated ones — a mechanism that improves meta-task performance.

## Scaffolded vs Spontaneous Verification

### Scaffolded (Today's Standard)
Most loop-closing in production is built *around* the agent — verification steps added to the harness, not initiated by the agent itself.

**Spotify's background coding agent** (1,500+ PRs):
- Independent verifiers (Maven, test runners, formatters) exposed as a single MCP tool
- Agent calls "verify" → gets pass/fail
- LLM judge separately compares diff against original prompt to catch scope creep

The agent doesn't know what the verifier does internally; it just knows to call it.

### Spontaneous (Emerging)
DeepMind's intrinsic self-critique paper: a single LLM checks its own plan step-by-step against task rules after each action — no external signal, just asking "does this step actually follow the rules?" This alone boosted planning success from **50% → 89%**.

> [!info] The trajectory
> Scaffolded verification works when the setup tells the agent to do it. Spontaneous verification is when the agent knows it should, independent of explicit instruction. We're moving from the former toward the latter.

## Pair Programmer Pattern (Long Sessions)

For long-running tasks, a secondary agent with fresh context monitors the primary:

```
Primary agent: executes the task
Secondary agent (pair programmer):
  - Reads original spec + recent transcript of primary
  - Checks for execution drift (doing task wrong — local/tactical)
  - Checks for direction drift (doing wrong task — big picture/strategic)
  - Provides feedback to course-correct
```

Eugene Yan's setup: two tmux panes, shared instruction file, pair programmer spins up periodically to check spec against primary's recent transcript.

## Goals as Verification Oracles

A Goal (OpenAI Codex feature) is a bounded task with an external success criterion the agent evaluates autonomously — not a Markdown plan to "implement."

> "Execution is only as good as the goal and the verification you give it. Ambition without verification is just a wish." — Jason Liu

**Weak goal:** "implement the plan in this Markdown file"  
**Strong goal:** "migrate the Rich Python library to Rust; it must pass all unit tests from the original Python library"

The test suite is the oracle. The agent can keep pushing without human involvement because the loop has a real exit condition. This is the same principle as Spotify's verifier tool — an external signal, not the model's self-assessment of "done."

**Steering** (also from Codex) complements Goals by enabling mid-execution correction: you inject additional direction into the queue while the agent is still working on the current step, then walk away. The loop keeps running with the updated intent already queued.

**See:** [[sources/misc/codex-maxxing-jason-liu]] for detailed Goal and Steering examples.

## What Comes Next

- **Trained-in verification** — post-training with verification behavior as a reward signal, making it default rather than prompted
- **Persistent outer loop** — agents that carry lessons from one session's failures into the next session's behavior ([[inner-outer-loop]])
- **Heartbeat-driven feedback loops** — agents that self-schedule recurring checks across multiple tool boundaries, running without human re-initiation ([[inner-outer-loop]])

## See Also
- [[inner-outer-loop]] — inner loop (verify within task) vs outer loop (carry lessons across sessions)
- [[agent-engineering]] — why engineers trained on deterministic systems struggle to trust agents to self-verify
- [[agents-evolution]] — Agent 2.0 architecture; verification is enabled by Pillar 1 (planning) and Pillar 3 (persistent memory)
- [[agent-harness]] — scaffolded verification (Spotify's verifier MCP tool, LLM judge) is a harness-layer implementation
- [[agent-skills]] — Verification Skills: packaging verification behavior as self-improving SKILL.md files that document and propagate blockers
- [[evals-and-graders]] — QA loops in closing-the-loop are a form of in-task eval; evals-and-graders covers the grader types that implement them
