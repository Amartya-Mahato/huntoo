import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:huntoo/utils/permission_utils.dart';
import 'package:huntoo/widgets/maps/p_map.dart';
import 'package:maplibre_gl/mapbox_gl.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  void initState() {
    PermissionsUtils().handlePermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PMap map =
        PMap(onMapCreated: (controller) {}, onStyleLoadedCallback: () {});
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
