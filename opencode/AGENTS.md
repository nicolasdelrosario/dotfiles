<!-- CODEGRAPH_START -->
## CodeGraph

In repositories indexed by CodeGraph (a `.codegraph/` directory exists at the repo root), reach for it BEFORE grep/find or reading files when you need to understand or locate code:

- **MCP tool (when available):** `codegraph_explore` answers most code questions in one call — the relevant symbols' verbatim source plus the call paths between them and a blast-radius summary.
- **Shell (always works):** `codegraph explore "<symbol names or question>"` prints the same output.

If there is no `.codegraph/` directory, skip CodeGraph entirely — indexing is the user's decision; do not run it yourself.
<!-- CODEGRAPH_END -->

## Native Agents

Luna (`openai/gpt-5.6-luna`) is the primary orchestrator. Native OpenCode
subagents live in `agents/` and use the cheapest adequate model:

- `explorer` and `reviewer` use free `opencode/deepseek-v4-flash-free` and are read-only.
- `implementer` uses Luna for edits, tests, and bug fixes.
- `architect` uses Terra only for difficult architecture, security, performance,
  or debugging work.

Subagents do not delegate further. Keep tasks narrow and provide explicit file
paths and verification commands when invoking them.

## Portable Setup

- Keep Ponytail minimal, standard-library-first, and free of speculative abstractions.
- Use Engram for persistent project memory; never store private state in this repository.
- `rtk`, `engram`, and `codegraph` resolve through `PATH`, not machine paths.
- Use Context7 to verify current library, API, and service documentation before implementing dependent changes.
- Local plugins are explicitly listed in `opencode.jsonc`; do not remove them unless the behavior is intentionally replaced.

## OpenCode Operating Contract

- Luna (`openai/gpt-5.6-luna`) is the primary orchestrator. Do not use Terra
  unless the task needs difficult architecture, security, performance, or
  debugging analysis.
- Delegate codebase discovery to `explorer`, change review to `reviewer`, and
  edits/tests to `implementer`. Use explicit file paths and verification
  commands. Subagents must not delegate further.
- `explorer`, `reviewer`, and `architect` are read-only. `implementer` may edit
  and run tests but has `task: deny`.
- The active plugins are Ponytail, Engram, and RTK. Ponytail provides the
  `ponytail` mode and skills; Engram provides persistent memory; RTK rewrites
  shell commands through `rtk rewrite` in `tool.execute.before`.
- CodeGraph provides local symbol and call-graph exploration when a repository
  has a `.codegraph/` index; otherwise use normal repository exploration.
- Context7 provides current documentation for libraries, APIs, and services.
- The repository is the source of truth for plugin files. Run `npm ci` in
  `opencode/`, not only in `~/.config/opencode/`, because deployed plugin files
  resolve dependencies from their real path in this repository.
- RTK is an external binary. Install it with the official installer, ensure
  `~/.local/bin` is in `PATH`, then run `rtk init --global --opencode`.
- Validate the stack with `rtk init --show`, `rtk --version`, `opencode agent
  list`, and an import/hook check for Ponytail before declaring setup complete.
- Never commit `node_modules`, credentials, API keys, Engram databases, runtime
  state, or machine-specific gateway URLs. Restart OpenCode after plugin or
  configuration changes.
