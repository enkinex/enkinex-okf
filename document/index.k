schema RootIndexMetadata:
    """
    Open root-index metadata for best-effort version consumption.

    Attributes
    ----------
    okf_version : str, optional
        Open target-version declaration.
    """
    [str]: any
    okf_version?: str
