import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../widgets/maps/d_map.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  late final MapTileLayerController _mapTileLayerController;
  late final MapZoomPanBehavior _mapZoomPanBehavior;
  @override
  void initState() {
    _mapTileLayerController = MapTileLayerController();
    _mapZoomPanBehavior = MapZoomPanBehavior(
      enableMouseWheelZooming: true,
      enableDoubleTapZooming: true,
      zoomLevel: 15,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(
          'Huntoo!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: DMap.get(
                  initialFocalLatLng: const MapLatLng(12.874383, 77.602238),
                  mapZoomPanBehavior: _mapZoomPanBehavior,
                  mapTileLayerController: _mapTileLayerController),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, -2),
                        color: Colors.deepPurple.shade300,
                        blurRadius: 7,
                        spreadRadius: 2,
                      )
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {}, child: const Text('Join')),
                      ElevatedButton(
                          onPressed: () {}, child: const Text('Find')),
                      ElevatedButton(
                          onPressed: () {}, child: const Text('Stats')),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapTileLayerController.dispose();
    super.dispose();
  }
}
