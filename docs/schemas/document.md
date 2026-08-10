# Module: `document`

## Schema Mapping

| KCL Schema | Upstream OKF Section | Notes |
|---|---|---|
| `Frontmatter` (`document/conformance.k`) | §4.1, §11 | Permissive consumer profile: only `$type != ""` |
| `ConceptMetadata` (`document/concept.k`) | §4.1, §5 | Typed producer profile composing all frontmatter families |
| `RootIndexMetadata` (`document/index.k`) | §8, §12 | The one frontmatter shape a bundle-root `index.md` may carry |

## Architecture Decisions

- This is the one module whose central decision is a **pair** of schemas over the same wire shape, not a single canonical one: `Frontmatter` for consumers reading arbitrary OKF (§11's minimal three-rule conformance bar) and `ConceptMetadata` for producers emitting the recognized families (§5). It exists because §11 is explicit that consumers "MUST NOT reject a bundle" over a malformed *optional* family — a single strict schema cannot express that, since a malformed `sources` entry would otherwise fail the whole document.
- `ConceptMetadata` composes `provenance.Source`/`UsageWindow`, `trust.Generated`/`VerifiedType`, and `lifecycle.StatusType` by reference rather than repeating their shapes, so a change to any family module (for example a new trust tier) doesn't require touching `document/concept.k`.
- `okf.Concept` (root `okf.k`) is a one-line composition over `ConceptMetadata` and intentionally adds nothing: it exists purely so a consumer can `import okf` once instead of `import document`. See [okf](okf.md).
- OKF's mandatory `type` key collides with the KCL keyword `type`, so it is declared and referenced as `$type` in KCL source — in `ConceptMetadata`, in `Frontmatter`, and in the `check:` blocks of both. The `$` is KCL's keyword escape, not part of the identifier: the attribute serializes as `type`, `kcl vet` matches the plain `type:` key in a YAML fixture, and the generated reference in [`docs/library/okf.md`](../library/okf.md) lists it as `type`. Docstrings describe the wire name and so stay unescaped.

## Open Questions

- **Resolved.** `just test` runs `just test-profiles`, which validates `test/frontmatter-malformed-family.okf.yaml` against `Frontmatter` (must pass) and `Concept` (must fail) for nine malformed-family cases, locking in the permissive/typed boundary. Broader negative-case coverage for every `check:` rule across the library (not just this module's profile split) lives in `test/invalid-*.okf.yaml`, enforced by `just test-negative`.
- A minimal concept's `kcl run` output never materializes `status`; that regression check lives in `test/document_test.k`'s `test_status_is_not_materialized_when_absent`.
