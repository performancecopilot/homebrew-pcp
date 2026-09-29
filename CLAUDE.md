# homebrew-pcp

Personal Homebrew tap for [Performance Co-Pilot](https://pcp.io/) (PCP) on macOS. One
cask, `Casks/pcp.rb`, wrapping upstream's official `.dmg` installer.

## Workflow: issue → branch → PR

Even though this is a low-traffic personal tap, changes go through the standard GitHub
flow rather than straight to `main`:

1. Open a GitHub issue describing the change (a version bump, a lint fix, whatever it
   is) — this gives the change a paper trail and something for a PR to close.
2. Do the work on a branch, not on `main`.
3. Open a PR against `main` that references the issue (e.g. `Closes #N`).

This repo doesn't need a fork — push branches directly and open the PR from there.

## Finding the latest upstream PCP release

Upstream releases live at `performancecopilot/pcp` on GitHub (not this repo).

```
gh release list --repo performancecopilot/pcp --limit 5
```

Each release ships exactly one macOS asset, `pcp-<version>.dmg`, where `<version>`
already bakes in upstream's own build suffix (e.g. release tag `7.2.1` → asset
`pcp-7.2.1-1.dmg` → cask `version "7.2.1-1"`). Confirm the asset name before trusting it:

```
gh release view <tag> --repo performancecopilot/pcp --json assets -q '.assets[].name'
```

To bump the cask to a new release, use the `bump-pcp-cask` skill
(`.claude/skills/bump-pcp-cask/SKILL.md`) rather than doing it ad hoc — it covers the
sha256 verification caveat (there's no independently-published checksum from upstream,
only the GitHub-hosted asset itself) and the style gate below.

## Mandatory: `brew style` before every commit

Before committing any change to a Cask or Formula file, run `brew style <file>` and
confirm it reports no offenses. If it reports any, run `brew style --fix <file>` and
re-check — don't commit with known-fixable offenses outstanding. This applies to every
commit that touches Ruby cask/formula files, not just ones that deliberately restyle
them; a broken tap file fails silently for every user who taps it, so this isn't
optional cleanup, it's a correctness gate.
