import 'package:flutter/material.dart';
import 'package:huntoo/widgets/maps/p_map.dart';

class MapProvider extends ChangeNotifier {
  late final PMap map;
  void set() {
    map = PMap(onMapCreated: (controller) {}, onStyleLoadedCallback: () {});
  }
}
