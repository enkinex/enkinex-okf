# Module: `trust`

## Schema Mapping

| KCL Schema / Type | Upstream OKF Section | Notes |
|---|---|---|
| `Generated` (`trust/event.k`) | §5.2 `generated` | `by` required, `at` optional |
| `VerificationEvent` (`trust/event.k`) | §5.2 `verified[]` entry | Both `by` and `at` required |
| `VerifiedType` (`trust/event.k`) | §5.2 `verified` | Union of a single event or a list — models the bare-vs-list wire form directly |
| `TrustTierType` (`trust/event.k`) | §5.3 | The three-tier closed union |
| `normalizeVerified` (`trust/event.k`) | §5.2, §11 ("consumers MUST treat a bare mapping as a one-element list") | Derives a normalized list without rewriting the schema's stored value |
| `deriveTrustTier` (`trust/event.k`) | §5.3 | Classifies via `common.actorKind` on every verifier |

## Architecture Decisions

- `VerifiedType = VerificationEvent | [VerificationEvent]` is the load-bearing modeling choice in this module: §5.2 and §11 both require the bare `{ by, at }` mapping to be accepted **and preserved** on the wire, not silently normalized into a list at the schema level. Normalization is deliberately pushed into `normalizeVerified`, a pure derivation a consumer calls explicitly — the schema itself never rewrites what a producer wrote.
- `deriveTrustTier` promotes to `"human-reviewed"` the moment *any* verifier's `actorKind` is `"human"`, matching §5.3's tier ordering exactly: `verified` by a `human:<id>` actor implies human-reviewed regardless of how many other verifiers are also present.
- `Generated` and `VerificationEvent` are separate schemas, not one shared "actor event" schema, even though both hold `{ by, at }`: `Generated.at` is optional (content can exist without a recorded change time) while `VerificationEvent.at` is required (a verification without a timestamp is not a verification per §5.2). Collapsing them would force one of the two to lose its correct optionality.

## Open Questions

- §5.2 says "how recently" reads as the *latest* `at` across `verified` entries. No `latestVerification`/`mostRecentAt` helper is provided yet alongside `normalizeVerified`/`deriveTrustTier`; add one if a consumer commonly needs it.
