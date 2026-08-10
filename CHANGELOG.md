This document tracks the history and evolution of the Enkinex KCL Library for the **Open Knowledge Format (OKF) Specification**.

# Unreleased
* Fixes
  * OKF's `type` key is a KCL keyword; it is now declared and referenced with KCL's `$` escape (`$type`) in `document.ConceptMetadata`, `document.Frontmatter`, `computation.Parameter`, `computation.AttestedComputationMetadata`, their `check:` rules, and the `test/document_test.k` config keys. The escape is source-only — serialized output, `test/*.okf.yaml` fixtures, docstrings, and the generated reference all keep the plain OKF key `type`
* Documentation
  * `CONTRIBUTING.md` documents the KCL reserved-word list and when the `$` escape does and does not apply; `AGENTS.md`, `README.md`, `docs/schemas/document.md`, and `docs/schemas/computation.md` updated to match

# v0.2-draft - Initial v0.2 Draft
* Schemas
  * `okf.Concept`, a root composition over `document.ConceptMetadata`
  * `document.Frontmatter` (permissive consumer profile) and `document.ConceptMetadata` (typed producer profile)
  * `document.RootIndexMetadata` for bundle-root `index.md` version declaration
  * `provenance.Source` and `provenance.UsageWindow`
  * `trust.Generated`, `trust.VerificationEvent`, and the `trust.VerifiedType` bare-or-list union
  * `lifecycle.StatusType`, `lifecycle.effectiveStatus`, `lifecycle.isStale`
  * `computation.Parameter`, `computation.Executor`, `computation.Attester`, `computation.AttestedComputationMetadata`
  * `common.actorKind`, `common.datePattern`, `common.dateTimePattern`
  * Replaced the earlier `KnowledgeBundle` (OKF v0.1) stub
* Documentation
  * README
  * Schema Mapping and Architectural Decisions
  * Reference documentation generated from KCL
* Sample Project
  * Fixtures under `test/*.okf.yaml` double as worked examples
* Validation
  * `kcl vet` fixtures per schema (`document.Frontmatter`, `okf.Concept`, `computation.AttestedComputationMetadata`, `document.RootIndexMetadata`)
  * `kcl test` unit tests for the derivation helpers (`actorKind`, `effectiveStatus`, `isStale`, `normalizeVerified`, `deriveTrustTier`) and for the shared `datePattern`/`dateTimePattern` regex constants
  * `test/invalid-*.okf.yaml` negative fixtures, one per `check:` rule in the library, asserted to be rejected by `just test-negative`
  * `just test-profiles` locks in the permissive/typed profile boundary (`document.Frontmatter` accepts, `okf.Concept` rejects, the same malformed input)
  * `just check` now regenerates and diff-gates `docs/library`, so a stale generated reference fails CI
* Governance
  * `SECURITY.md` and a restored "Code of conduct and security" section in `CONTRIBUTING.md`
  * CI installs a pinned KCL release instead of `latest`, and sets `permissions`, `concurrency`, and `timeout-minutes` on the workflow
  * `docs/library/helpers.md`, a hand-maintained reference for the type aliases and derivation lambdas `kcl doc generate` doesn't cover
