import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huntoo/widgets/tooltips/planner_tooltips/planner_pin_tooltip.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class PMap {
  static SfMaps get(
          {MapLatLng initialFocalLatLng = const MapLatLng(0.0, 0.0),
          required MapZoomPanBehavior mapZoomPanBehavior,
          required MapTileLayerController mapTileLayerController,
          required List<MapMarker> markers}) =>
      SfMaps(
        layers: [
          MapTileLayer(
            initialMarkersCount: 1,
            markerBuilder: (context, index) {
              return markers[index];
            },
            markerTooltipBuilder: (context, index) {
              return PlannerPinTolltip().toolTip;
            },
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            zoomPanBehavior: mapZoomPanBehavior,
            initialFocalLatLng: initialFocalLatLng,
            initialZoomLevel: 15,
            controller: mapTileLayerController,
          ),
        ],
      );
}
