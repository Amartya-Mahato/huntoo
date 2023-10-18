import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateDraftToggle extends StatefulWidget {
  const CreateDraftToggle({super.key, required this.toggle});
  final ValueSetter<bool> toggle;

  @override
  State<CreateDraftToggle> createState() => _CreateDraftToggleState();
}

class _CreateDraftToggleState extends State<CreateDraftToggle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1, 0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  ));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 35,
          width: 200,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(255, 61, 61, 61)),
          child: Stack(
            children: [
              SlideTransition(
                position: _offsetAnimation,
                child: Container(
                  width: 100,
                  height: 35,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 163, 109, 7),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      _controller
                          .animateBack(0,
                              duration: const Duration(milliseconds: 200))
                          .whenComplete(() {
                        widget.toggle(true);
                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, bottom: 8.0, left: 25, right: 25),
                          child: Text(
                            'Create',
                            style: GoogleFonts.montserrat(
                                fontSize: 15,
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ),
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      _controller.forward().whenComplete(() {
                        widget.toggle(false);
                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
