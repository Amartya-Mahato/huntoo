import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huntoo/screens/create_hunt_map_screen.dart';

class CreateHuntScreen extends StatefulWidget {
  const CreateHuntScreen({super.key});

  @override
  State<CreateHuntScreen> createState() => _CreateHuntScreenState();
}

class _CreateHuntScreenState extends State<CreateHuntScreen> {
  bool toggle = true;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
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
              padding: const EdgeInsets.all(4.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Container(
                  height: 35,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          toggle = true;
                          setState(() {});
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: toggle
                                    ? Color.fromARGB(255, 163, 109, 7)
                                    : Color.fromARGB(255, 61, 61, 61),
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, bottom: 8.0, left: 25, right: 25),
                              child: Text(
                                'Created',
                                style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ),
                            )),
                      ),
                      GestureDetector(
                        onTap: () {
                          toggle = false;
                          setState(() {});
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: !toggle
                                    ? Color.fromARGB(255, 163, 109, 7)
                                    : Color.fromARGB(255, 61, 61, 61),
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, bottom: 8.0, left: 25, right: 25),
                              child: Text(
                                'Draft',
                                style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            toggle
                ? Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: 90,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          Image.asset('lib/assets/banner.png')
                                              .image,
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(5)),
                              child: ListTile(
                                title: Text(
                                  "HUNT NAME",
                                  style: GoogleFonts.montserrat(fontSize: 18),
                                ),
                                subtitle: Text(
                                  "Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: GoogleFonts.montserrat(),
                                ),
                              )),
                        );
                      },
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: 90,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          Image.asset('lib/assets/banner.png')
                                              .image,
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(5)),
                              child: ListTile(
                                title: Text(
                                  "HUNT NAME",
                                  style: GoogleFonts.montserrat(fontSize: 18),
                                ),
                                subtitle: Text(
                                  "Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: GoogleFonts.montserrat(),
                                ),
                              )),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => CreateHuntMapScreen())));
        },
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white, width: 3),
              color: Color.fromARGB(255, 163, 109, 7)),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
