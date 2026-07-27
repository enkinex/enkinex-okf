type ActorKindType = "human" | "process" | "agent-or-tool"

actorKind = lambda actor: str -> ActorKindType {
    "human" if actor.startswith("human:") else "process" if actor.startswith("process:") else "agent-or-tool"
}
