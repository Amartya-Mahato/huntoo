import 'package:maplibre_gl/mapbox_gl.dart';

class Pin {
  Map<String, Object> _pin = {};

  Pin({required int id, required String name, required LatLng latLng}) {
    _pin = {
      "type": "Feature",
      "id": id,
      "geometry": {
        "type": "Point",
        "coordinates": [latLng.longitude, latLng.latitude]
      },
      "properties": {
        "name": name,
        "year": '23',
        "game": "pubg"
      },
    };
  }

  Map<String, Object> get pin => _pin;
}

class Pins {
  Map<String, Object> _pins = {};

  Pins({required List<Pin> pins}) {
    _pins = {
      "type": "FeatureCollection",
      "features": [...pins.map((e) => e.pin)]
    };
  }

  Map<String, Object> get pins => _pins;
}
