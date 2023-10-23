import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThreadScreen extends StatefulWidget {
  const ThreadScreen({super.key});

  @override
  State<ThreadScreen> createState() => _ThreadScreenState();
}

class _ThreadScreenState extends State<ThreadScreen> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: height / 4,
            width: width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: Image.asset('lib/assets/banner.png').image,
                  fit: BoxFit.cover),
            ),
            child: Container(
              width: width,
              alignment: Alignment.bottomCenter,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.6, 1],
                    colors: [Colors.black26, Color.fromARGB(255, 0, 0, 0)]),
              ),
            ),
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.fast),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                padding: EdgeInsets.only(left: 15, right: 15, top: height / 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Many desktop publishing packages and web page editors now use Lorem",
                      style: GoogleFonts.firaCode(
                          textStyle: const TextStyle(
                              color: Color.fromARGB(223, 255, 255, 255),
                              wordSpacing: 0.3,
                              fontSize: 20,
                              shadows: [
                                Shadow(
                                  color: Colors.black87,
                                  offset: Offset(0, 1),
                                  blurRadius: 4,
                                )
                              ],
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 35,
                            width: 30,
                            child: Icon(
                              Icons.notification_add_rounded,
                              shadows: const [
                                Shadow(
                                    color: Colors.black87,
                                    offset: Offset(0, 1),
                                    blurRadius: 2)
                              ],
                              color: Colors.amber.shade600,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(),
                              height: 35,
                              child: ListView.builder(
                                  itemCount: 4,
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        height: 30,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        decoration: BoxDecoration(
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.black87,
                                                  offset: Offset(0, 1),
                                                  blurRadius: 2)
                                            ],
                                            color: const Color.fromARGB(
                                                255, 28, 170, 0),
                                            borderRadius:
                                                BorderRadius.circular(20)),
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
                    ),
                    ExpansionTile(
                      collapsedIconColor: Colors.green.shade600,
                      collapsedTextColor: Colors.green.shade600,
                      title: Text('Description',
                          style: GoogleFonts.firaCode(
                              fontSize: 16,
                              shadows: [
                                const Shadow(
                                  color: Colors.black87,
                                  offset: Offset(0, 1),
                                  blurRadius: 4,
                                )
                              ],
                              wordSpacing: 0.1)),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: CarouselSlider.builder(
                              itemCount: 4,
                              itemBuilder: ((context, index, realIndex) {
                                return Container(
                                  height: 200,
                                  width: 400,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: Image.asset(
                                                  "lib/assets/profile$index.png")
                                              .image)),
                                );
                              }),
                              options: CarouselOptions(
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 5),
                                autoPlayAnimationDuration:
                                    Duration(milliseconds: 500),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeCenterPage: true,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Text(
                            '''Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam molestie convallis arcu id fermentum. Fusce sagittis scelerisque lacinia. Nam est sem, blandit eu tortor eget, faucibus finibus tortor. In sagittis laoreet nunc ultricies porttitor. Praesent euismod nisi vel nibh fermentum tincidunt. Suspendisse sit amet massa eu felis suscipit elementum at id magna. Etiam pulvinar finibus tellus quis malesuada. Maecenas at porttitor ipsum, at iaculis ipsum.
                                          
                                              Nunc dolor mauris, feugiat posuere elementum at, ultrices sed ante. In placerat orci vel arcu lobortis efficitur. Ut ut lacinia est. Morbi ullamcorper euismod porta. Nulla vitae elit vitae ex sodales tristique. Praesent consequat sem est, at porttitor erat ultrices eu. Ut porttitor accumsan volutpat. Etiam maximus consectetur vulputate. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.
                                              
                                              Vivamus vitae hendrerit risus, ut auctor mi. Maecenas rutrum congue tellus vel tempor. Aliquam id erat malesuada, auctor ipsum in, lacinia quam. Mauris elementum orci sit amet tellus luctus consectetur. Cras et ligula convallis, blandit sapien quis, vestibulum turpis. Fusce egestas a augue ut bibendum. Phasellus consequat nunc at ultricies bibendum. Vestibulum nibh lectus, volutpat quis nisl id, volutpat fringilla massa. Integer cursus ligula vitae dui sollicitudin feugiat. Nullam quis tellus ligula. Nullam tempor pulvinar consectetur. Duis vestibulum mollis tempor. Duis finibus ornare ipsum sit amet faucibus. Nullam vulputate magna vitae mauris luctus eleifend. Donec ornare ante sodales, mattis tellus ac, cursus nisi. Morbi et sem sit amet dui vehicula ornare in eget quam.''',
                            style: GoogleFonts.firaCode(
                                fontSize: 14,
                                shadows: [
                                  const Shadow(
                                    color: Colors.black87,
                                    offset: Offset(0, 1),
                                    blurRadius: 4,
                                  )
                                ],
                                color: const Color.fromARGB(204, 255, 255, 255),
                                wordSpacing: 0.1),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Text(
                        "Helpers",
                        style: GoogleFonts.firaCode(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              const Shadow(
                                color: Colors.black87,
                                offset: Offset(0, 1),
                                blurRadius: 4,
                              )
                            ],
                            color: const Color.fromARGB(204, 255, 255, 255),
                            wordSpacing: 0.1),
                      ),
                    ),
                    SizedBox(
                      height: height - (height / 4),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: SizedBox(
                              height: height - (height / 4),
                              width: 10,
                              child: const VerticalDivider(
                                width: 10,
                                thickness: 10,
                                color: Color.fromARGB(255, 43, 43, 43),
                              ),
                            ),
                          ),
                          ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 20,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30, top: 20.0, bottom: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundImage: Image.asset(
                                                    "lib/assets/profile2.png")
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
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "12/05/2023",
                                                style: GoogleFonts.firaCode(
                                                    fontSize: 13),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 30,
                                        width: 90,
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
                                );
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
