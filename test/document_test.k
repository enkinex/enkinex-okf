import okf
import provenance

test_openness_at_top_level = lambda {
    concept = okf.Concept {
        type = "Future Concept Type"
        organization = {classification = "internal"}
    }
    assert concept.organization.classification == "internal"
}

test_openness_inside_sources = lambda {
    source = provenance.Source {
        resource = "all queries in BigQuery project X"
        vendor_signal = {score = 7, explanation = "experimental"}
    }
    assert source.vendor_signal.score == 7
}

test_status_is_not_materialized_when_absent = lambda {
    concept = okf.Concept {type = "Playbook"}
    assert concept.status == Undefined
}

test_bare_verified_shape_is_preserved = lambda {
    concept = okf.Concept {
        type = "Metric"
        verified = {by = "human:ahormati", at = "2026-06-25T09:00:00Z"}
    }
    assert typeof(concept.verified) != "list"
}

test_list_verified_shape_is_preserved = lambda {
    concept = okf.Concept {
        type = "Metric"
        verified = [{by = "process:finance-nightly", at = "2026-06-26T02:00:00Z"}]
    }
    assert typeof(concept.verified) == "list"
}
