type ApiVersionType = "v0.1-draft"

schema KnowledgeBundle:
    """
    A bundle is a directory tree of markdown files.
    The directory structure is independent of the domain — producers organize concepts however makes sense for the knowledge being captured.

    Attributes
    ----------
    version: ApiVersionType, default is "v0.1-draft", required.
        Open Knowledge Format (OKF) specification version.
    """
    version: ApiVersionType = "v0.1-draft"

    check:
        len(version) > 0, "version must not be empty"

