# Security Policy

## Supported versions

This library tracks a single moving line of development. Security fixes are
made against `main` and released as part of the next `v0.2-draft` (or later)
version — there are no older maintained release branches.

## Reporting a vulnerability

Please do not open a public GitHub issue for security reports.

Instead, use GitHub's private vulnerability reporting for this repository:
open the **Security** tab, then **Report a vulnerability**. This opens a
private draft security advisory visible only to you and the maintainers
listed in [`.github/CODEOWNERS`](.github/CODEOWNERS).

Include, as far as you're able:

- The affected file(s) or schema(s), and the KCL/CLI version you're on.
- A minimal reproduction (a KCL snippet or `.okf.yaml` fixture plus the
  `kcl vet`/`kcl run` command).
- The potential impact — this is a schema/validation library, so the
  relevant impact is typically a validation bypass (invalid data accepted)
  rather than code execution.

We'll acknowledge reports as quickly as we can and work with you on a fix
and coordinated disclosure timeline before any public advisory is published.
