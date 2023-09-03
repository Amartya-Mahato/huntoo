import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:maplibre_gl/mapbox_gl.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MaplibreMap map = MaplibreMap(
      trackCameraPosition: true,
      onMapCreated: (controller) async {
        // var val = await controller.requestMyLocationLatLng();
        // log('${val?.latitude} - ${val?.longitude}');
      },
      compassEnabled: true,
      styleString:
          'https://tiles.stadiamaps.com/styles/osm_bright.json?api_key=f71741e6-1bcc-4544-ae46-d322e43419a8',
      initialCameraPosition: const CameraPosition(
        target: LatLng(12.877015, 77.601627),
        zoom: 11.0,
      ),
      myLocationEnabled: true,
      myLocationRenderMode: MyLocationRenderMode.GPS,
      myLocationTrackingMode: MyLocationTrackingMode.TrackingCompass,
      onUserLocationUpdated: (location) {
        log(
            "new location: ${location.position}, alt.: ${location.altitude}, bearing: ${location.bearing}, speed: ${location.speed}, horiz. accuracy: ${location.horizontalAccuracy}, vert. accuracy: ${location.verticalAccuracy}");
      },
    );
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
            // PMap(onMapCreated: (controller) {}, onStyleLoadedCallback: () {}),
            map,
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
    super.dispose();
  }
}
