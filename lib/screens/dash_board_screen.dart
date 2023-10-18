import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final PMap map = PMap(
      onMapCreated: (controller) {},
      onStyleLoadedCallback: () {},
    );

    return Scaffold(
        extendBody: true,
        drawer: const Drawer(),
        appBar: AppBar(
          elevation: 0.0,
          title: const Text(
            'Huntoo!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: SizedBox(
          height: height,
          width: width,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Container(
                    height: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.black,
                    ),
                    child: map,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 8, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage:
                                Image.asset('lib/assets/banner.png').image,
                            foregroundImage:
                                Image.asset('lib/assets/banner.png').image,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Container(
                                height: 90,
                                width: width - 130,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                            Image.asset('lib/assets/banner.png')
                                                .image,
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Container(
                                  color: Colors.black45,
                                  child: ListTile(
                                    title: Text(
                                      "HUNT NAME",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 18,
                                          color:
                                              Color.fromARGB(190, 255, 255, 255),
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    subtitle: Text(
                                      "Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like)",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: GoogleFonts.montserrat(),
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
