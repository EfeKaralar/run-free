# Run Free — working agreements

FOSS running and cycling tracker. Flutter, Android + iOS only.
Apache-2.0. Local-first; optional end-to-end encrypted sync is planned.

## Commands

```bash
flutter pub get
dart run build_runner build          # after ANY change to database.dart
flutter analyze                      # must be clean before every commit
flutter test --timeout 60s           # always pass --timeout; see Testing
flutter run                          # iOS Simulator or a connected device
```

## Architecture

Two interfaces carry the design. Respect them.

- **`ActivityRepository`** (`lib/src/data/repositories/`) is the only door
  between the app and storage. Nothing above it may know SQLite exists.
  Planned at-rest encryption and cloud sync land *behind* this interface.
- **`LocationTracker`** (`lib/src/domain/services/`) is the only door to
  platform geolocation. Tracelet lives behind it. Anything Tracelet-shaped
  stays in `tracelet_location_tracker.dart`.

Domain models (`lib/src/domain/models/`) are plain Dart. They must not import
Drift row classes, Tracelet types, or Flutter widgets. Translation happens at
the edges only.

`lib/src/core/map_tiles.dart` is the single place tile sources are configured.

## Git conventions

**Conventional Commits.** `type(scope): summary` in the imperative, plus a body
explaining *why* for anything non-trivial. The body is what `git blame` gives a
reader in two years; "what" is already in the diff.

Types: `feat` `fix` `docs` `test` `refactor` `chore` `ci` `perf`.

**One logical change per commit.** Every commit must build, analyze clean, and
pass tests on its own — that is what makes `git bisect` and `git revert` work.

Never mix in one commit:
- a refactor with a behaviour change (the most important rule — a reviewer can
  verify "moved code, changed nothing" or "changed behaviour", not both at once)
- a bug fix with a feature
- documentation or formatting with logic

Aim for diffs under ~400 lines. Review effectiveness collapses past that.

**Feature branches + PRs.** Branch per unit of work (`feat/…`, `fix/…`,
`chore/…`), small commits on it, PR into `main`. `main` stays green.

**Propose before committing.** When a unit of work is done, show the proposed
commit split and messages and wait for approval. Do not batch a whole session
into one commit — see `19b9f16` for what that mistake looks like.

## Testing

Domain logic is pure Dart and tested without a device. Anything computing a
number the user sees — distance, pace, elevation, splits — needs a test.

**Always run `flutter test --timeout 60s`.** Without a timeout a hung widget
test spins for ten minutes and looks silent rather than failing.

**Never call `pumpAndSettle()` on a screen that can show a
`CircularProgressIndicator`.** Indeterminate spinners schedule frames forever,
so it cannot settle and the test hangs instead of failing. Pump a bounded
number of frames — see `test/features/history_screen_test.dart`.

Widget tests override providers with ready values (`overrideWithValue`) rather
than driving a live database. Storage is covered separately by repository
tests.

## Platform gotchas

- Tracelet starts **stationary** and waits for motion detection. `start()`
  calls `changePace(true)` because pressing Start is an explicit statement of
  intent. Do not remove this; without it the track stays empty.
- `rejectMockLocations` is `kReleaseMode`, never `true`. Hardcoding `true`
  silently drops every simulated fix and makes the app untestable off-device.
- `flutter_map` mutates the tile provider's `headers` map. Never pass a `const`
  map to it.
- Config changes only apply through `Tracelet.ready()`, so **hot restart**
  (`R`) after editing tracker config — hot reload will not pick them up.
- Android `minSdk` 26 and iOS 14.0 are floors set by Tracelet's native SDKs.

## Before release

`map_tiles.dart` points at OpenStreetMap's public tile servers. Their usage
policy forbids shipping an app that hits them by default. This must change to a
self-hosted server, a provider tier, or bundled tiles.

## Privacy copy

Analytics, advertising and third-party tracking are refused **unconditionally**.
"Nothing is uploaded" is scoped to **today**, because optional encrypted sync is
planned. Keep those two claims distinct in the README, the settings screen, and
the iOS permission strings — that last one is read by App Review, and fixing it
later costs a resubmission.
