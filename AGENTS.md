# enkinex-okf

KCL library implementing **Google's Open Knowledge Format (OKF) v0.2** as
Governance-as-Code — the knowledge surface of the enkinex family, alongside
enkinex-odcs (contracts) and enkinex-odps (products). Currently
**`v0.2-draft`**: it types the OKF *frontmatter* families only.

The upstream spec is vendored verbatim at [`spec.md`](spec.md), pinned to
commit `3fcbb9f` of
[GoogleCloudPlatform/knowledge-catalog](https://github.com/GoogleCloudPlatform/knowledge-catalog/tree/main/okf).
Upstream ships no validator and no JSON Schema — this library is the
validation surface.

## Repo map

| Path | Purpose |
|---|---|
| `okf.k` | Root `Concept` schema — the typed producer profile |
| `document/` | `ConceptMetadata` (typed), `Frontmatter` (permissive consumer profile), `RootIndexMetadata` |
| `provenance/` `trust/` `lifecycle/` `computation/` | One module per OKF frontmatter family |
| `common/` | Actor convention and date/datetime patterns |
| `test/*.okf.yaml` | `kcl vet` fixtures — `concept-*`/`attested-*` must validate, `invalid-*` must be rejected |
| `test/*_test.k` | KCL unit tests for the derivation helpers |
| `spec.md` | Vendored upstream OKF v0.2 specification (do not edit) |
| `docs/library/okf.md` | Generated schema reference (`just docs`) — regenerate on docstring change |
| `docs/schemas/` | Per-module design rationale |

## Commands

`just init` · `just fmt` · `just lint` · `just test` · `just docs` ·
**`just check` — the gate every change must pass** (fmt + clean-tree + docs
freshness + lint + test, including the negative and profile suites).

## Standards

- **Two profiles, never one.** `Frontmatter` is permissive (`type` only) for
  consuming arbitrary OKF; `Concept` is typed for producing. OKF §11 requires
  consumers to tolerate unknown types, unknown keys and broken links — keep
  `[str]: any` on every schema.
- **Derivations are pure lambdas, never defaults.** `effectiveStatus`,
  `isStale`, `deriveTrustTier` and `normalizeVerified` compute read-time
  semantics. Materialising them into producer output would change every
  document's meaning.
- Every new/changed field gets both a positive and a negative fixture.
- Docstrings on every schema and field (they feed `just docs`); `check` rules
  only where the spec states a hard constraint.
- **A field whose OKF name is a KCL keyword is escaped with `$` in code, never
  in docstrings.** `type` is the case in the library today: declare it `$type`
  and reference it as `$type` in `check:` blocks, test config keys, and KCL
  snippets in docs. The `$` is not part of the name — YAML fixtures and the
  generated reference keep the plain `type`. See CONTRIBUTING.md for the full
  reserved-word list.
- Track one upstream version at a time; a spec bump is its own change, with
  `spec.md` re-vendored at a new pinned commit.

<!-- BEGIN GENERATED: enkinex-aiops/AGENTS.shared.md — do not edit here; run "just sync-opencode" in enkinex-aiops -->
## Shared enkinex rules

> GENERATED from enkinex-aiops `AGENTS.shared.md` (ADR-0005). Do not edit
> this block in a sibling repo — change the source in enkinex-aiops and run
> `just sync-opencode`.

Enkinex is an open-source **Semantic & Governance as Code** project: KCL
libraries that implement open standards (ODCS, ODPS, OKF) and platform
configuration surfaces (Databricks Asset Bundles) as typed, modular code.

### Git workflow (locked)

- Branch slug: `<type>/<short-slug>`; `type` ∈ `feat · fix · refactor ·
  docs · chore · test · infra · proj`; slug kebab-case, ≤6 words,
  imperative (e.g. `feat/output-port-retry-policy`).
- Commits: Conventional Commits subset `<type>: <imperative ≤72>`,
  `Refs:` footer pointing at the plan section delivered, no `Closes:`/
  `Fixes:`/`Resolves:` (there are no GitHub Issues).
- **No repo-name scope.** A scope is optional and names a *module inside
  this repo* (`catalog`, `quality`, `trust`, `githooks`), never the repo
  itself: `feat(odcs):` inside enkinex-odcs says nothing the repository
  does not already say. Package-name scopes are a monorepo device; these
  are separate repos. The `commit-msg` hook rejects a redundant scope.
- **Never push, merge, or open PRs unless the user explicitly asks.** The
  iteration ends at a local commit. `gh` CLI is the only GitHub surface
  (ADR-0002): no GitHub MCP, no Actions, no Issues/Projects/Releases.
- Never force-push to `main`; never rewrite history.
- Before any repo edit: `git fetch origin`, confirm sync with `main`,
  create the branch. Commit at the end of the iteration.

### Mechanical enforcement

The rules above are enforced by git hooks in `.githooks/`, not by your
compliance: `commit-msg` checks the subject grammar and the `Refs:` footer,
`pre-commit` checks the enkinex remote and scans staged content for
credentials, `pre-push` checks the branch slug and refuses direct pushes to
`main` and history rewrites.

A second layer, `.agents/policy/guard.mjs`, covers what git hooks cannot see:
hook bypasses (`--no-verify`, `core.hooksPath` edits), `git add -A`, `gh pr
merge`, and reads of credential paths. One script; opencode, Claude Code and
Codex each call it through a pointer-only adapter.

- **Never pass `--no-verify`.** If a hook refuses, fix the cause.
- Stage explicit paths. `git add -A`, `git add .` and `git add -u` are denied.
- Hooks are inert until a clone is pointed at them. If
  `git config --get core.hooksPath` is empty, run
  `git config core.hooksPath .githooks` before committing.
- Unattended runs use the headless profile (`opencode.headless.json`), where
  push, rebase, PR creation and PR merge are denied outright rather than
  prompted. Launch through `scripts/opencode-headless.sh` in enkinex-aiops.

### Project lifecycle

**Planning is centralised and private.** Plans live in the sibling
`enkinex-pm`, one folder per repository — `../enkinex-pm/plan/<repo>/`
from a repo checkout — as small numbered task files. **A repo with no
local `plan/` is correct, not misconfigured**; do not create one, and do
not plan in the repo you are editing.

There is no `discovery/` stage. Analysis feeding a plan is an input to
planning and belongs in `enkinex-pm`, not beside the code.

`architecture/` stays at each repo root. ADRs record one-way decisions
only — procedural workflows are defined as executable artefacts (agents,
commands, loop tasks, plugin hooks), never as ADR prose (ADR-0004,
executable governance). A repo's ADRs are public with its code, so an ADR
citing a plan cites something the reader may not be able to open: say so
at the citation rather than leaving a path that resolves for nobody.

Commit `Refs:` footers point at the plan the commit delivers, which now
resolves only for someone holding the `enkinex-pm` clone — a cost this
org has accepted deliberately. Use `No-Plan-Ref:` when a commit advances
no plan; `commit-msg` accepts it and it is the correct footer, not a
bypass.

### Model tiers (OpenRouter)

| Tier | Models | Use |
|---|---|---|
| Free | `:free` suffixed IDs | explore/triage, formatting, titles |
| Mid | `moonshotai/kimi-k2`, `deepseek/deepseek-v3.2`, `google/gemini-3.5-flash` | code edits, docs, tests |
| Frontier | `moonshotai/kimi-k3` (default), `anthropic/claude-opus-5`, `openai/gpt-5.6` family | plans, reviews, ADRs |

Do not switch tiers silently; model pins change only via PR.

### Code standards

- KCL libraries: one module per concern, docstrings on every schema and
  field (they feed `just docs`), `check` rules for enums/constraints,
  `kcl vet` fixtures under `test/`. Gate: `just check` (fmt + lint + test).
- Stage explicit paths only — never `git add -A` / `git add .`; skip
  anything that looks like a secret.
<!-- END GENERATED -->
