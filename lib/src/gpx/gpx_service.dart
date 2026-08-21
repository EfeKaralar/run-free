// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:run_free/src/data/repositories/activity_repository.dart';
import 'package:run_free/src/domain/models/activity.dart';
import 'package:run_free/src/gpx/gpx_reader.dart';
import 'package:run_free/src/gpx/gpx_writer.dart';
import 'package:share_plus/share_plus.dart';

/// File-level GPX operations: writing an activity out to a shareable file, and
/// reading one back in.
///
/// Split from [GpxWriter]/[GpxReader] so those stay pure string-to-model
/// functions that unit tests can exercise without touching a filesystem or a
/// platform channel.
class GpxService {
  const GpxService({
    required this.repository,
    this.writer = const GpxWriter(),
    this.reader = const GpxReader(),
  });

  final ActivityRepository repository;
  final GpxWriter writer;
  final GpxReader reader;

  /// Writes [activity] to a temporary file and opens the system share sheet.
  ///
  /// The temporary directory is correct here rather than a permanent one: the
  /// canonical copy lives in the database, and this file exists only long
  /// enough for the user to send it somewhere.
  Future<void> exportActivity(Activity activity) async {
    // The history list holds activities without tracks, so re-read the full
    // record before exporting — otherwise the GPX comes out with no points.
    final full = activity.hasTrack
        ? activity
        : await repository.getActivity(activity.id);
    if (full == null) {
      throw const GpxParseException('That activity no longer exists.');
    }

    final directory = await getTemporaryDirectory();
    final file = File(p.join(directory.path, writer.filenameFor(full)));
    await file.writeAsString(writer.write(full));

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'application/gpx+xml')],
        subject: full.displayTitle,
      ),
    );
  }

  /// Prompts the user for a GPX file and saves it as a new activity.
  ///
  /// Returns the imported activity, or `null` if the user cancelled the picker.
  Future<Activity?> importActivity({double splitDistanceMeters = 1000}) async {
    final result = await FilePicker.pickFiles(
      // `any` rather than a `gpx` extension filter: on iOS a custom extension
      // filter greys out files that came from other apps, and on Android many
      // providers report GPX as octet-stream. Validation happens on parse.
      type: FileType.any,
      allowMultiple: false,
      withData: false,
    );

    final path = result?.files.singleOrNull?.path;
    if (path == null) return null;

    final file = File(path);
    if (!await file.exists()) {
      throw const GpxParseException('That file could not be read.');
    }

    final contents = await file.readAsString();
    final activity = reader.parse(
      contents,
      splitDistanceMeters: splitDistanceMeters,
    );

    await repository.saveActivity(activity);
    return activity;
  }
}
