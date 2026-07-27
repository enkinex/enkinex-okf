# Module: `lifecycle`

## Schema Mapping

| KCL Schema / Type | Upstream OKF Section | Notes |
|---|---|---|
| `StatusType` (`lifecycle/status.k`) | §5.4 | `draft \| stable \| deprecated` |
| `effectiveStatus` (`lifecycle/status.k`) | §5.4 ("Absent `status` ⇒ `stable`") | Derives the default; never runs at the schema level |
| `isStale` (`lifecycle/status.k`) | §5.5 | `today >= stale_after`, inclusive |

## Architecture Decisions

- `status` is never given a schema-level default (there is no `status: StatusType = "stable"` on `ConceptMetadata`). §5.4's "absent ⇒ stable" is a *read-time* interpretation rule, not a serialization rule. Materializing it as a default would mean every producer output silently gains a `status: stable` key it never wrote, breaking round-tripping and making "was status explicitly set" unrecoverable. `effectiveStatus` is the explicit, opt-in place that rule lives; see [document](document.md)'s `test_status_is_not_materialized_when_absent`.
- `isStale` takes `today` as an explicit parameter rather than reading a clock, keeping the comparison a pure function. This is consistent with §5.5's own framing ("keeps the staleness decision a plain date comparison with no reference to when the concept was read").
- `isStale`'s two `assert ..., "message"` guards are the one place in this library that keeps a message-carrying assertion style rather than the message-less `check` blocks used elsewhere. The distinction is deliberate: this is a **callable library function** guarding its own argument contract (an ordinary function precondition), not a **schema field constraint** — the message-less convention applies specifically to schema `check:` blocks, which have no equivalent precedent for lambdas.

## Open Questions

- `isStale` and `effectiveStatus` are independent lambdas; there is no single `lifecycleState(status, stale_after, today)` combinator that returns both dimensions at once, even though most callers will want both. Consider adding one if that pattern shows up in real consumers.
