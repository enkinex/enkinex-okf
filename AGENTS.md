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

- Branch slug: `<type>/<scope>-<short-summary>`; `type` ∈ `feat · fix ·
  refactor · docs · chore · test · infra · proj`.
- Commits: Conventional Commits subset `<type>(<scope>): <imperative ≤72>`,
  `Refs:` footer pointing at the plan section delivered, no `Closes:`/
  `Fixes:`/`Resolves:` (there are no GitHub Issues).
- **Never push, merge, or open PRs unless the user explicitly asks.** The
  iteration ends at a local commit. `gh` CLI is the only GitHub surface
  (ADR-0002): no GitHub MCP, no Actions, no Issues/Projects/Releases.
- Never force-push to `main`; never rewrite history.
- Before any repo edit: `git fetch origin`, confirm sync with `main`,
  create the branch. Commit at the end of the iteration.

### Project lifecycle

Repos plan at the root level: `plan/` (active plans; finished work moves
to `plan/done/`), `discovery/` (analysis feeding plans), `architecture/`
(ADRs). ADRs record one-way decisions only — procedural workflows are
defined as executable artefacts (agents, commands, loop tasks, plugin
hooks), never as ADR prose (ADR-0004, executable governance). Commit
`Refs:` footers point at the delivered `plan/` section.

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
