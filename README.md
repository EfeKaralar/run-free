# Run Free

Free and open-source running, cycling and activity tracking for Android and iOS.
Your data stays on your device — unless you decide otherwise, and even then only
encrypted.

[![License](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](LICENSE)

## Why

Most activity trackers are free because your training log is the product. Run
Free has no analytics, no advertising and no third-party tracking — not now, not
later, not as an opt-in.

Activities are recorded to a local SQLite database on your device. There is no
account, and today nothing is uploaded anywhere: map tiles are the only network
request the app makes.

Cloud sync is planned, and it will be strictly opt-in. If you choose to create
an account, activities are encrypted on your device *before* they are uploaded,
so whoever holds the data — us included — stores something they cannot read. You
pick the destination, and Run Free will always remain fully usable without an
account.

## Status

Early development. The recording engine, storage layer and GPX import/export
work; expect rough edges elsewhere.

### Working

- Background GPS recording for runs, rides, walks and hikes
- Live map, distance, duration, pace/speed and elevation gain
- Automatic kilometre or mile splits
- Activity history and detail views
- GPX export and import
- Metric and imperial units

### Not yet

- Encrypted storage and optional sync to a server of your choice — see [Roadmap](#roadmap)
- Heart-rate sensors, training plans, intervals
- A tile source suitable for release builds — see [Before you ship](#before-you-ship)

## Getting started

Requires the Flutter SDK (3.44+), Android SDK 26+ or iOS 14+.

```bash
git clone https://github.com/<you>/run_free.git
cd run_free
flutter pub get
dart run build_runner build     # generates the Drift database code
flutter run
```

`build_runner` must run after any change to `lib/src/data/database/database.dart`.

### Tests

```bash
flutter test
flutter analyze
```

The domain logic — distance, pace, splits, GPX parsing — is pure Dart and
tested without a device or an emulator.

## Architecture

```text
lib/src/
  core/         Formatting, units, theme, tile configuration
  domain/       Models and services. Pure Dart, no Flutter or plugin types
    models/       Activity, TrackPoint, ActivityStats, ActivityLap
    services/     StatsCalculator, LocationTracker interface
  data/         Persistence
    database/     Drift schema
    repositories/ ActivityRepository interface + Drift implementation
  features/     One directory per screen, with its controller
  gpx/          GPX reading and writing
  providers.dart  The Riverpod provider graph
```

Two boundaries carry most of the design weight:

**`ActivityRepository`** is the only door between the app and stored data.
Nothing above it knows SQLite exists. Encryption and sync arrive as
implementations behind this interface rather than as changes throughout the UI.

**`LocationTracker`** is the only door to the platform's geolocation. Tracelet
sits behind it, which keeps the recording logic testable with a fake tracker and
means the geolocation engine could be replaced without touching a screen.

Domain models are plain Dart and deliberately independent of both Drift's
generated row classes and Tracelet's `Location`. Translation happens at the
edges.

### Why these dependencies

| Concern | Choice | Reason |
| --- | --- | --- |
| Background location | [Tracelet](https://tracelet.ikolvi.com/) (Apache-2.0) | Motion-detection driven, keeps GPS off while stationary |
| State | [Riverpod](https://riverpod.dev/) (MIT) | Maps cleanly onto Tracelet's streams; testable without widgets |
| Storage | [Drift](https://drift.simonbinder.eu/) (MIT) | Typed SQL, real migrations, and a supported encryption path |
| Maps | [flutter_map](https://docs.fleaflet.dev/) (BSD-3) | Pure Dart, no platform views, any tile source, no vendor lock-in |
| Tile cache | [flutter_map_cache](https://pub.dev/packages/flutter_map_cache) (MIT) | See the note below |

`flutter_map_tile_caching` is the better-known offline-tile package and is
deliberately **not** used: it is GPL-3.0, which would make the combined binary
GPL-3.0 and conflict with App Store distribution terms regardless of this
project's own licence.

## Before you ship

`lib/src/core/map_tiles.dart` currently points at OpenStreetMap's public tile
servers. That is fine for development and **not acceptable for a release
build** — the [OSMF tile usage policy](https://operations.osmfoundation.org/policies/tiles/)
prohibits distributing an app that hits them by default, because those are
donated servers sized for osm.org rather than for every downstream app's users.

Before publishing, change that one file to use a self-hosted tile server, a
provider free tier, or bundled offline tiles.

## Roadmap

The next significant piece of work is giving users real ownership of their data
without giving up convenience:

1. Encrypt activity data at rest, using Drift's SQLite3MultipleCiphers support.
2. Add end-to-end encryption for anything that leaves the device, so the storage
   host — whoever it is — cannot read it.
3. Add an **optional** account, so users who want their history on more than one
   device can have it. The app stays fully functional without one.
4. Let users choose where encrypted data lives: our hosted service, a cloud
   provider of their choice, or their own machine.

The repository boundary described above exists so this lands behind
`ActivityRepository` rather than as a rewrite.

## Privacy

### Today

- No telemetry, no analytics, no crash reporting, no advertising IDs.
- No account. Activities are stored only in the app's private database on your
  device.
- Network requests are limited to map tiles from the configured tile server.
- Location permissions are requested only when you start recording. Background
  ("all the time") access is what keeps recording working with the screen off;
  the app still works without it, but your track will have gaps.

### When sync ships

- Creating an account will be optional. Recording, history and GPX export will
  keep working exactly as they do now without one.
- Activities are encrypted on-device before upload, and the keys stay on your
  device, so the host cannot read what it stores.
- You choose where encrypted data lives: our hosted service, a cloud provider of
  your choice, or your own server.
- Sync does not bring analytics with it. Sending your own data to a destination
  you picked is not the same as us collecting it, and the first list above stays
  true either way.

## Contributing

Contributions are welcome. The project is Apache-2.0, so contributions are
accepted under those terms and no CLA is required.

### Setup

After cloning, enable the shared git hooks once:

```bash
git config core.hooksPath tooling/git-hooks
```

That installs a pre-commit hook running `flutter analyze` and `flutter test` on
any commit touching Dart, so every commit on `main` is green and `git bisect`
stays usable. `.git/hooks` is not versioned, which is why this step is manual.

### Conventions

- **Conventional Commits**: `feat(scope): summary`, plus a body explaining
  *why* for anything non-trivial.
- **One logical change per commit.** Never mix a refactor with a behaviour
  change, or a bug fix with a feature — those are the splits that make history
  reviewable and revertable.
- **Branch and open a PR.** CI runs formatting, analysis and tests on every PR.
- Run `dart format .` before committing; CI rejects unformatted code.
- Logic that computes a number a user sees — distance, pace, elevation, splits
  — needs a test. Those are the numbers people compare against other apps.

## Licence

Copyright The Run Free Authors.

Licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE).

Map data © OpenStreetMap contributors, available under the
[Open Database License](https://www.openstreetmap.org/copyright).
