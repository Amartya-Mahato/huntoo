import 'package:flutter/material.dart';
import 'package:huntoo/widgets/pins/pin.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class IntermediateTreasurePin extends Pin {
  final double latitude;
  final double longitude;
  const IntermediateTreasurePin({required this.latitude, required this.longitude});

  MapMarker get getPin => MapMarker(
    latitude: latitude,
    longitude: longitude,
    size: const Size(18, 18),
    alignment: Alignment.center,
    offset: const Offset(0, 9),
    //TODO: put intermediate treasure pin asset path
    child: Image.asset('name'),
  );
}
