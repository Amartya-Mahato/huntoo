import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huntoo/widgets/tooltips/planner_tooltips/planner_pin_tooltip.dart';
import 'package:maplibre_gl/mapbox_gl.dart';
import 'dart:developer';

import '../widgets/maps/p_map.dart';

enum PTools { none, pin, shape, connector }

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  late final MaplibreMapController _mapController;
  PTools tools = PTools.none;
  List<Symbol> pins = [];
  late final Offset centerPoint;
  late final Point<num> centerPointAsPoint;

  @override
  void initState() {
    super.initState();
  }

  void _onMapCreated(MaplibreMapController mapController) {
    _mapController = mapController;
    _mapController.onSymbolTapped.add(
      (argument) {
        showDialog(
            context: context,
            barrierColor: Colors.transparent,
            builder: (BuildContext ctx) {
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Dialog(
                  elevation: 10,
                  child: PlannerPinTolltip().getToolTip,
                ),
              );
            });
      },
    );
  }

  void _onStyleLoadedCallback() async {
    centerPoint = getCenterScreenPoint(context);
    centerPointAsPoint = Point<num>(centerPoint.dx, centerPoint.dy);

    final ByteData redFlagByte =
        await rootBundle.load('lib/assets/pins/red-flag-hint-pin.png');
    final Uint8List redFlagList = redFlagByte.buffer.asUint8List();
    await _mapController.addImage("red-flag", redFlagList);

    _mapController.onSymbolTapped.add((argument) {});
  }

  // void _onMapLongClickCallback(Point<double> point, LatLng coordinates) {}

  @override
  Widget build(BuildContext context) {
    final PMap map = PMap(
        onMapCreated: _onMapCreated,
        onStyleLoadedCallback: _onStyleLoadedCallback);
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                map,
                _shapeTools(),
                _pinTool(),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                      child: IconButton.filledTonal(
                          onPressed: () {
                            _toggleTools(desiredTool: PTools.connector);
                          },
                          icon: const Icon(Icons.polyline_rounded)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                      child: IconButton.filledTonal(
                          onPressed: () {
                            _toggleTools(desiredTool: PTools.shape);
                          },
                          icon: const Icon(Icons.shape_line)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                      child: IconButton.filledTonal(
                          onPressed: () {
                            _toggleTools(desiredTool: PTools.pin);
                          },
                          icon: const Icon(Icons.add_location_alt_rounded)),
                    ),
                  ]),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Visibility _shapeTools() {
    return Visibility(
      visible: PTools.shape == tools,
      child: Positioned(
        left: 0,
        bottom: 0,
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: IconButton.outlined(
                isSelected: false,
                highlightColor:
                    const Color.fromARGB(131, 238, 238, 238).withOpacity(0.5),
                tooltip: 'red flag',
                visualDensity: const VisualDensity(vertical: 3),
                onPressed: () async {




                  LatLng centerLatlng = await _mapController.toLatLng(centerPointAsPoint);
                 print('---------------${centerPoint.dx} -------------------${centerPoint.dy}');

                  Point<num> topLeft = Point<num>(
                      centerPoint.dx - 1, centerPoint.dy + 1);
                  Point<num> topRight = Point<num>(
                      centerPoint.dx + 1, centerPoint.dy + 1);
                  Point<num> bottomLeft = Point<num>(
                      centerPoint.dx - 1, centerPoint.dy - 1);
                  Point<num> bottomRight = Point<num>(
                      centerPoint.dx + 1, centerPoint.dy - 1);



                  LatLng topLeftLatLng = await _mapController.toLatLng(topLeft);
                  LatLng topRightLatLng =
                      await _mapController.toLatLng(topRight);
                  LatLng bottomLeftLatLng =
                      await _mapController.toLatLng(bottomLeft);
                  LatLng bottomRightLatLng =
                      await _mapController.toLatLng(bottomRight);

                  final ByteData circleByte =
                      await rootBundle.load('lib/assets/pins/circle.png');
                  final Uint8List circleList = circleByte.buffer.asUint8List();




                  await _mapController.addImageSource(
                      "green-circle",
                      circleList,
                      LatLngQuad(
                          topLeft: topLeftLatLng,
                          topRight: topRightLatLng,
                          bottomRight: bottomRightLatLng,
                          bottomLeft: bottomLeftLatLng));

                  await _mapController.addImageLayer('circle-layering', 'green-circle');
                  setState(() {});

                  // _mapController.addCircle(CircleOptions(
                  //   circleRadius: 40,
                  //   // circleBlur: 0.9,
                  //   circleOpacity: 0.2,
                  //   circleColor: 'red',
                  //   circleStrokeWidth: 0.5,
                  //   geometry: centerLatlng,
                  //   draggable: true,
                  // ));
                },
                icon: Icon(Icons.crop_square),
              )),
          Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: IconButton.outlined(
                isSelected: false,
                highlightColor:
                    const Color.fromARGB(131, 238, 238, 238).withOpacity(0.5),
                tooltip: 'yellow flag',
                visualDensity: const VisualDensity(vertical: 3),
                onPressed: () {},
                icon: Icon(Icons.circle_outlined),
              )),
          Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: IconButton.outlined(
                isSelected: false,
                highlightColor:
                    const Color.fromARGB(131, 238, 238, 238).withOpacity(0.5),
                tooltip: 'green flag',
                visualDensity: const VisualDensity(vertical: 3),
                onPressed: () {},
                icon: Icon(Icons.polyline_rounded),
              )),
        ]),
      ),
    );
  }

  Visibility _pinTool() {
    return Visibility(
      visible: PTools.pin == tools,
      child: Positioned(
        left: 0,
        bottom: 0,
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: IconButton.outlined(
                isSelected: false,
                highlightColor:
                    const Color.fromARGB(131, 238, 238, 238).withOpacity(0.5),
                tooltip: 'red flag',
                visualDensity: const VisualDensity(vertical: 3),
                onPressed: () {
                  _putPin(name: 'red-flag');
                },
                icon: Image.asset(
                  'lib/assets/pins/red-flag-hint-pin.png',
                  height: 30,
                  width: 30,
                ),
              )),
          Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: IconButton.outlined(
                isSelected: false,
                highlightColor:
                    const Color.fromARGB(131, 238, 238, 238).withOpacity(0.5),
                tooltip: 'yellow flag',
                visualDensity: const VisualDensity(vertical: 3),
                onPressed: () {},
                icon: Image.asset(
                  'lib/assets/pins/red-flag-hint-pin.png',
                  height: 30,
                  width: 30,
                ),
              )),
          Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: IconButton.outlined(
                isSelected: false,
                highlightColor:
                    const Color.fromARGB(131, 238, 238, 238).withOpacity(0.5),
                tooltip: 'green flag',
                visualDensity: const VisualDensity(vertical: 3),
                onPressed: () {},
                icon: Image.asset(
                  'lib/assets/pins/red-flag-hint-pin.png',
                  height: 30,
                  width: 30,
                ),
              )),
          Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: IconButton.outlined(
                isSelected: false,
                highlightColor:
                    const Color.fromARGB(131, 238, 238, 238).withOpacity(0.5),
                tooltip: 'blue flag',
                visualDensity: const VisualDensity(vertical: 3),
                onPressed: () {},
                icon: Image.asset(
                  'lib/assets/pins/red-flag-hint-pin.png',
                  height: 30,
                  width: 30,
                ),
              )),
        ]),
      ),
    );
  }

  void _toggleTools({PTools desiredTool = PTools.none}) {
    setState(() {
      if (tools != PTools.none) {
        tools = PTools.none;
      } else {
        tools = desiredTool;
      }
    });
  }

  void _putPin({required String name}) async {
    LatLng centerLatlng = await _mapController.toLatLng(centerPointAsPoint);
    pins.add(Symbol(
        '${pins.length}',
        SymbolOptions(
            iconImage: name,
            iconSize: 0.2,
            textField: '',
            fontNames: ['Open Sans Regular'],
            draggable: true,
            textSize: 15,
            textOffset: const Offset(-0.6, 1.3),
            textHaloColor: 'grey',
            geometry: centerLatlng)));
    await _mapController.addSymbol(pins.last.options);
  }

  Offset getCenterScreenPoint(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final centerPoint = Offset(screenSize.width, screenSize.height);
    return centerPoint;
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
