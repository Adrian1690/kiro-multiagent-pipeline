# Contributing

This project is a learning resource for Kiro CLI. The best way to contribute is to **complete the challenge below using Kiro itself** — no manual git commands needed.

---

## 🏆 The Hook Challenge

The `.kiro/hooks/audit-log.sh` script exists but is never triggered. Your mission: fix it.

**What broken looks like**: Running the orchestrator produces no `.kiro/audit.log` file.

**What fixed looks like**: After running the orchestrator, `.kiro/audit.log` exists and contains timestamped tool call entries.

### Rules
1. Fix must wire the hook inside an agent JSON config (that's the only way hooks work)
2. The script in `.kiro/hooks/audit-log.sh` must be called from the hook command (don't inline everything)
3. Submit your PR using the orchestrator agent — not manually

---

## Submitting your PR with Kiro

After fixing the hook:

```bash
cd kiro-multiagent-pipeline
kiro-cli --agent orchestrator
```

Then tell the orchestrator:
```
Fork Adrian1690/kiro-multiagent-pipeline, create a branch called fix/hooks-<your-github-username>,
commit my changes to .kiro/agents/ and .kiro/hooks/, and open a PR with title
"fix: wire audit-log hook into agent config" and a description explaining what was wrong and how I fixed it.
```

The orchestrator will use the `shell` tool to run `gh` commands and create the PR for you.

> **Tip**: Make sure you have `gh` installed and authenticated (`gh auth login`) before running this.

---

## Other contributions

Beyond the hook challenge, PRs are welcome for:
- New agents (e.g. a `dependency-checker` or `docs-writer` subagent)
- New skills in `.kiro/skills/`
- Improvements to the README learning path
- Additional `src/` demo files with interesting issues for agents to find

Same process: use the orchestrator to create the PR.
