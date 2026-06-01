---
title: "Components of a Coding Agent"
author: Han Lee
date: 2025
tags:
  - misc
  - coding-agent
  - harness
  - architecture
---

# Components of a Coding Agent

## Summary

- Decomposes a coding agent into its functional components from the perspective of a practitioner building one
- Covers: the model (reasoning core), tools (shell, editor, browser, search), the scaffolding/harness, memory (context + persistent), and the verification layer
- Discusses Letta Code as an example of a harness that post-trains specifically for memory, beating Claude Code on that dimension
- Argues the first-party advantage: models post-trained against specific harness patterns outperform generic frameworks on those patterns

## Key Insights

- **Every component is a design decision.** The choice of model, the tool surface, the scaffolding protocol — each one compounds with the others. Mis-matched components create unexpected failure modes.
- **Letta Code example.** Claude Code is generally stronger for coding tasks because Claude is post-trained against Claude Code's patterns. But Letta Code beats Claude Code on memory-intensive tasks because Letta post-trained specifically for memory management.
- **The harness shapes what the model "knows how to do."** Post-training against harness patterns makes those patterns native behavior, not learned from context.
- **Verification is a first-class component.** Not a nice-to-have. Without external verification signals, coding agents hallucinate working code that fails at runtime.

## Concepts Touched

- [[agent-harness]] — harness as the scaffolding component
- [[closing-the-loop]] — verification as a first-class component
- [[agent-runtime]] — execution environment
- [[inner-outer-loop]] — memory across sessions

## Notable Quotes

> "The first-party advantage is real. Claude is post-trained against Claude Code; that makes Claude Code patterns native behavior, not context learning."
