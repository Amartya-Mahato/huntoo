import 'package:flutter/material.dart';
import 'package:maplibre_gl/mapbox_gl.dart';

class PMap extends StatelessWidget {
  ValueSetter<MaplibreMapController> onMapCreated;
  ValueGetter<void>? onStyleLoadedCallback;
  bool currentLocation;
  PMap(
      {super.key,
      this.currentLocation = false,
      required this.onMapCreated,
      required this.onStyleLoadedCallback});

  @override
  Widget build(BuildContext context) {
    return MaplibreMap(
      styleString:
          'https://tiles.stadiamaps.com/styles/osm_bright.json?api_key=f71741e6-1bcc-4544-ae46-d322e43419a8',
      onMapCreated: onMapCreated,
      trackCameraPosition: true,
      onStyleLoadedCallback: onStyleLoadedCallback,
      initialCameraPosition: const CameraPosition(
        target: LatLng(12.877015, 77.601627),
        zoom: 11.0,
      ),
      myLocationEnabled: true,
      myLocationRenderMode: MyLocationRenderMode.COMPASS,
      myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
      onUserLocationUpdated: (location) {},
    );
  }
}
