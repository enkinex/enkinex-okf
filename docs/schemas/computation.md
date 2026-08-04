# Module: `computation`

## Schema Mapping

| KCL Schema | Upstream OKF Section | Notes |
|---|---|---|
| `Parameter` (`computation/contract.k`) | §10.2 `parameters[]` | `{ name, type, required }`, all required |
| `Executor` (`computation/contract.k`) | §10.2 `executor` | `resource`/`receipt`, both optional |
| `Attester` (`computation/contract.k`) | §10.2 `attester` | `resource`, optional |
| `AttestedComputationMetadata` (`computation/concept.k`) | §10.1, §10.2 | `ConceptMetadata` narrowed to `type: "Attested Computation"` plus `runtime` (required) and the four computation fields |

## Architecture Decisions

- `AttestedComputationMetadata` inherits `document.ConceptMetadata` (see [document](document.md)) rather than duplicating `title`/`tags`/`sources`/`generated`/`verified`/`status`/`stale_after`: §10.2 is explicit that the contract sits "in addition to the provenance, trust, and lifecycle families (§5)" — an Attested Computation concept is a `ConceptMetadata` with extra required structure, not a disjoint shape.
- `type` is narrowed from the base schema's open `str` to the literal `"Attested Computation"`, and is re-documented in this schema's docstring even though it is inherited, because it is a genuinely *changed* constraint here, not an unchanged inherited one.
- `Parameter`, `Executor`, and `Attester` are separate schemas rather than one combined `Contract` schema, so a future consumer can validate a `parameters[]` entry, an `executor`, or an `attester` independently. An executor implementation, for example, can validate just the receipt contract it must satisfy.
- Per §10.3, `computation` (a path) and the body's `# Computation` fence are mutually exclusive alternate representations of the same thing; this library only types the frontmatter half (`computation?: str`), since the body fence is markdown content outside frontmatter and therefore outside this library's specification boundary.

## Open Questions

- §10.2's `Parameter.type` is a free-form `str` whose meaning is defined by `runtime` (a SQL type name for `bigquery`, a Python type for `python`, and so on). This library does not, and cannot without per-runtime plugins, validate that a given `type` value is sensible for its `runtime`.
- The receipt/verdict wire formats and the attester ABI are explicitly deferred in the spec itself (§12, "Considered and deferred"), so they are not modeled here beyond `Executor.receipt` naming the expected fields as an open string list.
