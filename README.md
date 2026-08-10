[![Enkinex — Semantic & Governance as Code](docs/images/enkinex-github-banner.png)](https://enkinex.org)

# Enkinex OKF — Open Knowledge Format (OKF) as Code Library

[![Standard](https://img.shields.io/badge/OKF-v0.2-blue)](https://github.com/GoogleCloudPlatform/knowledge-catalog/tree/main/okf)
[![KCL](https://img.shields.io/badge/KCL-%E2%89%A5%200.12.4-7B68EE)](https://www.kcl-lang.io/)
[![Version](https://img.shields.io/badge/version-v0.2--draft-orange)](./CHANGELOG.md)
[![License](https://img.shields.io/badge/license-Apache--2.0-green)](./LICENSE)

> A modular [KCL](https://www.kcl-lang.io/) implementation of the
> [Open Knowledge Format (OKF) v0.2](https://github.com/GoogleCloudPlatform/knowledge-catalog/tree/main/okf),
> built to author, type-check, and validate knowledge bundle frontmatter as
> **Governance-as-Code**.

## Project Summary

OKF is an open, human- and agent-friendly format for representing knowledge — the metadata, context, and curated
insight that surrounds data and systems — as a directory of markdown files with YAML frontmatter. It is not tied to
any particular agent, framework, model provider, or serving system: if you can `cat` a file, you can read OKF; if
you can `git clone` a repo, you can ship it.

A knowledge corpus, however, is rarely authored once and then read. Increasingly, it is **continuously written and
maintained by agents**, across many concepts, many producers, and many organizations. When most concepts are
machine-generated, a consumer needs answers a plain markdown-plus-frontmatter convention does not make first-class:
what a concept was created from and how it was verified (**provenance** and **trust**), whether it is still true
(**freshness**), whether it is the current version (**lifecycle**), and whether a number was produced the way it was
said it must be (**attestation**). OKF v0.2 standardizes exactly the small set of frontmatter fields that make these
questions answerable, without prescribing any runtime.

**Enkinex OKF** complements the standard by expressing it as a modular KCL schema library. It defines an engineering
layer on top of OKF that keeps the format intact while adding code-level ergonomics:

- **Modularity & reuse**: one KCL package per frontmatter family (provenance, trust, lifecycle, computation) instead
  of hand-copied YAML shapes across every concept type an organization defines.
- **Two profiles, not one**: a permissive schema for consuming arbitrary OKF, and a typed schema for producing
  recognized fields — matching OKF's own conformance rules (§11) instead of forcing every document through one
  rigid shape.
- **Type safety & derivation helpers**: closed unions for `status` and trust tiers, plus small pure functions
  (`effectiveStatus`, `isStale`, `deriveTrustTier`) that encode the spec's read-time semantics without ever
  materializing a default into producer output.
- **Living documentation**: a schema reference generated straight from the code, plus a per-module architecture
  record explaining every non-obvious modeling decision.

Each of these is expanded in the sections below.

> [!IMPORTANT]
> **Version disclaimer.** This is the KCL **`v0.2-draft`** implementation, tracking upstream **OKF v0.2** as pinned
> at commit [`3fcbb9f`](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/3fcbb9f828c2f23d109c855ee403c3a4c81f3a96/okf/SPEC.md)
> (vendored in full at [`spec.md`](spec.md)).
>
> `okf.okfVersion` is the producer wire value `"0.2"` this library emits — not a consumer allow-list. Per §12,
> consumers encountering an unrecognized `okf_version` should attempt best-effort consumption rather than reject
> the bundle, so this library never closes that field to a fixed set of versions.

## Table of Contents

- [Why KCL as a Governance-as-Code DSL](#why-kcl-as-a-governance-as-code-dsl)
- [How the OKF standard was mapped to KCL schemas](#how-the-okf-standard-was-mapped-to-kcl-schemas)
- [How to use the Enkinex OKF KCL library](#how-to-use-the-enkinex-okf-kcl-library)
- [Getting Started with Enkinex OKF](#getting-started-with-enkinex-okf)
- [Enkinex OKF Library Reference](#enkinex-okf-library-reference)
- [External References and Resources](#external-references-and-resources)
- [What's Next](#whats-next)
- [Contributing](#contributing)
- [License](#license)

## Why KCL as a Governance-as-Code DSL

This library grew out of a concrete problem: an organization whose knowledge corpus spans many concept types —
tables, APIs, metrics, playbooks, attested computations — authored by both people and agents, and consumed by
still more agents downstream. **Plain markdown-plus-YAML does not scale** to that on its own: it is deliberately
unopinionated, and offers no computational governance beyond what a producer happens to remember to write.

Applied to a knowledge bundle, KCL opens up possibilities that hand-authored frontmatter cannot:

- **Reusable domain libraries**: factor the provenance, trust, lifecycle, and attested-computation families into
  shared schemas that every concept type imports and composes, instead of re-deriving "what does a verified,
  stale-checked concept look like" per team.
- **Enterprise conventions enforced in CI/CD**: organizations can inherit `okf.Concept` and layer their own
  required fields and `check` rules — a concept type registry, a mandatory `owner`, a closed `domain` union —
  without forking or modifying OKF itself.
- **Two-way validation**: the same schemas both validate frontmatter extracted from existing `.md` files
  (`kcl vet`) and type-check newly authored concepts before they are ever written to disk.
- **Better AI & spec-driven workflows**: a well-typed, well-documented KCL schema gives an agent generating
  frontmatter a concrete, checkable contract instead of prose guidance alone — directly serving OKF's own premise
  that most concepts are machine-generated.

## How the OKF standard was mapped to KCL schemas

OKF's frontmatter is organized in the spec as a handful of independent, optional families layered on top of one
required field (§4.1, §5, §10). Enkinex OKF keeps that grouping, but treats it as an **opinionated
software-engineering decision**: the KCL port is designed as a **library** where **modularity and maintainability
are first-class requirements**, so each family becomes a KCL **module** (a directory of related schemas) that other
modules import.

The library is composed of six modules plus a root composition:

| Module              | Purpose                                                                                                                              | Detailed docs                                                  |
|----------------------|----------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------|
| **`common`**         | Cross-cutting building blocks: the actor convention (`actorKind`) and the shared lexical date/datetime regex constants.               | [docs/schemas/common.md](docs/schemas/common.md)                  |
| **`provenance`**     | `Source` and `UsageWindow`: the materials a concept derives from, and the credibility signals recorded about them.                    | [docs/schemas/provenance.md](docs/schemas/provenance.md)          |
| **`trust`**          | `Generated`, `VerificationEvent`, `VerifiedType`: authorship and verification, plus `deriveTrustTier`.                                 | [docs/schemas/trust.md](docs/schemas/trust.md)                    |
| **`lifecycle`**      | `StatusType`, `effectiveStatus`, `isStale`: draft/stable/deprecated state and staleness, without materializing defaults.              | [docs/schemas/lifecycle.md](docs/schemas/lifecycle.md)            |
| **`document`**       | `Frontmatter` (permissive) and `ConceptMetadata` (typed): the two validation profiles a concept can be read against.                  | [docs/schemas/document.md](docs/schemas/document.md)              |
| **`computation`**    | `Parameter`, `Executor`, `Attester`, `AttestedComputationMetadata`: the §10 Attested Computation contract.                             | [docs/schemas/computation.md](docs/schemas/computation.md)        |
| **`okf.k`** *(root)* | The root **`Concept`** composition and the `okfVersion` producer constant.                                                             | [docs/schemas/okf.md](docs/schemas/okf.md)                        |

The root `Concept` in [`okf.k`](okf.k) is a one-line composition over `document.ConceptMetadata`, so a consumer can
`import okf` once instead of reaching into `document` directly. `okf.okfVersion` is deliberately left as an open
string rather than a closed union — see the version disclaimer above.

> The **design decisions and trade-offs** behind each module are documented per module under
> [`docs/schemas/`](docs/schemas/).

### Specification boundary

This library types OKF frontmatter. It does not parse markdown, walk a bundle's directory tree, resolve links, or
execute anything. Where the line falls:

| Area | KCL coverage | Compiler/runtime responsibility |
|---|---|---|
| Concept frontmatter | Permissive and typed producer schemas | Markdown/frontmatter parsing and body headings |
| Provenance and trust | Source, generation, verification, and derived trust models | Footnote attribution and identity resolution |
| Lifecycle | Typed status and lexical staleness | Full calendar/timezone parsing |
| Paths and links | Open string fields | Path normalization, link extraction, and broken links |
| Index and log files | Root-index frontmatter only (`okf_version`) | Reserved-file discovery and markdown body structure |
| Attested computations | Typed frontmatter contract | Computation extraction, execution, receipts, and attestation |
| Versioning | Producer constant and open root version field | Migration and best-effort version policy |

## How to use the Enkinex OKF KCL library

### Install / import via `kcl.mod`

Add the package to your KCL module's `kcl.mod` dependencies (Git or OCI source, per your setup), then import the
schema you need:

```kcl
import enkinex_okf.okf

concept = okf.Concept {
    $type = "Metric"
    title = "Revenue"
    generated = { by = "reference_agent/gemini-2.5-pro", at = "2026-06-20T22:53:05Z" }
}
```

`type` is a KCL keyword, so in KCL source the attribute is written `$type` — the `$` is an escape,
not part of the name. It never reaches the wire: `kcl run` emits `type:`, and the YAML frontmatter
you validate with `kcl vet` uses the plain OKF key `type` exactly as the spec defines it.

### Validate frontmatter extracted from an existing concept file

You do not have to rewrite anything to get validation: extract the YAML frontmatter block from an existing `.md`
concept and point `kcl vet` at it with the profile that matches what you're checking:

```bash
# Permissive: only requires a non-empty `type`, per §11.
kcl vet frontmatter.yaml document --format yaml -s Frontmatter

# Typed: validates every recognized family this library models.
kcl vet frontmatter.yaml . --format yaml -s Concept

# The stricter §10 contract for Attested Computation concepts.
kcl vet frontmatter.yaml computation --format yaml -s AttestedComputationMetadata
```

### Extend `okf.Concept` for organization-specific conventions

Inherit the root composition to add mandatory fields or closed vocabularies without modifying OKF itself:

```kcl
import enkinex_okf.okf

schema DataProductMetadata(okf.Concept):
    owner: str
    domain: str
    audience: "internal" | "external"

    check:
        owner != ""
        domain != ""
```

### Justfile targets

Common tasks are wrapped in the [`Justfile`](Justfile):

```bash
just init      # sync module dependencies (kcl mod update)
just fmt       # format every .k file
just lint      # kcl lint across every module directory
just test      # kcl vet every test/*.okf.yaml fixture, plus kcl test on the unit tests
just docs      # regenerate docs/library/okf.md from the schema docstrings
just check     # fmt + lint + test, the same gate CI expects
```

## Getting Started with Enkinex OKF

There isn't a separate tutorial project yet: the fastest way to see the library in action is the
[`test/`](test) directory, whose YAML fixtures double as reference documents:

- [`test/concept-full-standard.okf.yaml`](test/concept-full-standard.okf.yaml) exercises every field of the typed
  `Concept` profile at once — provenance, trust, lifecycle, and staleness together.
- The `test/concept-*.okf.yaml` files isolate one behavior each: openness under extension fields, the bare-vs-list
  `verified` wire shapes, each of the three lifecycle states, and a per-source `usage_window` override.
- The `test/attested-*.okf.yaml` files cover the §10 Attested Computation contract, both inline and file-based
  computations.
- The `test/frontmatter-*.okf.yaml` files demonstrate the permissive profile, including a fixture that is
  malformed under the typed profile but still valid frontmatter.

Run `just test` to validate all of them in one pass, or point `kcl vet` at any single fixture as shown above. For
the reasoning behind each schema's shape, see the per-module docs under [`docs/schemas/`](docs/schemas/).

## Enkinex OKF Library Reference

The complete, per-schema API reference is **auto-generated by the KCL CLI** from the schema docstrings and
property definitions:

**➡ [docs/library/okf.md](docs/library/okf.md)**

Regenerate it after any schema change with:

```bash
just docs      # runs: kcl doc generate --escape-html
```

Type aliases (`ActorKindType`, `StatusType`, `TrustTierType`, `VerifiedType`) and derivation lambdas
(`actorKind`, `effectiveStatus`, `isStale`, `normalizeVerified`, `deriveTrustTier`) aren't schemas, so the
generator doesn't cover them — they're documented by hand instead:

**➡ [docs/library/helpers.md](docs/library/helpers.md)**

## External References and Resources

- **Open Knowledge Format (OKF) v0.2**: the upstream specification this library mirrors:
  <https://github.com/GoogleCloudPlatform/knowledge-catalog/tree/main/okf>
    - Source specification mirrored here, pinned at the commit this library tracks:
      [`spec.md`](spec.md)
- **KCL language**: the configuration & policy DSL used for the implementation: <https://www.kcl-lang.io/>

## What's Next

- **Published module distribution**: cut the final **`v0.2`** release (from this `v0.2-draft`) once the draft has
  been reviewed, and publish it as an installable KCL module.
- **Worked examples**: a gallery of full sample knowledge bundles beyond the current `test/` fixtures, including
  the income-statement worked example from spec §Appendix A.
- **Negative-case coverage**: `kcl vet`'s pass-only validation loop doesn't express "assert this schema rejects";
  see the open question in [docs/schemas/document.md](docs/schemas/document.md) for options being considered.

## Contributing

Contributions are welcome — see [CONTRIBUTING.md](CONTRIBUTING.md), the contributor list in
[AUTHORS.md](AUTHORS.md), and our [Code of Conduct](CODE_OF_CONDUCT.md).

For notable changes per release and which upstream OKF version this library tracks, see
[CHANGELOG.md](CHANGELOG.md) and [history.md](history.md).

## License

Licensed under the terms in [LICENSE](LICENSE).
