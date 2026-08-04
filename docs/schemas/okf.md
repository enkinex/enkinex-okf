# Module: `okf` (root package: `okf.k`)

## Schema Mapping

| KCL Schema / Type | Upstream OKF Section | Notes |
|---|---|---|
| `okfVersion` (`okf.k`) | §12 | The producer wire value this library emits, currently `"0.2"` |
| `Concept` (`okf.k`) | §4.1, §5 (via `document.ConceptMetadata`) | One-line root composition; the single top-level type most consumers import |

## Architecture Decisions

- `okfVersion` is a bare constant, not a closed `type OkfVersionType = "0.2"` union that would close `okf_version` to a fixed set of known values. §12 requires consumers to "attempt best-effort consumption" of a declared `okf_version` they don't recognize rather than validating it against a known set — closing the type would make this library reject exactly the future-version documents §12 says must still be accepted. `document.RootIndexMetadata.okf_version` is left open as a plain `str` for the same reason; see [document](document.md).
- `Concept` deliberately adds nothing beyond `document.ConceptMetadata` (no extra fields, no extra checks), so it gets the single-line docstring form (no `Attributes` section), matching the house convention that inherited-only schemas don't re-document what they add nothing to.
- The retired OKF v0.1 `KnowledgeBundle` schema (a single `version` field with no frontmatter modeling at all) is not carried forward: §2 defines a bundle as a directory tree, which has no meaningful representation as a typed KCL schema, and the field it modeled is superseded by the richer `okf_version` treatment described in [document](document.md) §12.

## Open Questions

- If a future OKF minor version changes a required field on `ConceptMetadata`, `okf.Concept` inherits the change automatically; there is no version-pinned `Concept` variant for producers who need to stay on an older wire shape while the library moves forward. Revisit if that need materializes.
