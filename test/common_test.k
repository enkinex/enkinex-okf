import regex
import common

test_actor_kind_human = lambda {
    assert common.actorKind("human:ahormati") == "human"
}

test_actor_kind_process = lambda {
    assert common.actorKind("process:finance-nightly") == "process"
}

test_actor_kind_agent_or_tool = lambda {
    assert common.actorKind("reference_agent/gemini-2.5-pro") == "agent-or-tool"
}

test_date_pattern_accepts_valid_date = lambda {
    assert regex.match("2026-07-26", common.datePattern) == True
}

test_date_pattern_rejects_malformed_date = lambda {
    assert regex.match("07-26-2026", common.datePattern) == False
    assert regex.match("2026/07/26", common.datePattern) == False
    assert regex.match("2026-07-26T00:00:00Z", common.datePattern) == False
}

test_date_time_pattern_accepts_valid_datetime = lambda {
    assert regex.match("2026-07-26T12:00:00Z", common.dateTimePattern) == True
    assert regex.match("2026-07-26T12:00:00.123Z", common.dateTimePattern) == True
    assert regex.match("2026-07-26T12:00:00-03:00", common.dateTimePattern) == True
}

test_date_time_pattern_rejects_malformed_datetime = lambda {
    assert regex.match("2026-07-26", common.dateTimePattern) == False
    assert regex.match("2026-07-26 12:00:00", common.dateTimePattern) == False
    assert regex.match("not-a-datetime", common.dateTimePattern) == False
}
