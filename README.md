# kiro-multiagent-pipeline

A hands-on project to learn every major Kiro CLI feature, with a focus on **custom agents** and **parallel subagents**.

```
         ┌──────────────────────────────────┐
         │         orchestrator             │
         └──────┬──────────┬───────┬────────┘
                │          │       │
         ┌──────▼──┐ ┌─────▼──┐ ┌─▼───────┐   ← parallel
         │security │ │quality │ │  tests  │
         │reviewer │ │checker │ │analyzer │
         └──────┬──┘ └─────┬──┘ └─┬───────┘
                └──────────┴───────┘
                           │
                    ┌──────▼──────┐             ← sequential
                    │  reporter   │
                    └─────────────┘
```

---

## Project structure

```
.kiro/
├── agents/
│   ├── orchestrator.json       ← spawns subagents in parallel
│   ├── security-reviewer.json  ← subagent: finds vulnerabilities
│   ├── quality-checker.json    ← subagent: reviews code quality
│   ├── test-analyzer.json      ← subagent: checks test coverage
│   └── reporter.json           ← subagent: writes final report
├── skills/
│   └── pr-review/
│       └── SKILL.md            ← auto-activates on "review PR"
├── steering/
│   └── code-standards.md       ← auto-loads for *.ts files
└── hooks/
    └── audit-log.sh            ← logs every tool call
```

---

## Learning Path

Work through these stages in order. Each one builds on the last.

---

### Stage 1 — Meet Kiro CLI (15 min)

**Goal**: Understand the default agent and basic chat.

```bash
cd kiro-multiagent-pipeline
kiro-cli
```

Try these prompts:
- `What files are in this project?`
- `What is .kiro/agents/ for?`
- `/help`

**What you learn**: How the default agent works, tool calls, permission prompts.

---

### Stage 2 — Skills (20 min)

**Goal**: Understand progressive disclosure and skill activation.

```bash
kiro-cli
> review this PR
```

Watch Kiro auto-activate the `pr-review` skill because your prompt matched its description.

Then invoke it explicitly:
```
> /pr-review
```

**Experiment**: Edit `.kiro/skills/pr-review/SKILL.md` — change the `description` field to something unrelated. Notice the skill no longer auto-activates.

**What you learn**: Skills load lazily. The `description` is the activation trigger, not the name.

---

### Stage 3 — Steering (20 min)

**Goal**: Understand how Kiro gets persistent context about your project.

Create a TypeScript file:
```bash
mkdir src && echo "const x = 1" > src/example.ts
```

Start a chat and ask Kiro to improve the file:
```bash
kiro-cli
> improve src/example.ts
```

Notice Kiro automatically applies the rules from `.kiro/steering/code-standards.md` because the file matches `**/*.ts`.

**Experiment**: Change `inclusion: fileMatch` to `inclusion: always` in `code-standards.md`. Now the standards apply to every file, not just TypeScript.

**What you learn**: Steering inclusion modes — `always`, `fileMatch`, `auto`, `manual`.

---

### Stage 4 — Custom Agents (30 min)

**Goal**: Understand agent configs, tool restrictions, and context loading.

Start a session with a specific agent:
```bash
kiro-cli --agent security-reviewer
```

Ask it to review a file:
```
> Review src/example.ts for security issues
```

Notice it can only use `read` and `code` tools (no `shell`, no `write`). That's `allowedTools` in action.

**Experiment 1**: Add `"write"` to `allowedTools` in `security-reviewer.json`. Restart and ask it to fix an issue. Now it can write files.

**Experiment 2**: Create your own agent:
```
/agent create my-agent -D "My custom workflow agent"
```

**What you learn**: Agent JSON config, `tools` vs `allowedTools`, `prompt`, `model`, `resources`.

---

### Stage 5 — Parallel Subagents (45 min) ⭐ The main event

**Goal**: Run a real parallel multi-agent pipeline and understand DAG execution.

```bash
kiro-cli --agent orchestrator
```

Ask it to review code:
```
> Review all files in src/ for a PR merge
```

**Immediately press Ctrl+G** to open the subagent monitor. You'll see:
- `security-reviewer`, `quality-checker`, and `test-analyzer` all start simultaneously
- Each has its own context and tool calls
- `reporter` only starts after all three finish

Use `Ctrl+D` / `Ctrl+U` to switch between subagent views. Press `q` to return to chat.

**Experiment 1**: In `orchestrator.json`, remove `"test-analyzer"` from `trustedAgents`. Restart and run again — now Kiro asks for your approval before spawning that subagent.

**Experiment 2**: Ask the orchestrator to do a sequential workflow:
```
> Analyze dependencies in src/, then refactor based on findings, then run tests
```
Watch the DAG change from parallel to sequential.

**What you learn**: Subagent DAG, `trustedAgents`, `availableAgents`, `agentPermissions`, the execution monitor.

---

### Stage 6 — Hooks (20 min) 🏆 Community Challenge

**Goal**: Fix the intentionally broken hook — and submit your fix as a PR using the orchestrator agent itself.

The project ships with `.kiro/hooks/audit-log.sh` — but **it doesn't work**. Hooks must be declared as a `"hooks"` field inside the agent JSON config. The script alone does nothing.

**Your challenge**: Wire the hook so `.kiro/audit.log` actually gets written when the orchestrator runs.

Hints:
- Hooks live inside the agent `.json` under a `"hooks"` key
- Each hook entry needs a `command` string (it can call your shell script)
- `postToolUse` hooks receive tool data via STDIN as JSON
- Use `matcher` to target specific tools (e.g. `"fs_write"`, `"execute_bash"`)
- Exit code `2` on `preToolUse` blocks the tool call

**Once you fix it, submit a PR using the orchestrator:**
```bash
kiro-cli --agent orchestrator
> I fixed the hooks. Create a PR to Adrian1690/kiro-multiagent-pipeline with my changes.
```

See [CONTRIBUTING.md](./CONTRIBUTING.md) for the full challenge rules.

**What you learn**: Hooks live in agent JSON (not as standalone files), hook types (AgentSpawn, PreToolUse, PostToolUse, Stop), exit codes, STDIN JSON format — and how to use Kiro to submit the PR that proves you learned it.

---

### Stage 7 — Headless / CI (15 min)

**Goal**: Run Kiro non-interactively in a script or CI pipeline.

```bash
echo "Review src/example.ts and output findings to stdout" | kiro-cli --agent security-reviewer --no-interactive
```

**What you learn**: Headless mode, API key auth for CI/CD, automation patterns.

---

## Key concepts cheat sheet

| Concept | File location | Activation |
|---------|--------------|------------|
| Skill | `.kiro/skills/<name>/SKILL.md` | Auto (description match) or `/skill-name` |
| Steering | `.kiro/steering/*.md` | `always` / `fileMatch` / `auto` / `manual` |
| Agent | `.kiro/agents/*.json` | `kiro-cli --agent <name>` or `/agent swap` |
| Subagent | Spawned by parent agent | Parent calls `subagent` tool |
| Hook | `.kiro/hooks/*.sh` + agent config | Lifecycle events (AgentSpawn, PreToolUse, etc.) |

## Docs reference

- Skills: https://kiro.dev/docs/skills/
- Steering: https://kiro.dev/docs/steering/
- Custom Agents: https://kiro.dev/docs/cli/custom-agents/
- Subagents: https://kiro.dev/docs/cli/chat/subagents/
- Hooks: https://kiro.dev/docs/cli/hooks/
