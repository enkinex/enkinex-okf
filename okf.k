import document

okfVersion = "0.2"

schema Concept(document.ConceptMetadata):
    """
    Open, typed OKF 0.2 concept frontmatter.
    """
    [str]: any
