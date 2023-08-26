import 'package:syncfusion_flutter_maps/maps.dart';

class DMap {
  static SfMaps get(
          {MapLatLng initialFocalLatLng = const MapLatLng(0.0, 0.0),
          required MapZoomPanBehavior mapZoomPanBehavior,
          required MapTileLayerController mapTileLayerController}) =>
      SfMaps(
        layers: [
          MapTileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            zoomPanBehavior: mapZoomPanBehavior,
            initialFocalLatLng: initialFocalLatLng,
            initialZoomLevel: 15,
            controller: mapTileLayerController,
          )
        ],
      );
}
