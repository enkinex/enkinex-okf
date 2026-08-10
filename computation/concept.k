import document

schema AttestedComputationMetadata(document.ConceptMetadata):
    """
    Typed producer contract for an Attested Computation concept.

    Attributes
    ----------
    type : "Attested Computation", required
        Fixed concept discriminator.
    runtime : str, required
        Non-empty runtime identifier.
    parameters : [Parameter], optional
        Typed, named holes the agent may fill.
    computation : str, optional
        Path to a file computation; absence selects inline body semantics.
    executor : Executor, optional
        Execution contract.
    attester : Attester, optional
        Deterministic-check contract.
    """
    [str]: any
    $type: "Attested Computation"
    runtime: str
    parameters?: [Parameter]
    computation?: str
    executor?: Executor
    attester?: Attester

    check:
        runtime != ""

