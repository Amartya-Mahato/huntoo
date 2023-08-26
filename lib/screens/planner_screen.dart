import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:huntoo/utils/current_location_utils.dart';
import 'package:huntoo/widgets/tooltips/planner_tooltips/planner_pin_tooltip.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../utils/custom_zoom_pan_behavior.dart';
import '../widgets/maps/p_map.dart';
import '../widgets/tooltips/tooltip.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  late final MapTileLayerController _mapTileLayerController;
  late final MapZoomPanBehavior _mapZoomPanBehavior;
  List<MapMarker> markers = [];
  Stream<Position>? _currLoc;
  late Position position;
  List<MapLatLng> markersLatLng = [];
  @override
  void initState() {
    currentLocation();
    initMapController();
    super.initState();
  }

  currentLocation() async {
    _currLoc = (await CurrentLocationUtils().getCurrentLocationStream());
    _currLoc?.listen((event) {
      if (markers.isNotEmpty) {
        markers.removeAt(0);
      }
      markers.insert(
          0,
          MapMarker(
            latitude: event.latitude,
            longitude: event.longitude,
            iconType: MapIconType.triangle,
            size: const Size(18, 18),
            alignment: Alignment.center,
            offset: const Offset(0, 9),
            iconColor: Colors.red[200],
            iconStrokeColor: Colors.red[900],
            iconStrokeWidth: 2,
          ));
      _mapTileLayerController.removeMarkerAt(0);
      _mapTileLayerController.insertMarker(0);
      setState(() {});
    });
    setState(() {});
  }

  initMapController() {
    _mapTileLayerController = MapTileLayerController();
    _mapZoomPanBehavior = CustomZoomPanBehavior()
      ..zoomLevel = 15
      ..maxZoomLevel = 19
      ..enableDoubleTapZooming = false
      ..minZoomLevel = 4
      ..onTap = updateMarkerChange;
  }

  void updateMarkerChange(Offset position) {
    MapLatLng latLng = _mapTileLayerController.pixelToLatLng(position);
    markers.add(MapMarker(

      latitude: latLng.latitude,
      longitude: latLng.longitude,
      child: const Text(
        'hint',
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple),
      ),
    ));
    _mapTileLayerController.insertMarker(1);
    _mapTileLayerController.updateMarkers(
        [for (int i = 1; i < _mapTileLayerController.markersCount; i++) i]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: _currLoc == null
                ? const Center(child: CircularProgressIndicator())
                : StreamBuilder(
                    stream: _currLoc,
                    builder: (context, snapshot) {
                      if (snapshot.data == null || !snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return Stack(
                        children: [
                          PMap.get(
                              initialFocalLatLng: MapLatLng(
                                  (snapshot.data as Position).latitude,
                                  (snapshot.data as Position).longitude),
                              mapZoomPanBehavior: _mapZoomPanBehavior,
                              mapTileLayerController: _mapTileLayerController,
                              markers: markers),
                          Positioned(
                              right: 0,
                              bottom: 0,
                              child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 8.0, bottom: 8.0),
                                  child: IconButton.filledTonal(
                                      onPressed: () {},
                                      icon: Icon(Icons.polyline_rounded)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 8.0, bottom: 8.0),
                                  child: IconButton.filledTonal(
                                      onPressed: () {},
                                      icon: Icon(Icons.shape_line)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 8.0, bottom: 8.0),
                                  child: IconButton.filledTonal(
                                      onPressed: () {},
                                      icon: const Icon(Icons.add_location_alt_rounded)),
                                ),
                              ]))
                        ],
                      );
                    }),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapTileLayerController.dispose();
    super.dispose();
  }
}
