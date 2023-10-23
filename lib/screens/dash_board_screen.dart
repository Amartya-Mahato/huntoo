import 'dart:developer';

import 'package:chart_sparkline/chart_sparkline.dart';
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
    // final PMap map = PMap(
    //   onMapCreated: (controller) {},
    //   onStyleLoadedCallback: () {},
    // );

    return Scaffold(
        extendBody: true,
        drawer: const Drawer(),
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            'Dashboard',
            style:
                GoogleFonts.firaCode(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        body: SizedBox(
          height: height,
          width: width,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 8, bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 8.0,
                              bottom: 8.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage:
                                          Image.asset("lib/assets/profile2.png")
                                              .image,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Some Name",
                                          style: GoogleFonts.firaCode(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "12/05/2023",
                                          style: GoogleFonts.firaCode(
                                              fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                  width: 80,
                                  child: Sparkline(
                                    fillMode: FillMode.below,
                                    useCubicSmoothing: true,
                                    cubicSmoothingFactor: 0.2,
                                    lineColor: Colors.green.shade900,
                                    fillGradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color.fromARGB(255, 42, 146, 48),
                                        Color.fromARGB(0, 0, 0, 0)
                                      ],
                                    ),
                                    data: const [
                                      1.0,
                                      0.0,
                                      30.5,
                                      30.0,
                                      4.0,
                                      50.0,
                                      -0.5,
                                      -1.0,
                                      -0.5,
                                      -30,
                                      10.0
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            constraints: const BoxConstraints(
                                maxHeight: 150, minHeight: 70),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 37, 37, 37),
                                borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: Image.asset(
                                                    'lib/assets/banner.png')
                                                .image,
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              153, 0, 0, 0),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: ListTile(
                                        dense: true,
                                        onTap: () {
                                          Navigator.of(context)
                                              .pushNamed('thread');
                                        },
                                        leading: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '12',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.firaCode(
                                                color: const Color.fromARGB(
                                                    223, 255, 255, 255),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                            Text(
                                              'Threads',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.firaCode(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                        title: Text(
                                          "Many desktop publishing packages and web page editors now use Lorem",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.firaCode(
                                              textStyle: const TextStyle(
                                                  color: Color.fromARGB(
                                                      223, 255, 255, 255),
                                                  wordSpacing: 0.3,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        subtitle: Text(
                                          'Many desktop publishing packages and web page editors now use Lorem Many desktop publishing packages and web page editors now use Lorem',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 4,
                                          style: GoogleFonts.firaCode(
                                              color: const Color.fromARGB(
                                                  204, 255, 255, 255),
                                              wordSpacing: 0.1),
                                        ),
                                      ),
                                    )),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8),
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 35,
                                        width: 30,
                                        child: Icon(
                                          Icons.notification_add_rounded,
                                          color: Colors.amber.shade600,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.only(),
                                        height: 35,
                                        child: ListView.builder(
                                            itemCount: 4,
                                            shrinkWrap: true,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Container(
                                                  height: 30,
                                                  alignment: Alignment.center,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10, right: 10),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 28, 170, 0),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: Text(
                                                    "open",
                                                    style: GoogleFonts.firaCode(
                                                        fontSize: 13),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
