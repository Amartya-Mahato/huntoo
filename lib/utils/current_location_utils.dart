import 'package:geolocator/geolocator.dart';
import 'package:huntoo/utils/permission_utils.dart';

class CurrentLocationUtils {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  // final List<_PositionItem> _positionItems = <_PositionItem>[];
  Future<Stream<Position>?> getCurrentLocationStream() async {
    final hasPermission = await PermissionsUtils().handlePermission();

    if (!hasPermission) {
      return null;
    }

    return _geolocatorPlatform.getPositionStream(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.bestForNavigation));

    // _updatePositionList(
    //   _PositionItemType.position,
    //   position.toString(),
    // );
  }
}
