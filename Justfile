#!/usr/bin/env just --justfile

default:
    @just --list

init:
    kcl mod update

fmt:
    kcl fmt ./...

lint:
    set -e; for d in . common computation document lifecycle provenance trust; do (cd "$d" && kcl lint .); done
    kcl lint test/*_test.k

docs:
    kcl doc generate --escape-html --target docs/library
    mv docs/library/docs/enkinex-okf.md docs/library/okf.md
    rmdir docs/library/docs/

test:
    set -e; for f in test/frontmatter-*.okf.yaml; do kcl vet "$f" document --format yaml -s Frontmatter; done
    set -e; for f in test/concept-*.okf.yaml; do kcl vet "$f" . --format yaml -s Concept; done
    set -e; for f in test/attested-*.okf.yaml; do kcl vet "$f" computation --format yaml -s AttestedComputationMetadata; done
    set -e; for f in test/index-*.okf.yaml; do kcl vet "$f" document --format yaml -s RootIndexMetadata; done
    kcl test test/ --no_style
    just test-negative
    just test-profiles

test-negative:
    set -e; for f in test/invalid-concept-*.okf.yaml; do [ -e "$f" ] || continue; if kcl vet "$f" . --format yaml -s Concept >/dev/null 2>&1; then echo "expected rejection but validated: $f"; exit 1; fi; done
    set -e; for f in test/invalid-attested-*.okf.yaml; do [ -e "$f" ] || continue; if kcl vet "$f" computation --format yaml -s AttestedComputationMetadata >/dev/null 2>&1; then echo "expected rejection but validated: $f"; exit 1; fi; done

test-profiles:
    set -e; for f in test/frontmatter-malformed-*.okf.yaml; do [ -e "$f" ] || continue; kcl vet "$f" document --format yaml -s Frontmatter >/dev/null; if kcl vet "$f" . --format yaml -s Concept >/dev/null 2>&1; then echo "expected typed-profile rejection: $f"; exit 1; fi; done

check:
    kcl fmt ./...
    git diff --exit-code -- '*.k' || (echo "Code is not formatted — run 'just fmt' and commit the result." && exit 1)
    just docs
    git diff --exit-code -- docs/library || (echo "Generated docs are stale — run 'just docs' and commit the result." && exit 1)
    just lint
    just test
