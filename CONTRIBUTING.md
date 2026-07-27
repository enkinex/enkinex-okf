# Contributing to Enkinex OKF

Thank you for your interest in contributing to **Enkinex OKF**, the modular
[KCL](https://www.kcl-lang.io/) implementation of the
[Open Knowledge Format (OKF) v0.2](https://github.com/GoogleCloudPlatform/knowledge-catalog/tree/main/okf).
This guide covers everything you need to build, validate, and submit changes.

## Prerequisites

- [KCL](https://www.kcl-lang.io/docs/user_docs/getting-started/install) `>= 0.12.4`
- [`just`](https://github.com/casey/just), the command runner used to wrap
  every development task in this repo

Check both are on your `PATH`:

```bash
kcl --version
just --version
```

## Getting started

```bash
git clone git@github.com:enkinex/enkinex-okf.git
cd enkinex-okf
just init      # kcl mod update
just check     # fmt + lint + test, the same gate CI/reviewers expect
```

Run `just` with no arguments at any point to list every available task.

## Development workflow

All day-to-day tasks are `just` recipes defined in the [`Justfile`](Justfile):

| Command      | What it does                                                                 |
|--------------|-------------------------------------------------------------------------------|
| `just init`  | Syncs module dependencies (`kcl mod update`).                                 |
| `just fmt`   | Formats every `.k` file in the project (`kcl fmt ./...`).                     |
| `just lint`  | Runs `kcl lint` against the root package and every module directory.          |
| `just test`  | Validates every fixture under [`test/`](test) with `kcl vet` against the schema its filename prefix names, runs the `kcl test` unit tests, then confirms every `invalid-*` fixture is rejected and the permissive/typed profile boundary holds. |
| `just docs`  | Regenerates the auto-generated schema reference from schema docstrings.       |
| `just check` | Aggregate gate: formats, verifies the tree is still clean (`git diff --exit-code`), regenerates docs and verifies those are clean too, then runs `lint` and `test`. Run this before opening a PR. |

Before pushing, always run:

```bash
just fmt
just check
```

`just check` re-runs `kcl fmt` and fails if it changes anything you haven't
committed — so always run `just fmt` and commit the result first, rather than
letting `check` catch it for you.

## Branch and commit conventions

Commit messages in this repo follow a **Conventional Commits** subset. Use
one of these prefixes based on what the commit actually changes:

- `feat:` — a new schema, field, or capability
- `fix:` — a correctness fix (typing, constraints, validation behavior)
- `docs:` — documentation-only changes (README, schema docs, docstrings)
- `test:` — adding or updating `test/` fixtures
- `refactor:` — restructuring without behavior change
- `chore:` — tooling, dependency, or repo-scaffolding changes

Keep the subject line short and imperative (e.g. `fix: reject invalid status
values`), matching the existing `git log`.

Branch names follow `<type>/<short-slug>`, using the same prefixes as above,
e.g. `feat/computation-receipt-schema` or `chore/contributor-tooling`.

## Pull request process

1. Fork the repo (or branch directly if you're a collaborator) and open your
   PR against `main`.
2. Fill in the [PR template](.github/PULL_REQUEST_TEMPLATE.md) — in
   particular the **Testing** section: paste the output of `just check`.
3. Make sure CI (or your local `just check`) is green before requesting
   review.
4. A maintainer listed in [`.github/CODEOWNERS`](.github/CODEOWNERS) will
   review; address feedback with follow-up commits rather than force-pushes
   once a review is in progress, unless asked otherwise.
5. PRs are squash-merged, so the PR title should itself read as a good
   commit message.

## Where to add a new schema

The library is organized as one KCL module per OKF frontmatter family (see
the root `README.md` for the full rationale behind each module). If you're
adding a new field or schema, find its home in this table:

| Module        | Owns                                                                          |
|-----------------|----------------------------------------------------------------------------|
| `common`         | `actorKind`, and the shared `datePattern`/`dateTimePattern` regex constants |
| `provenance`     | `Source`, `UsageWindow`                                                    |
| `trust`          | `Generated`, `VerificationEvent`, `VerifiedType`, `deriveTrustTier`         |
| `lifecycle`      | `StatusType`, `effectiveStatus`, `isStale`                                 |
| `document`       | `Frontmatter` (permissive) and `ConceptMetadata` (typed), `RootIndexMetadata` |
| `computation`    | `Parameter`, `Executor`, `Attester`, `AttestedComputationMetadata`          |
| `okf.k` (root)   | The root `Concept` schema that composes `document.ConceptMetadata`         |

Add a fixture under [`test/`](test) that exercises any new or changed field —
extend `concept-full-standard.okf.yaml` or add a new `<scope>-*.okf.yaml`
file named after the schema it validates against — and run `just test` to
confirm it validates. If the change affects a derivation helper
(`effectiveStatus`, `isStale`, `normalizeVerified`, `deriveTrustTier`,
`actorKind`), add or update the matching `test/*_test.k` unit test.

If you add or change a `check:` rule, also add an `invalid-<scope>-*.okf.yaml`
fixture that exercises it — `just test-negative` fails if any such fixture
unexpectedly validates, so a new rule with no matching fixture is an easy
regression to introduce silently.

## Docstrings and generated docs

Every schema and field should carry a docstring — it's the source of the
generated schema reference and the primary way contributors discover the
API. When you add or change a docstring:

1. Run `just docs` to regenerate the schema reference.
2. Include the regenerated file in your PR. `just check` fails the build if
   it's stale.
3. If your change affects the architectural rationale for a module, also
   update the corresponding file under [`docs/schemas/`](docs/schemas).

Type aliases (`ActorKindType`, `TrustTierType`, `StatusType`, `VerifiedType`)
and derivation lambdas (`actorKind`, `effectiveStatus`, `isStale`,
`normalizeVerified`, `deriveTrustTier`) aren't schemas, so `kcl doc generate`
doesn't pick them up. They're documented by hand in
[`docs/library/helpers.md`](docs/library/helpers.md) instead — update it
whenever you add, remove, or change the signature or semantics of one.

## Code of conduct and security

- This project follows the [Code of Conduct](CODE_OF_CONDUCT.md).
- To report a security vulnerability, see [`SECURITY.md`](SECURITY.md) —
  please do not open a public issue for security reports.

## Other references

- [`AUTHORS.md`](AUTHORS.md) — contributor list.
- [`CHANGELOG.md`](CHANGELOG.md) — notable changes per release.
- [`history.md`](history.md) — which upstream OKF version this library tracks.
- [`spec.md`](spec.md) — the vendored upstream specification this library implements.
