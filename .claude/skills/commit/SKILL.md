---
name: commit
description: Group the working tree into small, logical, conventional commits and verify each one. Use when the user asks to commit, says work is finished and should be saved, or asks how to split changes into commits.
---

# Committing work on Run Free

Produce a **commit plan first, then wait for approval.** Never commit a whole
session's work as one change.

## 1. Survey

```bash
git status --short
git diff --stat
git diff                 # actually read it; do not infer from filenames
git log --oneline -5     # match the existing style
```

## 2. Group into logical changes

One commit = one reason to change. Split whenever a change mixes:

- a **refactor** with a **behaviour change** — the most important split. A
  reviewer can verify "moved code, changed nothing" or "changed behaviour",
  never both in one diff.
- a **bug fix** with a **feature** — fixes get backported, features do not.
- **formatting or docs** with **logic** — a 300-line reformat hides the 3-line
  logic change inside it.
- two unrelated bugs, however small.

Target under ~400 lines per commit. Review effectiveness collapses past that.

Tests generally belong **with** the code they cover. A standalone commit adding
tests for pre-existing code is fine and useful.

## 3. Write messages

Conventional Commits: `type(scope): summary`

`feat` `fix` `docs` `test` `refactor` `chore` `ci` `perf` `style`

- Summary: imperative mood, lower case, no trailing period, under ~72 chars.
  "add split calculation", not "added" or "adds".
- Body: wrap at 72 columns. Explain **why**, not what — the diff already shows
  what. State the reasoning, the constraint, or the bug's mechanism.
- A one-line message is fine for genuinely trivial changes.

Good:

```
fix(recording): force moving mode when a session starts

Tracelet starts in stationary mode and waits for its motion detector to
promote it before sampling GPS at full rate. Pressing "Start run" is an
explicit statement of intent, so a runner standing still at the trailhead
must already be recording rather than waiting to be noticed.

Also what makes the app testable on the iOS Simulator, which simulates
location but has no accelerometer, so the promotion never fires.
```

Bad: `fix: bug fixes and improvements` — unbisectable, unsearchable, useless
at the end of a `git blame`.

## 4. Present the plan, then stop

Show each proposed commit as `type(scope): summary` plus the files it covers.
Wait for approval before running `git commit`. Do not commit and then report.

## 5. Commit

Branch first if on `main` (`feat/…`, `fix/…`, `chore/…`, `docs/…`).

Stage precisely — `git add <paths>`, or `git add -p` when one file contains
changes belonging to different commits. Avoid a blanket `git add -A` unless the
whole tree really is one change.

The pre-commit hook runs `flutter analyze` and `flutter test` on any commit
touching Dart. Let it. If it fails, fix the code — never reach for
`--no-verify` on anything heading for `main`.

Verify each commit stands alone, since that is the whole point:

```bash
git log --oneline -n <count>
git status --short          # expect clean
```

Then open a PR into `main` rather than merging locally.
