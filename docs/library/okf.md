# enkinex-okf

## Index

- [Concept](#concept)
- computation
  - [AttestedComputationMetadata](#attestedcomputationmetadata)
  - [Attester](#attester)
  - [Executor](#executor)
  - [Parameter](#parameter)
- document
  - [ConceptMetadata](#conceptmetadata)
  - [Frontmatter](#frontmatter)
  - [RootIndexMetadata](#rootindexmetadata)
- provenance
  - [Source](#source)
  - [UsageWindow](#usagewindow)
- trust
  - [Generated](#generated)
  - [VerificationEvent](#verificationevent)

## Schemas

### Concept

Open, typed OKF 0.2 concept frontmatter.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**description**|str|One-line concept summary.||
|**generated**|[Generated](#generated)|Authorship of the current content.||
|**resource**|str|Canonical URI or path for the described asset.||
|**sources**|[[Source](#source)]|Materials the concept derives from.||
|**stale_after**|str|Inclusive stale boundary in YYYY-MM-DD form.||
|**status**|"draft" \| "stable" \| "deprecated"|Lifecycle state; absence is effectively stable.||
|**tags**|[str]|Open cross-cutting categorization.||
|**title**|str|Human-readable display name.||
|**type** `required`|str|Non-empty, unregistered concept type.||
|**usage_window**|[UsageWindow](#usagewindow)|Shared interval framing source usage counts.||
|**verified**|[VerificationEvent](#verificationevent) \| [[VerificationEvent](#verificationevent)]|Bare or list verification wire form.||
### AttestedComputationMetadata

Typed producer contract for an Attested Computation concept.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**attester**|[Attester](#attester)|Deterministic-check contract.||
|**computation**|str|Path to a file computation; absence selects inline body semantics.||
|**description**|str|One-line concept summary.||
|**executor**|[Executor](#executor)|Execution contract.||
|**generated**|[Generated](#generated)|Authorship of the current content.||
|**parameters**|[[Parameter](#parameter)]|Typed, named holes the agent may fill.||
|**resource**|str|Canonical URI or path for the described asset.||
|**runtime** `required`|str|Non-empty runtime identifier.||
|**sources**|[[Source](#source)]|Materials the concept derives from.||
|**stale_after**|str|Inclusive stale boundary in YYYY-MM-DD form.||
|**status**|"draft" \| "stable" \| "deprecated"|Lifecycle state; absence is effectively stable.||
|**tags**|[str]|Open cross-cutting categorization.||
|**title**|str|Human-readable display name.||
|**type** `required` `readOnly`|"Attested Computation"|Fixed concept discriminator.|"Attested Computation"|
|**usage_window**|[UsageWindow](#usagewindow)|Shared interval framing source usage counts.||
|**verified**|[VerificationEvent](#verificationevent) \| [[VerificationEvent](#verificationevent)]|Bare or list verification wire form.||
### Attester

Deterministic, no-LLM check that inspects a receipt and returns a verdict.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**resource**|str|Path or URI naming deterministic attester code.||
### Executor

Run instructions and receipt declaration for executing a computation.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**receipt**|[str]|Evidence fields a run must return.||
|**resource**|str|Path or URI naming run instructions or code.||
### Parameter

Typed, named runtime parameter for an Attested Computation.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**name** `required`|str|Non-empty binding name.||
|**required** `required`|bool|Whether a consumer must supply a binding.||
|**type** `required`|str|Non-empty runtime-defined type.||
### ConceptMetadata

Open, typed producer metadata composed from OKF frontmatter families.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**description**|str|One-line concept summary.||
|**generated**|[Generated](#generated)|Authorship of the current content.||
|**resource**|str|Canonical URI or path for the described asset.||
|**sources**|[[Source](#source)]|Materials the concept derives from.||
|**stale_after**|str|Inclusive stale boundary in YYYY-MM-DD form.||
|**status**|"draft" \| "stable" \| "deprecated"|Lifecycle state; absence is effectively stable.||
|**tags**|[str]|Open cross-cutting categorization.||
|**title**|str|Human-readable display name.||
|**type** `required`|str|Non-empty, unregistered concept type.||
|**usage_window**|[UsageWindow](#usagewindow)|Shared interval framing source usage counts.||
|**verified**|[VerificationEvent](#verificationevent) \| [[VerificationEvent](#verificationevent)]|Bare or list verification wire form.||
### Frontmatter

Permissive consumer profile for arbitrary OKF concept frontmatter.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**type** `required`|str|Sole required non-empty field; its vocabulary remains open.||
### RootIndexMetadata

Open root-index metadata for best-effort version consumption.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**okf_version**|str|Open target-version declaration.||
### Source

A material a concept derives from, external or internal to the bundle.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**author**|str|Actor credibility signal.||
|**id**|str|Stable claim-attribution key.||
|**last_modified**|str|Source-change date in YYYY-MM-DD form.||
|**resource** `required`|str|Non-empty artifact, path, URI, or scope descriptor.||
|**title**|str|Human-readable source label.||
|**usage_count**|int|Non-negative usage signal.||
|**usage_window**|[UsageWindow](#usagewindow)|Per-source override of the shared usage window.||
### UsageWindow

Inclusive lexical date range framing source usage counts.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**from** `required`|str|Start date in YYYY-MM-DD form.||
|**to** `required`|str|End date in YYYY-MM-DD form, not before `from`.||
### Generated

Authorship of the current concept content.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**at**|str|Content-change datetime in ISO 8601 form.||
|**by** `required`|str|Non-empty actor identifier.||
### VerificationEvent

One confirmation of concept content against its sources or resource.

#### Attributes

| name | type | description | default value |
| --- | --- | --- | --- |
|**at** `required`|str|Verification datetime in ISO 8601 form.||
|**by** `required`|str|Non-empty verifier actor.||
<!-- Auto generated by kcl-doc tool, please do not edit. -->
