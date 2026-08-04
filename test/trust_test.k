import trust

test_normalize_verified_absent = lambda {
    assert trust.normalizeVerified(None) == []
    assert trust.normalizeVerified(Undefined) == []
}

test_normalize_verified_bare_mapping = lambda {
    events = trust.normalizeVerified({by = "human:ahormati", at = "2026-06-25T09:00:00Z"})
    assert len(events) == 1
    assert events[0].by == "human:ahormati"
}

test_normalize_verified_list = lambda {
    events = trust.normalizeVerified([
        {by = "process:finance-nightly", at = "2026-06-26T02:00:00Z"}
        {by = "human:ahormati", at = "2026-06-25T09:00:00Z"}
    ])
    assert len(events) == 2
}

test_derive_trust_tier_unverified = lambda {
    assert trust.deriveTrustTier(None) == "unverified"
}

test_derive_trust_tier_machine_confirmed = lambda {
    assert trust.deriveTrustTier({by = "process:finance-nightly", at = "2026-06-26T02:00:00Z"}) == "machine-confirmed"
}

test_derive_trust_tier_human_reviewed = lambda {
    assert trust.deriveTrustTier([
        {by = "process:finance-nightly", at = "2026-06-26T02:00:00Z"}
        {by = "human:ahormati", at = "2026-06-25T09:00:00Z"}
    ]) == "human-reviewed"
}
