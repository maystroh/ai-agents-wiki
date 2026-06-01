---
title: "The Prompting Playbook"
author: "Margot Vanlar (Anthropic Applied AI)"
date: 2026-05-22
url: https://www.youtube.com/watch?v=G2B0YWuJUgI
tags:
  - prompting
  - evals
  - prompt-engineering
  - output-contracts
  - xml-structure
  - anthropic
  - agent-engineering
sources:
  - "Prompt Engineering/Claude/2026-05-22"
updated: 2026-05-24
---

# The Prompting Playbook

## Summary

- Margot Vanlar (Anthropic Applied AI engineer) presents an eval-driven approach to prompt development — never write prompts without a test suite running against them
- Three eval case types: control cases (known correct behavior), edge cases (boundary conditions), capability boundaries (what the model explicitly cannot do)
- Prompt hygiene: use XML structure to separate role, guidelines, policy, and tone — if you can't tell them apart, the model can't either
- Output contracts: specify exact output format using XML tags plus stop sequences — turns parsing from guesswork into determinism
- Harness-level fixes vs prompt-level fixes: a class of failures belongs at the infrastructure layer, not in the system prompt

## Key Insights

- **Evals first, prompts second.** Before writing a system prompt, define what correct behavior looks like across at least 10 cases. Without this, prompt iteration is guesswork. The eval suite is the ground truth that guides every edit.
- **Three eval types cover the space.** Control cases (what should always work), edge cases (boundary conditions that often fail), and capability boundaries (explicit refusals or limitations the system must enforce). Missing any one category creates blind spots.
- **XML structure is prompt hygiene.** When a system prompt mixes role ("you are a helpful assistant"), guidelines ("be concise"), policy ("never discuss competitors"), and tone ("use formal language"), the model can't cleanly separate them. XML tags make structure explicit: `<role>`, `<guidelines>`, `<policy>`, `<tone>`. The model infers structure from XML better than prose.
- **"If you can't tell guidelines from policy, the model can't either."** This is the core insight. Guidelines are preferences; policies are constraints. Mixing them causes the model to treat hard constraints as soft preferences, or vice versa. Structural separation forces the author to make the distinction explicit.
- **Output contracts = XML tags + stop sequences.** Specify the exact output format (e.g., `<answer>...</answer>`) and a stop sequence that terminates output at the closing tag. This makes output parsing deterministic — no regex heuristics, no substring search, no hallucinated JSON keys.
- **Harness-level vs prompt-level failures.** Some failures are not fixable with better prompts — they require changes to context assembly, tool routing, or retrieval. Identifying which layer owns a failure is a core skill. Trying to patch harness failures with prompt additions creates prompt bloat and masks root causes.

## Concepts Touched

- [[concepts/context-engineering]] — XML structure and prompt hygiene as context management
- [[concepts/agent-engineering]] — eval-driven development as the mindset shift
- [[concepts/agent-harness]] — harness-level vs prompt-level failure classification
- [[concepts/closing-the-loop]] — eval suites as the verification mechanism for prompt quality

## Notable Quotes

> "If you can't tell your guidelines from your policy, the model can't either. Structure it in XML."

> "Before you write a prompt, write the evals. Otherwise you're guessing."

> "Output contracts: XML tags plus stop sequences. Now your parser is deterministic."

> "A class of failures belongs at the harness level, not in the system prompt. Know which layer owns the problem."

> "Three eval types: control cases, edge cases, and capability boundaries. If you're missing any of these, you have blind spots."
