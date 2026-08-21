// Copyright 2026 The Run Free Authors
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:run_free/src/core/map_tiles.dart';
import 'package:run_free/src/core/theme.dart';
import 'package:run_free/src/domain/models/track_point.dart';

/// Draws a recorded or in-progress route.
///
/// Used by both the live recording screen and the activity detail screen; the
/// difference is only whether [followCurrentPosition] is on.
class RouteMap extends StatefulWidget {
  const RouteMap({
    required this.points,
    this.tileProvider,
    this.followCurrentPosition = false,
    this.showCurrentPositionMarker = false,
    this.interactive = true,
    this.padding = const EdgeInsets.all(32),
    super.key,
  });

  final List<TrackPoint> points;

  /// Null until the cache directory has been resolved, in which case tiles come
  /// straight from the network.
  final TileProvider? tileProvider;

  /// Keep the newest point centred. On during recording, off when reviewing.
  final bool followCurrentPosition;

  final bool showCurrentPositionMarker;
  final bool interactive;

  /// Inset used when fitting a completed route, so the line never touches the
  /// edge of the widget.
  final EdgeInsets padding;

  @override
  State<RouteMap> createState() => _RouteMapState();
}

class _RouteMapState extends State<RouteMap> {
  final _controller = MapController();

  /// Set once the first fit has run, so later rebuilds do not yank the map back
  /// while the user is panning around their own route.
  bool _hasFittedBounds = false;

  @override
  void didUpdateWidget(RouteMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.points.isEmpty) return;

    if (widget.followCurrentPosition) {
      // Recording: keep the latest fix in view. Moving the camera rather than
      // refitting bounds means the zoom level the user chose is preserved.
      final latest = widget.points.last.latLng;
      _controller.move(latest, _controller.camera.zoom);
    } else if (!_hasFittedBounds &&
        oldWidget.points.length != widget.points.length) {
      // Reviewing: frame the whole route once, when it first arrives.
      _fitBounds();
    }
  }

  void _fitBounds() {
    if (widget.points.length < 2) return;
    final bounds = LatLngBounds.fromPoints(
      widget.points.map((p) => p.latLng).toList(growable: false),
    );
    _controller.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: widget.padding),
    );
    _hasFittedBounds = true;
  }

  @override
  Widget build(BuildContext context) {
    final points = widget.points;
    final latLngs = points.map((p) => p.latLng).toList(growable: false);

    // Somewhere neutral rather than 0,0 (which is in the Atlantic) for the
    // moment before the first fix arrives.
    final initialCenter = latLngs.isNotEmpty
        ? latLngs.last
        : const LatLng(51.5074, -0.1278);

    return FlutterMap(
      mapController: _controller,
      options: MapOptions(
        initialCenter: initialCenter,
        initialZoom: MapTiles.defaultZoom,
        minZoom: MapTiles.minZoom,
        maxZoom: MapTiles.maxZoom,
        interactionOptions: InteractionOptions(
          flags: widget.interactive
              ? InteractiveFlag.all & ~InteractiveFlag.rotate
              : InteractiveFlag.none,
        ),
        onMapReady: () {
          if (!widget.followCurrentPosition) _fitBounds();
        },
      ),
      children: [
        TileLayer(
          urlTemplate: MapTiles.osmUrlTemplate,
          userAgentPackageName: MapTiles.userAgentPackageName,
          tileProvider: widget.tileProvider,
          maxNativeZoom: MapTiles.maxZoom.toInt(),
        ),
        if (latLngs.length >= 2)
          PolylineLayer(
            polylines: [
              Polyline(
                points: latLngs,
                color: AppTheme.trackColor,
                strokeWidth: 5,
                // Rounded joins stop the line looking spiky on switchbacks.
                strokeCap: StrokeCap.round,
                strokeJoin: StrokeJoin.round,
              ),
            ],
          ),
        if (latLngs.isNotEmpty)
          MarkerLayer(
            markers: [
              if (latLngs.length >= 2 && !widget.followCurrentPosition)
                _endpointMarker(latLngs.first, Colors.green.shade600, 'Start'),
              if (widget.showCurrentPositionMarker)
                _currentPositionMarker(latLngs.last)
              else if (latLngs.length >= 2)
                _endpointMarker(latLngs.last, Colors.red.shade600, 'Finish'),
            ],
          ),
        RichAttributionWidget(
          // Attribution is a licence condition of OpenStreetMap data, not a
          // nicety. It stays on screen.
          attributions: [
            TextSourceAttribution(MapTiles.attribution, onTap: () {}),
          ],
        ),
      ],
    );
  }

  Marker _endpointMarker(LatLng position, Color color, String tooltip) {
    return Marker(
      point: position,
      width: 18,
      height: 18,
      child: Tooltip(
        message: tooltip,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
          ),
        ),
      ),
    );
  }

  Marker _currentPositionMarker(LatLng position) {
    return Marker(
      point: position,
      width: 26,
      height: 26,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 6,
            ),
          ],
        ),
      ),
    );
  }
}
