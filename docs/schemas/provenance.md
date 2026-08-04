# Module: `provenance`

## Schema Mapping

| KCL Schema | Upstream OKF Section | Notes |
|---|---|---|
| `Source` (`provenance/source.k`) | §5.1 `sources[]` | One source entry; only `resource` is required |
| `UsageWindow` (`provenance/source.k`) | §5.1 `usage_window` | Shared window, or a per-source override |

## Architecture Decisions

- `Source.resource` accepts either a followable path/URI or a scope descriptor (for example `"all queries in BigQuery project X"`), per §5.1. It stays an unconstrained `str` rather than a URI-checked field, since a scope descriptor like that example wouldn't pass URI validation.
- `usage_count >= 0 if usage_count` uses a trailing-`if` guard idiom rather than an explicit `== Undefined or` check. This is safe specifically because `0` is itself a valid value and the boundary condition `0 >= 0` holds regardless of whether the check runs — skipping it for a falsy `0` can never let an invalid value through.
- `UsageWindow.from`/`.to` are unguarded (required) checks; the interval-ordering assertion (`int(from.replace(...)) <= int(to.replace(...))`) runs only after both individually pass the date-pattern check, so a malformed date fails on its own check rather than producing a confusing ordering error.

## Open Questions

- Credibility-signal *aggregation* (weighting `author`, `usage_count`, and `last_modified` into a single trust or credibility score) is explicitly out of scope per §5.1 ("OKF records the signals, not a verdict") and is not modeled here even as a helper lambda, unlike [lifecycle](lifecycle.md)'s `effectiveStatus` or [trust](trust.md)'s `deriveTrustTier`. Revisit only if a consumer-side scoring convention becomes common enough to standardize.
- Lineage recursion through `sources[].resource` pointing at another OKF concept (§5.1: "a consumer MAY recurse into that source's own sources") is a consumer-side graph-traversal concern and is out of scope for this KCL library, which only types a single `sources` entry.
