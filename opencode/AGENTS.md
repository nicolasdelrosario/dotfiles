<!-- CODEGRAPH_START -->
## CodeGraph

In repositories indexed by CodeGraph (a `.codegraph/` directory exists at the repo root), reach for it BEFORE grep/find or reading files when you need to understand or locate code:

- **MCP tool (when available):** `codegraph_explore` answers most code questions in one call — the relevant symbols' verbatim source plus the call paths between them, including dynamic-dispatch hops grep can't follow. Name a file or symbol in the query to read its current line-numbered source. If it's listed but deferred, load it by name via tool search.
- **Shell (always works):** `codegraph explore "<symbol names or question>"` prints the same output.

If there is no `.codegraph/` directory, skip CodeGraph entirely — indexing is the user's decision.
<!-- CODEGRAPH_END -->

<!-- MODEL_ROUTER_START -->
## Model Routing

The `opencode-model-router` plugin automatically routes tasks to the appropriate model tier.

### Active Configuration
- **Mode:** budget (Big Pickle first, escalates only when needed)
- **Preset:** luna-terra

### Tiers
| Tier | Model | Use Case | Cost |
|------|-------|----------|------|
| `@fast` | Big Pickle | Exploration, grep, reads, simple lookups | Free |
| `@medium` | Luna | Implementation, refactoring, tests, bug fixes | $1/$6 |
| `@heavy` | Terra | Architecture, complex debug, security, perf | $2.50/$15 |

### Budget Mode Rules
- Default to `@fast` for everything unless edits/complex-reasoning needed
- `@medium` ONLY: multi-file edits, refactoring, test suites, build fixes
- `@heavy` ONLY: user-requested OR after 2+ `@medium` failures
- Trivial tasks (grep, glob, read): execute directly, no delegation
- Batch related searches into single `@fast` dispatch
- When uncertain `@fast` vs `@medium`: try `@fast`, escalate on failure

### Commands
- `/budget <mode>` — switch routing mode (budget/normal/quality/deep)
- `/preset <name>` — switch provider preset
- `/tiers` — show current tier configuration
- `/routing` — show routing status and enforcement mode

### Fallback
- `fast` currently uses only Big Pickle. The installed router version does not rotate between models after rate limits.
- Do not include Nemotron 3 Ultra Free; it is currently overloaded.
- If Big Pickle is unavailable, switch the fast tier manually before starting the next task, or use Luna for work that cannot wait.
<!-- MODEL_ROUTER_END -->

## Portable Setup

- Keep Ponytail minimal, standard-library-first, and free of speculative abstractions.
- Use Engram for persistent project memory; never store private state in this repository.
- `rtk`, `engram`, and `codegraph` resolve through `PATH`, not machine paths.
- Local plugins are explicitly listed in `opencode.jsonc`; do not remove them unless the behavior is intentionally replaced.
- The optional Sleeve gateway uses `SLEEVE_GATEWAY_URL`, which must be configured locally and is never committed.
