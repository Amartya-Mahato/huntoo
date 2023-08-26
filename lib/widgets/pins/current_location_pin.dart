import 'package:flutter/material.dart';
import 'package:huntoo/widgets/pins/pin.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class CurrentLocationPin extends Pin {
  final double latitude;
  final double longitude;
  const CurrentLocationPin({required this.latitude, required this.longitude});

  MapMarker get getPin => MapMarker(
        latitude: latitude,
        longitude: longitude,
        iconType: MapIconType.triangle,
        size: const Size(18, 18),
        alignment: Alignment.center,
        offset: const Offset(0, 9),
        iconColor: Colors.red[200],
        iconStrokeColor: Colors.red[900],
        iconStrokeWidth: 2,
      );
}
