import regex
import common
import lifecycle
import provenance
import trust

schema ConceptMetadata:
    """
    Open, typed producer metadata composed from OKF frontmatter families.

    Attributes
    ----------
    type : str, required
        Non-empty, unregistered concept type.
    title : str, optional
        Human-readable display name.
    description : str, optional
        One-line concept summary.
    resource : str, optional
        Canonical URI or path for the described asset.
    tags : [str], optional
        Open cross-cutting categorization.
    sources : [provenance.Source], optional
        Materials the concept derives from.
    usage_window : provenance.UsageWindow, optional
        Shared interval framing source usage counts.
    generated : trust.Generated, optional
        Authorship of the current content.
    verified : trust.VerifiedType, optional
        Bare or list verification wire form.
    status : lifecycle.StatusType, optional
        Lifecycle state; absence is effectively stable.
    stale_after : str, optional
        Inclusive stale boundary in YYYY-MM-DD form.
    """
    [str]: any
    $type: str
    title?: str
    description?: str
    resource?: str
    tags?: [str]
    sources?: [provenance.Source]
    usage_window?: provenance.UsageWindow
    generated?: trust.Generated
    verified?: trust.VerifiedType
    status?: lifecycle.StatusType
    stale_after?: str

    check:
        $type != ""
        regex.match(stale_after, common.datePattern) if stale_after

