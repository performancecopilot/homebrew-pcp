---
name: bump-pcp-cask
description: Bump the pcp Homebrew cask (Casks/pcp.rb) in this tap to the latest upstream Performance Co-Pilot release. Use this whenever the user asks to update, bump, upgrade, or refresh the pcp cask/formula, check for a new PCP release, or otherwise sync this tap with upstream performancecopilot/pcp. Also trigger on requests like "is there a new PCP version" or "let's cut a release for the new PCP" in this repo.
---

# Bump the pcp cask to the latest upstream release

This tap tracks the upstream `performancecopilot/pcp` GitHub releases. Each release
ships exactly one macOS installer asset, `pcp-<version>.dmg`, where `<version>` already
includes upstream's own build suffix (e.g. `7.2.1-1`, not a Homebrew revision we invent).
The cask's `url` is built from `version` via string interpolation, so bumping the cask is
almost entirely: find the new version, get its real sha256, drop both into two lines.

Work through these steps in order. Don't skip the audit/diff steps even if everything
"looks fine" — a wrong sha256 silently breaks installs for everyone on the tap.

## 1. Read the current state

Read `Casks/pcp.rb` and note the current `version` line. That's your baseline.

## 2. Find the latest upstream release

```
gh release list --repo performancecopilot/pcp --limit 5
```

Pick the newest release that isn't marked as a draft or prerelease. If it's already the
same version as the cask, tell the user the cask is already current and stop here —
there's nothing else to do.

## 3. Confirm the release asset matches the expected shape

```
gh release view <tag> --repo performancecopilot/pcp --json assets -q '.assets[].name'
```

You should see a single asset named `pcp-<tag>-<N>.dmg` (the `-<N>` is upstream's build
suffix, part of the cask's `version` string, e.g. release tag `7.2.1` → asset
`pcp-7.2.1-1.dmg` → cask `version "7.2.1-1"`). If the asset naming doesn't match this
pattern, or there's more than one candidate asset, stop and flag it to the user instead
of guessing — the cask's `url` line assumes this exact shape.

## 4. Download the asset and hash it

Download the `.dmg` to a scratch/temp location (not into the repo), then:

```
shasum -a 256 <downloaded-file>
```

Delete the downloaded file once you have the hash — it doesn't belong in version control
and there's no reason to keep a 10+ MB installer lying around.

**On trust**: this hash is computed from the same GitHub-hosted file we're pointing the
cask at — there's no independently-published `SHA256SUMS` file or signed checksum from
the PCP maintainers to cross-check it against (checked: nothing in the release assets or
release body). That's the same trust model Homebrew's own `brew bump-cask-pr` uses, so
it's not a weaker guarantee than usual — just worth knowing there's no second source of
truth here, only the download itself.

## 5. Edit the cask

In `Casks/pcp.rb`, update only the `version` and `sha256` lines. Leave everything else
alone, including the `url` line — it derives from `version` automatically. Don't "fix"
unrelated pre-existing style issues in the file while you're in there; that's a separate
concern from a version bump.

## 6. Lint it

`brew style` passing clean is mandatory before any commit to this tap (see this repo's
`CLAUDE.md`) — a style offense in a cask file can mean broken Ruby, not just cosmetics.

```
brew style Casks/pcp.rb
```

If it reports offenses, run `brew style --fix Casks/pcp.rb` and re-check. Auto-fixing here
is fine even though the offenses predate your version bump — the mandate is that the file
passes clean before commit, not that you only fix what you personally introduced.

## 7. Show the diff and get the go-ahead

Run `git diff` and show it to the user. Don't publish anything until they say go — the
issue, push and PR are visible to others, so they get a confirmation first.

## 8. Issue → branch → PR

Once the user approves, finish the bump the way this repo's `CLAUDE.md` requires:

1. Open an issue: `gh issue create --title "Bump pcp cask to <version>"` with a body
   noting the upstream release date and asset.
2. Create a branch (e.g. `bump-pcp-<tag>`) from `main` — never commit to `main`. The
   uncommitted cask edit carries over with `git switch -c`.
3. Commit the cask change with a concise message focused on why (tracking upstream
   `<tag>`). No Claude Code footer.
4. Push the branch and open a PR against `main` with `Closes #<issue>` in the body:
   `gh pr create`.
5. Report the PR URL to the user. Don't merge it.
