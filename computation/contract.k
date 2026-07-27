schema Parameter:
    """
    Typed, named runtime parameter for an Attested Computation.

    Attributes
    ----------
    name : str, required
        Non-empty binding name.
    type : str, required
        Non-empty runtime-defined type.
    required : bool, required
        Whether a consumer must supply a binding.
    """
    [str]: any
    name: str
    type: str
    required: bool

    check:
        name != ""
        type != ""

schema Executor:
    """
    Run instructions and receipt declaration for executing a computation.

    Attributes
    ----------
    resource : str, optional
        Path or URI naming run instructions or code.
    receipt : [str], optional
        Evidence fields a run must return.
    """
    [str]: any
    resource?: str
    receipt?: [str]

schema Attester:
    """
    Deterministic, no-LLM check that inspects a receipt and returns a verdict.

    Attributes
    ----------
    resource : str, optional
        Path or URI naming deterministic attester code.
    """
    [str]: any
    resource?: str

