# enkinex-okf — Types and helpers

`kcl doc generate` only emits reference pages for `schema` declarations, so
the library's `type` aliases and derivation `lambda`s (several of which the
[README](../../README.md) highlights directly) have no entry in the
generated [`okf.md`](okf.md) reference. This page covers them instead.

**This file is hand-maintained.** `just docs` regenerates `okf.md` only; it
does not touch this page. Update it yourself whenever you add, remove, or
change the signature or semantics of a type alias or lambda (see
[`CONTRIBUTING.md`](../../CONTRIBUTING.md)).

## Index

- common
  - [`ActorKindType`](#actorkindtype)
  - [`actorKind`](#actorkind)
- lifecycle
  - [`StatusType`](#statustype)
  - [`effectiveStatus`](#effectivestatus)
  - [`isStale`](#isstale)
- trust
  - [`TrustTierType`](#trusttiertype)
  - [`VerifiedType`](#verifiedtype)
  - [`normalizeVerified`](#normalizeverified)
  - [`deriveTrustTier`](#derivetrusttier)

## common

### ActorKindType

```kcl
type ActorKindType = "human" | "process" | "agent-or-tool"
```

Closed classification of an actor identifier's prefix.

### actorKind

```kcl
actorKind = lambda actor: str -> ActorKindType
```

Classifies an actor string by its prefix: `"human:"` → `"human"`,
`"process:"` → `"process"`, anything else → `"agent-or-tool"` (the catch-all;
there is no closed list of agent/tool prefixes, so any unrecognized prefix
falls here by design — see `docs/schemas/common.md` for the open question on
revisiting this if actor prefixes ever close).

## lifecycle

### StatusType

```kcl
type StatusType = "draft" | "stable" | "deprecated"
```

Closed lifecycle vocabulary for `document.ConceptMetadata.status`.

### effectiveStatus

```kcl
effectiveStatus = lambda status: any -> StatusType
```

Resolves the effective status of a concept: `None`/`Undefined` (i.e. an
absent `status` field) resolves to `"stable"`; any explicit value passes
through unchanged. Encodes the library's "absence is effectively stable"
convention — a concept with no `status` field is not "unknown", it's stable.

### isStale

```kcl
isStale = lambda stale_after: any, today: str -> bool
```

Returns whether `today` is on or after `stale_after`. `stale_after` may be
`None`/`Undefined` (returns `False` — no boundary means never stale); `today`
is required and both, when present, must match `common.datePattern`
(`YYYY-MM-DD`), enforced with an `assert` inside the lambda body since there
is no `check:` block to guard a function's own arguments. **The boundary is
inclusive**: `isStale("2026-07-26", "2026-07-26")` is `True`. Comparison is
purely lexical (`int(date.replace("-", ""))`), not calendar-aware.

## trust

### TrustTierType

```kcl
type TrustTierType = "unverified" | "machine-confirmed" | "human-reviewed"
```

Closed trust tier derived from a concept's `verified` events; never itself a
schema field — only ever a `deriveTrustTier` return value.

### VerifiedType

```kcl
type VerifiedType = VerificationEvent | [VerificationEvent]
```

The wire type of `document.ConceptMetadata.verified` — a producer may write
either a single bare `VerificationEvent` mapping or a list of them.
`normalizeVerified` is what widens either shape to a uniform list.

### normalizeVerified

```kcl
normalizeVerified = lambda verified: any -> [any]
```

Widens the bare-or-list `verified` wire form to a list: `None`/`Undefined` →
`[]`; a single mapping → `[mapping]`; an existing list → unchanged.

### deriveTrustTier

```kcl
deriveTrustTier = lambda verified: any -> TrustTierType
```

Derives a `TrustTierType` from a concept's (possibly bare, possibly absent)
`verified` field, via `normalizeVerified`: no verification events →
`"unverified"`; at least one event whose `by` classifies as `"human"` per
`common.actorKind` → `"human-reviewed"`; otherwise → `"machine-confirmed"`.
