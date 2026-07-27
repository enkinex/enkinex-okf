import regex
import common

schema UsageWindow:
    """
    Inclusive lexical date range framing source usage counts.

    Attributes
    ----------
    from : str, required
        Start date in YYYY-MM-DD form.
    to : str, required
        End date in YYYY-MM-DD form, not before `from`.
    """
    [str]: any
    from: str
    to: str

    check:
        regex.match(from, common.datePattern)
        regex.match(to, common.datePattern)
        int(from.replace("-", "")) <= int(to.replace("-", ""))

schema Source:
    """
    A material a concept derives from, external or internal to the bundle.

    Attributes
    ----------
    resource : str, required
        Non-empty artifact, path, URI, or scope descriptor.
    id : str, optional
        Stable claim-attribution key.
    title : str, optional
        Human-readable source label.
    author : str, optional
        Actor credibility signal.
    usage_count : int, optional
        Non-negative usage signal.
    last_modified : str, optional
        Source-change date in YYYY-MM-DD form.
    usage_window : UsageWindow, optional
        Per-source override of the shared usage window.
    """
    [str]: any
    resource: str
    id?: str
    title?: str
    author?: str
    usage_count?: int
    last_modified?: str
    usage_window?: UsageWindow

    check:
        resource != ""
        usage_count >= 0 if usage_count
        regex.match(last_modified, common.datePattern) if last_modified

