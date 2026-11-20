# Agent Instructions

## Commands

Use the fully qualified name `zeldrisho/tap/<formula>`:

| Task | Command |
| --- | --- |
| Lint | `brew style zeldrisho/tap/<formula>` |
| Audit | `brew audit --strict zeldrisho/tap/<formula>` |

## Rules

- Before implementing changes, check the current branch. For changes to `Formula/`, switch to the appropriate task branch or create it from up-to-date `main` if it does not exist. If no formulae are affected, work on `main`.
- Changes to `Formula/` require a PR. Changes that leave `Formula/` untouched may be pushed directly to `main` without a PR.
- Do not build formulae from source locally. Use the remote CI build in `.github/workflows/tests.yml`; local lint and audit are allowed.
- This personal tap hosts and maintains the owner's Homebrew formulae; do not apply homebrew-core's notability requirements.
- Place provided formula files in `Formula/`; preserve their functionality and adapt them as needed for this tap.
- Make formula tests verify functionality beyond `--version` or `--help`.
- Add only required dependencies and avoid downloads inside `install`.
- Prefer automatic livecheck detection; add a `livecheck` block only when needed.
- Update the source URL and checksum together for version updates.
- Use `brew bump-revision` when a change requires rebuilding bottles.
- Keep PRs focused and check for existing PRs before duplicating work.
- Inspect complete CI logs and reproduce failures locally only if doing so does not require a source build.
- Keep formula PRs separate from README changes; update the formula table in `README.md` in a separate push to `main` when adding or removing formulae.
- Do not manually edit `bottle do` blocks; bottles are managed by the publishing workflow.
- Use commit messages `foo 1.2.3` for version updates, `foo 1.2.3 (new formula)` for additions, and `foo: fix <description>` for fixes.
- Use the same title for the PR and its commit message.
- Squash merge ordinary PRs; for formula PRs with bottles, use the publishing workflow instead of merging manually.
- After a formula PR passes its checks, publish bottles with `gh workflow run publish.yml -f pull_request=<number>`; optionally add `-f head_sha=<sha>` to verify the expected head commit.

## References

| Need | File |
| --- | --- |
| Installation and formulae | `README.md` |
| CI checks | `.github/workflows/tests.yml` |
| Bottle publishing | `.github/workflows/publish.yml` |
| Formula guidance | [Formula Cookbook](https://docs.brew.sh/Formula-Cookbook) |
