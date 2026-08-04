import regex
import common

type StatusType = "draft" | "stable" | "deprecated"

effectiveStatus = lambda status: any -> StatusType {
    "stable" if status == None or status == Undefined else status
}

isStale = lambda stale_after: any, today: str -> bool {
    assert regex.match(today, common.datePattern), "today must use YYYY-MM-DD"
    assert stale_after == None or stale_after == Undefined or regex.match(stale_after, common.datePattern), "stale_after must use YYYY-MM-DD"
    False if stale_after == None or stale_after == Undefined else int(today.replace("-", "")) >= int(stale_after.replace("-", ""))
}
