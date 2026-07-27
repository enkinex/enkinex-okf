import lifecycle

test_effective_status_defaults_to_stable = lambda {
    assert lifecycle.effectiveStatus(None) == "stable"
    assert lifecycle.effectiveStatus(Undefined) == "stable"
}

test_effective_status_preserves_explicit_value = lambda {
    assert lifecycle.effectiveStatus("draft") == "draft"
    assert lifecycle.effectiveStatus("deprecated") == "deprecated"
}

test_is_stale_absent_stale_after = lambda {
    assert lifecycle.isStale(None, "2026-07-26") == False
    assert lifecycle.isStale(Undefined, "2026-07-26") == False
}

test_is_stale_boundary_is_inclusive = lambda {
    assert lifecycle.isStale("2026-07-26", "2026-07-26") == True
}

test_is_stale_before_and_after_boundary = lambda {
    assert lifecycle.isStale("2026-07-27", "2026-07-26") == False
    assert lifecycle.isStale("2026-07-25", "2026-07-26") == True
}
