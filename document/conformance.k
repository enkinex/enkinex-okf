schema Frontmatter:
    """
    Permissive consumer profile for arbitrary OKF concept frontmatter.

    Attributes
    ----------
    type : str, required
        Sole required non-empty field; its vocabulary remains open.
    """
    [str]: any
    $type: str

    check:
        $type != ""
