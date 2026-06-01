---
title: "Stop Babysitting Your Agents"
author: "Sid Boudesaria (Founding Engineer, Claude Code, Anthropic)"
date: 2026-05-26
url: https://www.youtube.com/watch?v=wI0ptqCSL0I
tags:
  - agent-harness
  - verification
  - multi-agent
  - background-loops
  - skills
  - claude-code
  - anthropic
  - ai-agents
sources:
  - "AI Agents/Claude/2026-05-26"
updated: 2026-05-27
---

# Stop Babysitting Your Agents

## Summary

- Advanced Claude Code talk (Code With Claude, May 2026) by one of Claude Code's founding engineers on removing yourself from the agent loop: verification loops, parallel agents, background routines
- Three-part framework: **Verification** (teach Claude to check its own work), **Multi-clodding** (parallelize work effectively without fragmenting attention), **Background loops** (/loop + Routines for tasks that don't need you in the path)
- Core insight: the goal is to get Claude into an **autonomous circuit** where it writes code, checks for failures, debugs, and retries — without you prompting each step
- **Verification skills** should be self-documenting and self-improving: every time Claude hits a blocker, it updates the skill so teammates and future invocations don't hit the same issue
- Table stakes prerequisites: high-quality CLAUDE.md, connected tools (Slack/Linear/Datadog/etc.), remote environment on Claude Code Web

## Key Insights

- **The babysitting problem.** Models are getting smarter, but developers are spending more time watching Claude work, not less. You've become a "glorified QA tester." The goal is to reclaim that attention for higher-leverage work.
- **Human verification = the blueprint for agent verification.** How do humans verify code? Design → build → run → check side effects (browser/logs/DB) → run tests → deploy. Claude follows the same playbook — you just need to give it the tools and instructions to execute each step.
- **The verification loop.** The most important pattern: give Claude access to (1) run the application, (2) drive a browser (Chrome MCP or Playwright), (3) screenshot before/after, (4) state setup scripts. Once in a loop, Claude writes code, detects failures, debugs, and re-runs — hill-climbing to a success state. The PR it produces is higher quality because it's self-validated.
- **Verification is a skill, not a prompt.** Package verification instructions as a SKILL.md. Tell the skill to update itself every time Claude hits a blocker. Result: a self-documenting, self-improving skill that the whole team can contribute to — the Claude Code team uses exactly this pattern internally.
- **Attention is the real scaling constraint.** More than 4–5 parallel Claude sessions and the cognitive load becomes unmanageable. The real bottleneck isn't compute; it's human attention.
- **Claude Agents view (terminal).** Run `claude agents` (not `claude`) to see all sessions across surfaces, sorted by attention requirement — sessions needing input appear at the top. Replaces TMux + work trees as the daily multi-agent management interface.
- **/loop = crontool.** The `/loop` command runs a prompt at a fixed interval. The internal name is `crontool`; `/loop` is the user-facing alias. Claude wakes up on schedule and runs the prompt — no keyboard required. Ideal for: babysitting PRs, updating docs, triaging feedback, keeping CI green.
- **Routines = /loop but remote.** Routines live in Claude Code Web containers. Time-based or event-based triggers. The Claude Code team uses routines to: update docs daily, post issue/feedback summaries to Slack every 6 hours. Removes you entirely from the scheduling path.
- **Remote control for 30-second check-ins.** `/remote-control` in any session → sessions appear on your phone. When Claude needs input, you get a notification. Check in from anywhere — walking between meetings, in your car — without opening a laptop.
- **Auto Mode as the permission layer.** Auto Mode (not dangerously-skip-permissions) uses a classifier agent and an adversarial checker to approve tool calls. Overhead: ~30–40% token cost. This is what makes /loop, Routines, and overnight work viable without constant permission prompts.

## Concepts Touched

- [[concepts/agent-skills]] — verification skills as self-improving SKILL.md; packaging verification into distributable skills
- [[concepts/closing-the-loop]] — the verification loop as Claude's self-check mechanism; hill-climbing to success state
- [[concepts/inner-outer-loop]] — /loop and Routines as automated outer loop; background loops removing human from the path
- [[concepts/agent-harness]] — remote environment decoupling; Auto Mode as trust infrastructure; Claude Agents view
- [[concepts/context-engineering]] — Claude.md quality as the highest-leverage context investment

## Notable Quotes

> "We're increasingly spending a larger percentage of our time staring at the screen, waiting for Claude to finish its work, or just acting as a glorified QA tester. This can be quite unsatisfying and an inefficient use of your time."

> "A loop essentially is an autonomous circuit that you can complete for Claude. It allows Claude to hill climb on a given task or a given success criteria."

> "The most important thing to take away: wherever possible, our goal now is to get Claude into a loop by giving it the tools and instructions required for it to work effectively."

> "You can make [the verification skill] self-improving. If you put in instructions about improving the skill every time Claude hits a blocker, you end up creating a self-documenting, self-improving skill which everyone on your team can contribute to."

> "/loop is a way to run a prompt at a specific interval in Claude Code. Internally the name for the tool is crontool, and /loop is just a text command that tells Claude to use crontool."

> "Babysitting PRs with /loop — super, super useful. Once it gets to CI, even if your CI takes two hours to run, you can just leave it for the next day and it will fix all of the CI bugs. It has really been a game changer."
