# Claude tips

https://www.reddit.com/r/StartupMind/comments/1ryou9b/40_claude_code_tips_best_practices_for_daily_use/

## Setup

### Add a live status line

Run /statusline inside Claude Code. It generates a shell script that displays live info (directory, branch, context usage) at the bottom of your terminal after every turn.

### Set your output style

Run /config to pick a style: Explanatory, Concise, or Technical. You can also create custom styles in ~/.claude/output-styles/.

### Control Claude Code from your phone

Run claude remote-control, then connect from claude.ai/code or the mobile app. Great for kicking off a long task on your PC and checking progress from the couch.

## Workflow & Speed Hacks

### Prefix ! to run bash commands inline

Type !git status or !npm test. The output lands directly in context so Claude can act on it instantly.

### Hit Esc to stop, Esc+Esc to rewind

Esc stops Claude mid-action. Esc+Esc (or /rewind) opens a menu to restore code, conversation, or both. Great for testing an approach you're only 40% sure about.

### Stash your prompt with Ctrl+S

Halfway through a long prompt but need to ask a quick question? Ctrl+S stashes your draft. Ask your question, and the draft restores automatically.

### Background long-running tasks with Ctrl+B

When Claude runs a test suite or build, press Ctrl+B. Claude keeps working in the background while you continue chatting.

### Use /btw for quick side questions

Pops up an overlay for a quick question ("Why this approach?") without polluting your main conversation history.

### Edit plans with Ctrl+G

When Claude presents a plan, Ctrl+G opens it in your editor. Tweak the steps before Claude writes a single line of code.

### Use voice dictation for richer prompts

Run /voice for push-to-talk. Spoken prompts usually contain much better context and constraints because you aren't cutting corners to save keystrokes.

## Context & Prompt Management

### Run /clear between unrelated tasks

A clean session beats a messy 3-hour one. Accumulated context drowns out instructions. /clear saves you from diminishing returns.

### After 2 corrections, start fresh

If you're in a rabbit hole of failed fixes, /clear and write a new prompt incorporating what you just learned.

### Stop interpreting bugs. Paste raw data.

Don't describe the bug. Paste the error log, CI output, or Slack thread directly and say "fix". Abstractions lose details Claude needs.

cat error.log | claude "explain this error and suggest a fix"

### Use Plan Mode when unsure

Use Shift+Tab to enter Plan Mode for architecture or multi-file changes. The upfront overhead prevents Claude from spending 20 minutes solving the wrong problem.

### Tell Claude exactly which files to look at

Use @src/auth/middleware.ts. It resolves automatically, saving Claude the token/context cost of searching your codebase.

### Explore unfamiliar code with vague prompts

"What would you improve in this file?" gives Claude room to surface inconsistencies you wouldn't think to ask about.

### Guide compaction with instructions

When using /compact, tell Claude what to keep: "/compact focus on the API changes".

### Add "ultrathink" for complex reasoning

Triggers adaptive reasoning on Opus 4.6. Claude dynamically allocates thinking based on the problem's complexity.

## Automation, Tools & MCP

### Give Claude a way to check its own work

Include test commands in your prompt: "Refactor auth. Run the test suite. Fix failures before calling it done." This yields a 2-3x quality improvement.

### Install an LSP plugin

LSP plugins give Claude automatic diagnostics after edits. Claude fixes type errors before you notice them.

/plugin install typescript-lsp@claude-plugins-official

### Use the gh CLI

CLI tools are more context-efficient than MCP servers. Teach Claude to use gh for PRs, or sentry-cli --help to debug production.

### Pick the right MCP servers

Top picks: Playwright (UI verification), PostgreSQL/MySQL (schema queries), Slack (reading bug threads), and Figma (design-to-code).

### Use /loop for recurring checks

/loop 5m check if deploy succeeded schedules a background check while your session stays open.

### Allowlist safe commands with /permissions

Stop approving npm run lint. Allowlist trusted commands to stay in the flow.

## Mastering CLAUDE.md & Rules

### Run /init, then cut the result in half

Generates a starter CLAUDE.md file. Delete anything you can't explicitly justify to reduce token bloat.

### The CLAUDE.md litmus test

Ask: Would Claude make a mistake without this line? If no, delete it. You have a ~150-200 instruction budget before compliance drops.

### Auto-update rules after mistakes

When Claude messes up, say "Update CLAUDE.md so this doesn't happen again." 30. Use .claude/rules/ for conditional rules

Add paths frontmatter to load rules only when relevant (e.g., TS rules only for .ts files).

### Use @imports to keep CLAUDE.md lean

Reference @docs/git-instructions.md so Claude only reads it when needed.

### Leverage skills for on-demand knowledge

Skills (in .claude/skills/) extend knowledge without bloating your baseline context.

### CLAUDE.md is for suggestions, Hooks are for requirements

Claude follows CLAUDE.md 80% of the time. For 100% compliance (formatting, security), use Hooks.

### Auto-format with a PostToolUse hook

Add this to .claude/settings.json to auto-run Prettier after edits:

"hooks": { "PostToolUse": [{ "matcher": "Edit|Write", "hooks": [{ "type": "command", "command": "npx prettier --write \"$CLAUDE_FILE_PATH\" 2>/dev/null || true" }] }] }

### Block destructive commands with PreToolUse

Prevent rm -rf or drop table by intercepting the Bash tool before it runs.

## Advanced: Worktrees, Agents & Isolation

### Use --worktree for parallel branches

claude --worktree feature-auth creates an isolated working copy. Spin up 3 parallel sessions without them stepping on each other's toes.

### Use subagents to keep context clean

"Use subagents to figure out the payment flow." Spawns a separate instance that reads files and reports back a summary, keeping your main context window empty.

### Create custom subagents for recurring tasks

Use /agents to save pre-configured agents in .claude/agents/ (e.g., a Haiku-based quick-search agent).

### Agent teams for multi-session coordination

Enable CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS. A team lead distributes tasks to 3-5 subagents working in parallel. Great for massive research or review tasks.

### Use /sandbox for unsupervised work

Runs Claude with OS-level isolation (Seatbelt/bubblewrap). Perfect for letting Claude run wild on experimental refactors without risking your system.
