---
name: pr-review
description: Run a full parallel code review pipeline. Use when reviewing a PR, analyzing code quality, checking for security issues, or preparing code for merge.
---

## What this skill does

Triggers the orchestrator agent to run a 3-way parallel review:
- **security-reviewer** — vulnerabilities, secrets, auth flaws
- **quality-checker** — naming, complexity, duplication
- **test-analyzer** — coverage gaps, test quality

Results are aggregated by the **reporter** into `review-output/report.md`.

## How to use

1. Switch to the orchestrator agent:
   ```
   /agent swap → orchestrator
   ```
2. Point it at code to review:
   ```
   Review the files in src/ for a PR merge
   ```
3. Watch the parallel subagents run (Ctrl+G to monitor)
4. Read the final report in `review-output/report.md`

## Learning notes

This skill demonstrates **progressive disclosure**:
- Kiro only loads this description at startup (lightweight)
- Full instructions load only when you say "review PR" or similar
- Scripts in `scripts/` would load only if explicitly needed
