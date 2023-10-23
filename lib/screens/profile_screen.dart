import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          ColorFiltered(
            colorFilter: const ColorFilter.matrix(<double>[
              0.2126,
              0.7152,
              0.0722,
              0,
              0,
              0.2126,
              0.7152,
              0.0722,
              0,
              0,
              0.2126,
              0.7152,
              0.0722,
              0,
              0,
              0,
              0,
              0,
              1,
              0,
            ]),
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0, 0.55],
                    colors: [Colors.transparent, Colors.black87]),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: Image.asset(
                      'lib/assets/profile.png',
                    ).image),
              ),
              child: Container(
                height: height,
                width: width,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [
                        0,
                        0.40
                      ],
                      colors: [
                        Colors.transparent,
                        Color.fromARGB(228, 0, 0, 0)
                      ]),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: 11,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 180, left: 8, right: 8, bottom: 30),
                        child: Column(
                          children: [
                            SizedBox(
                              width: width - 80,
                              height: 35,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Online",
                                      style: GoogleFonts.firaCode(
                                          fontSize: 15, color: Colors.green),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                        color: Colors.white70,
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.mode_edit_rounded,
                                        )),
                                    // IconButton(
                                    //     onPressed: () {},
                                    //     icon: const Icon(
                                    //       Icons.person_off_sharp,
                                    //       color: Colors.red,
                                    //     )),
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.person_add_alt_1_rounded,
                                          color: Colors.green,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            Center(
                                child: Card(
                              color: Colors.transparent,
                              elevation: 5,
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 29, 29, 29),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(15.0),
                                width: width - 80,
                                height: 490,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                            radius: 34,
                                            backgroundImage: Image.asset(
                                              'lib/assets/profile.png',
                                            ).image),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Amartya Mahato",
                                                style: GoogleFonts.firaCode(
                                                    fontSize: 23,
                                                    textStyle:
                                                        const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                              ),
                                              Text(
                                                "ethic.dev",
                                                style: GoogleFonts.firaCode(
                                                  fontSize: 13,
                                                ),
                                              ),
                                              Text(
                                                "Joined - 10/08/2022",
                                                style: GoogleFonts.firaCode(
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 37, 37, 37),
                                          // gradient: LinearGradient(
                                          //   stops: [0.5, 1],
                                          //   colors: [
                                          //   const Color.fromARGB(
                                          //       255, 37, 37, 37),
                                          //   Colors.green
                                          // ]),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                "Completed   - 50",
                                                style:
                                                    GoogleFonts.firaCode(
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                "In Progress - 20",
                                                style:
                                                    GoogleFonts.firaCode(
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                "Helping     - 20",
                                                style:
                                                    GoogleFonts.firaCode(
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                "Planning    - 50",
                                                style:
                                                    GoogleFonts.firaCode(
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                "Paused      - 20",
                                                style:
                                                    GoogleFonts.firaCode(
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                "Dropped     - 20",
                                                style:
                                                    GoogleFonts.firaCode(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      " Mutual Friends",
                                      style: GoogleFonts.firaCode(
                                          fontSize: 17,
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Expanded(
                                      child: GridView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          itemCount: 10,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisSpacing: 30,
                                                  mainAxisSpacing: 20,
                                                  crossAxisCount: 3),
                                          itemBuilder: (context, index) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                    radius: 30,
                                                    backgroundImage:
                                                        Image.asset(
                                                      'lib/assets/profile1.png',
                                                    ).image),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  "Some Name",
                                                  style: GoogleFonts.firaCode(
                                                      fontSize: 11,
                                                      textStyle:
                                                          const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                ),
                                              ],
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 8, bottom: 8),
                      child: Container(
                          height: 90,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: Image.asset('lib/assets/banner.png')
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
                                    color: const Color.fromARGB(
                                        190, 255, 255, 255),
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
                    );
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
