import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huntoo/screens/create_hunt_map_screen.dart';
import 'package:huntoo/widgets/create/create_draft_toggle.dart';

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
            CreateDraftToggle(
              toggle: (tgl) {
                toggle = tgl;
                setState(() {});
              },
            ),
            Container(
              width: width,
              height: 50,
              alignment: Alignment.centerRight,
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) =>
                                const CreateHuntMapScreen())));
                  },
                  child: Container(
                    height: 30,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                              color: Color.fromARGB(255, 163, 109, 7),
                              offset: Offset(0, 0),
                              blurRadius: 5,
                              spreadRadius: 2)
                        ],
                        color: const Color.fromARGB(255, 163, 109, 7)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Create",
                          style: GoogleFonts.montserrat(fontSize: 15),
                        ),
                        const Icon(
                          Icons.add,
                          color: Color.fromARGB(193, 255, 255, 255),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            toggle
                ? Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 8, bottom: 8),
                          child: Container(
                              height: 90,
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
                : Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 8, bottom: 8),
                          child: Container(
                              height: 90,
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
                                            const Color.fromARGB(190, 255, 255, 255),
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
                  ),
          ],
        ),
      ),
    );
  }
}
