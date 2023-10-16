import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huntoo/widgets/maps/p_map.dart';

class CreateHuntMapScreen extends StatefulWidget {
  const CreateHuntMapScreen({super.key});

  @override
  State<CreateHuntMapScreen> createState() => _CreateHuntMapScreenState();
}

class _CreateHuntMapScreenState extends State<CreateHuntMapScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final PMap map = PMap(
      onMapCreated: (controller) {},
      onStyleLoadedCallback: () {},
    );

    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            Container(
              height: height,
              alignment: Alignment.center,
              child: map,
            ),
            Positioned(
                bottom: 0,
                child: Container(
                  height: 60,
                  width: width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 163, 109, 7),
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, bottom: 8.0, left: 25, right: 25),
                              child: Text(
                                'Tool 1',
                                style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ),
                            )),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 163, 109, 7),
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, bottom: 8.0, left: 25, right: 25),
                              child: Text(
                                'Tool 2',
                                style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ),
                            )),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
