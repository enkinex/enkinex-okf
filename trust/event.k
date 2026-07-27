import regex
import common

type TrustTierType = "unverified" | "machine-confirmed" | "human-reviewed"

schema Generated:
    """
    Authorship of the current concept content.

    Attributes
    ----------
    by : str, required
        Non-empty actor identifier.
    at : str, optional
        Content-change datetime in ISO 8601 form.
    """
    [str]: any
    by: str
    at?: str

    check:
        by != ""
        regex.match(at, common.dateTimePattern) if at

schema VerificationEvent:
    """
    One confirmation of concept content against its sources or resource.

    Attributes
    ----------
    by : str, required
        Non-empty verifier actor.
    at : str, required
        Verification datetime in ISO 8601 form.
    """
    [str]: any
    by: str
    at: str

    check:
        by != ""
        regex.match(at, common.dateTimePattern)

type VerifiedType = VerificationEvent | [VerificationEvent]

normalizeVerified = lambda verified: any -> [any] {
    [] if verified == None or verified == Undefined else (verified if typeof(verified) == "list" else [verified])
}

deriveTrustTier = lambda verified: any -> TrustTierType {
    events = normalizeVerified(verified)
    "unverified" if len(events) == 0 else ("human-reviewed" if any event in events {common.actorKind(event.by) == "human"} else "machine-confirmed")
}
