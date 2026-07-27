# Module: `common`

## Schema Mapping

| KCL Schema / Type | Upstream OKF Section | Notes |
|---|---|---|
| `ActorKindType` (`common/actor.k`) | §7 Actor convention | Named union over the three actor prefixes |
| `actorKind` (`common/actor.k`) | §7 | Lambda classifying an actor string by prefix |
| `datePattern` (`common/date.k`) | §5.5, §5.1 (`last_modified`), §9 (date headings) | Bare lexical `YYYY-MM-DD` regex constant |
| `dateTimePattern` (`common/datetime.k`) | §5.2 (`generated.at`, `verified[].at`) | Bare lexical ISO-8601 datetime regex constant |

## Architecture Decisions

- Actor classification and the two date/time regex constants live in `common` because they're shared by four downstream packages (`document`, `provenance`, `trust`, `lifecycle`).
- `actorKind` only inspects the prefix (`human:`, `process:`) and defaults everything else, including unversioned or malformed producer strings, to `"agent-or-tool"`. This mirrors §7's own text: the spec defines only `human:` and `process:` as closed prefixes and treats `<producer>/<version>` as the open default case.
- Date and datetime validation is lexical only (a regex against `YYYY-MM-DD` / ISO-8601), never calendar-aware. There's no rejection of `2026-02-30` and no leap-second handling. §1 explicitly scopes calendar and timezone correctness to a document compiler, not this library.

## Open Questions

- If a future OKF revision adds a fourth actor prefix, `actorKind`'s trailing `else` branch will silently absorb it as `"agent-or-tool"` rather than erroring. That is intentional today (it matches §7's open-ended default), but worth revisiting if actor prefixes ever become a closed, exhaustively-validated set.
