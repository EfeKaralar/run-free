// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:http_cache_file_store/http_cache_file_store.dart';

/// Tile source configuration.
///
/// ## On the tile server
///
/// This points at OpenStreetMap's public tile servers, which is fine for
/// development but **is not acceptable for a released build**. The OSMF tile
/// usage policy (https://operations.osmfoundation.org/policies/tiles/)
/// explicitly prohibits distributing an app that hits them by default, because
/// the servers are donated infrastructure sized for osm.org, not for every
/// downstream app's users.
///
/// TODO: Before shipping, this must become one of:
///   * a self-hosted tile server or Protomaps archive;
///   * a provider free tier (Thunderforest, Stadia) with a key the user or the
///     project supplies;
///   * bundled offline tiles.
///
/// Keeping the choice behind this one class is what makes that a one-file
/// change rather than a hunt through every map widget.
abstract final class MapTiles {
  static const osmUrlTemplate =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  /// Sent as the User-Agent. OSM blocks requests that do not identify
  /// themselves, and doing so is basic courtesy toward any tile host.
  static const userAgentPackageName = 'com.runfree.app';

  static const attribution = '© OpenStreetMap contributors';
  static const attributionUrl = 'https://www.openstreetmap.org/copyright';

  static const minZoom = 3.0;
  static const maxZoom = 18.0;

  /// Zoom used when centring on the user with no route to frame yet.
  static const defaultZoom = 16.0;
}

/// Builds the cached tile provider.
///
/// Caching is not only a speed optimisation: re-requesting tiles the user has
/// already seen is exactly the behaviour tile-server operators ask apps not to
/// do, and on a run through the same neighbourhood every day it is pure waste.
TileProvider buildCachedTileProvider(String cacheDirectory) {
  return CachedTileProvider(
    store: FileCacheStore(cacheDirectory),
    // Tiles are effectively immutable for our purposes: OSM re-renders slowly
    // and a week-old tile is indistinguishable from a fresh one on a run map.
    maxStale: const Duration(days: 30),
    // No `headers` argument here, deliberately. TileLayer injects the
    // User-Agent into this map via `putIfAbsent` using userAgentPackageName,
    // so passing a `const` map throws "Cannot modify unmodifiable map" at
    // first paint. flutter_map's own docs are explicit that the headers map
    // must not be constant. The UA we want is produced automatically.
  );
}
