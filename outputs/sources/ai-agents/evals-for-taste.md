---
title: "Evals for Taste: Hill-Climbing a Slide-Generation Agent"
author: Anthropic (Code with Claude London, 2026-05-27)
date: 2026-05-27
url: https://www.youtube.com/watch?v=v9FTCvkV_a0
tags:
  - evals
  - agent-engineering
  - graders
  - hill-climbing
  - quality
  - anthropic
sources: evals-for-taste
updated: 2026-05-28
---

# Evals for Taste: Hill-Climbing a Slide-Generation Agent

## Summary

- Evals are systematic tests that measure how well an AI system performs on a specific domain or use case — they bridge "it seems to work" (vibes) and "we know it works" (measurable data).
- Three grader types exist on a cost-quality spectrum: **code-based** (deterministic, fast, brittle), **model-based** (LLM-as-judge, flexible, nondeterministic), and **human** (highest quality, slowest, used for spot-checks and AB testing).
- The session demonstrates **hill-climbing** on a slide-generation agent: run evals → inspect failures → update system prompt or agent config → rerun → repeat.
- A **QA loop** (creator + adversarial critic) is a universally applicable pattern — the critic is explicitly told "assume there are problems, approach as a bug hunt, not a confirmation step."
- Switching from Sonnet 4.7 to Opus 4.7 with a *simpler* prompt outperformed Sonnet 4.7 with a detailed prompt, illustrating that model capability can substitute for prompt engineering — and that evals make this comparison legible.

## Key Insights

### Three Grader Types

| Type | Examples | Pros | Cons |
|---|---|---|---|
| **Code-based** | String match, emoji count, slide count, shape count | Fast, cheap, deterministic | Brittle, lacks nuance |
| **Model-based** (LLM judge) | Color contrast score (0–5), layout quality, text coherence | Flexible, scalable, nuanced | Nondeterministic, costly, requires calibration |
| **Human** | Subject matter expert review, AB testing | Highest quality, most nuanced | Very slow, very expensive |

Mix both: code graders for what you can count, model graders for what requires judgment. Human review is for spot-checks and calibrating model graders.

### Eval Calibration: Score-After-Reasons Pattern

A critical anti-pattern with LLM judges: ask for a score *then* ask for reasons. Because LLMs are autoregressive, they anchor to the first score and post-hoc rationalize it — even if the output is bad, they'll defend the score they committed to.

**Correct pattern:** Ask for pros and cons first, then ask for a final score. The model reasons its way *to* a score rather than from one.

Multi-judge consensus (best-of-three majority vote) adds reliability, especially when individual runs fluctuate.

### Hill-Climbing Workflow

```
run evals
    ↓
inspect failures (what dimensions are scoring low?)
    ↓
update agent (system prompt, model, tools, QA loop)
    ↓
rerun evals
    ↓
(check for unexpected regressions)
    ↓
repeat
```

The slide agent progressed through: basic → typography-aware → diagram-required → QA-looped, each iteration driven by specific eval signals, not intuition.

### Evals as Living Artifacts

Evals should evolve with the system. **Eval saturation** — when an eval stops providing useful signal — is a real risk. If a model consistently scores 5/5 on a judge, either (a) the system genuinely improved, or (b) the judge is measuring the wrong thing. Human spot-checks diagnose which.

### QA Loop Pattern

To add a QA loop: instruct the agent to convert slides to images after writing the deck, inspect every slide image, fix issues, rerender, reinspect — and **not to stop until completing at least one fix-and-verify cycle**. The key framing: "assume there are problems" rather than "check if there are problems."

### Model Selection via Evals

Opus 4.7 with the minimal initial prompt outperformed Sonnet 4.7 with a carefully tuned typography/layout prompt on several quality dimensions (color judge, layout judge, emoji count). Evals make this comparison concrete rather than relying on intuition. Without evals, the choice between a smarter model and better prompting is a guess.

## Concepts Touched

- [[evals-and-graders]] — types of graders, calibration techniques, hill-climbing
- [[agent-skills]] — skills as one of the levers in the hill-climbing loop
- [[agent-engineering]] — mindset: measure what you care about; make changes actionable
- [[closing-the-loop]] — QA loop as a form of verification

## Notable Quotes

> "Evals are the bridge between 'it seems to work' and 'we know it works.'"

> "It's not because you have set up your evals once that they are now the ground truth. Evals over time need to be a living artifact — it's not something you make once and then forget."

> "Approach QA as a bug hunt, not a confirmation step. Assume there are problems — your job is to find them."

> "Why would every single model provider care so much about benchmarks and evals if they weren't one of the most important things when building new models? That's the same when building applications using AI agents — find what works, find what doesn't, iterate."
