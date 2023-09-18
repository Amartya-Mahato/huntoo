import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huntoo/global/enums.dart';
import 'package:huntoo/providers/planner_history_provider/history_element.dart';
import 'package:huntoo/providers/planner_history_provider/planner_history_provider.dart';
import 'package:huntoo/widgets/tooltips/planner_tooltips/planner_pin_tooltip.dart';
import 'package:maplibre_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';

import '../widgets/maps/p_map.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  late final MaplibreMapController _mapController;
  PTools tools = PTools.none;
  List<Symbol> pins = [];
  List<String> elementIds = [];
  List<String> elementNames = [];
  List<String> redoElementNames = [];
  List<String> redoElementIds = [];
  List<HistoryElement> history = [];
  String lastShape = '';
  Offset? centerPoint;
  late final Point<num> centerPointAsPoint;
  late final Point<num> topLeft;
  late final Point<num> topRight;
  late final Point<num> bottomLeft;
  late final Point<num> bottomRight;
  bool shapeConfirmationVisibility = false;

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
                  insetAnimationDuration: const Duration(milliseconds: 50),
                  elevation: 10,
                  child: PlannerPinTolltip().getToolTip,
                ),
              );
            });
      },
    );
  }

  void _onStyleLoadedCallback() async {
    _centerTRBLPoints();
    final ByteData redFlagByte =
        await rootBundle.load('lib/assets/pins/placeholder.png');
    final Uint8List redFlagList = redFlagByte.buffer.asUint8List();
    await _mapController.addImage("red-flag", redFlagList);
    _mapController.onSymbolTapped.add((argument) {});
  }

  Circle? circle;

  @override
  Widget build(BuildContext context) {
    final PMap map = PMap(
        onMapCreated: _onMapCreated,
        onStyleLoadedCallback: _onStyleLoadedCallback);
    history = context.watch<PlannerHistoryProvider>().historyList;
    print('---> ${history.length}');
    return Scaffold(
      body: Stack(
        children: [
          map,
          // centerPoint != null
          //     ? Positioned(
          //         left: centerPoint!.dx - 525,
          //         top: centerPoint!.dy - 936,
          //         child: Container(
          //           width: 380,
          //           height: 380,
          //           decoration: BoxDecoration(
          //               color: Colors.transparent,
          //               shape: BoxShape.circle,
          //               border: Border.all(color: Colors.black54)),
          //           child: Container(),
          //         ),
          //       )
          //     : Container(),
          _historyPannel(context),
          _shapeTools(),
          _pinTool(),
          _tools(),
          _shapeConfirmationButtons(context)
        ],
      ),
    );
  }

  Visibility _historyPannel(BuildContext context) {
    return Visibility(
      visible: true,
      child: Positioned(
        top: 0,
        child: Container(
          height: 80,
          color: Colors.white,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 13),
          child: SizedBox(
            height: 30,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                itemCount: elementIds.length,
                reverse: true,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(201, 184, 184, 184),
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.all(5.0),
                      child: GestureDetector(
                        onTap: () async {
                          if (index != 0) {
                            for (int i = 0; i < index; i++) {
                              await _mapController.removeLayer(elementIds[i]);
                            }
                            elementIds.removeRange(0, index);
                            elementNames.removeRange(0, index);
                            setState(() {});
                          }
                        },
                        child: Row(
                          children: [
                            Text(
                              '${elementNames.length - index}.',
                              style: GoogleFonts.montserrat(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              elementNames[index],
                              style: GoogleFonts.montserrat(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }

  Visibility _shapeConfirmationButtons(BuildContext context) {
    return Visibility(
      visible: shapeConfirmationVisibility,
      child: Positioned(
          bottom: 0,
          width: 120,
          right: ((MediaQuery.of(context).size.width / 2) - 60),
          child: Container(
            width: 120,
            height: 50,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    shapeConfirmationVisibility = false;
                    setState(() {});
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.green),
                    child: const Icon(Icons.check),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    shapeConfirmationVisibility = false;
                    setState(() {});
                    if (lastShape.isNotEmpty) {
                      elementIds.remove(lastShape);
                      _mapController.removeLayer(lastShape);
                    }
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.red),
                    child: const Icon(Icons.cancel),
                  ),
                )
              ],
            ),
          )),
    );
  }

  Positioned _tools() {
    return Positioned(
      right: 0,
      bottom: 0,
      child: Column(children: [
        Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
            child: IconButton.outlined(
              isSelected: false,
              highlightColor:
                  const Color.fromARGB(131, 238, 238, 238).withOpacity(0.5),
              tooltip: 'undo',
              onPressed: () async {
                // _mapController.removeLayer(elementIds[0]);
                // redoElementIds.insert(0, elementIds[0]);
                // redoElementNames.insert(0, elementNames[0]);
                // elementIds.removeAt(0);
                // elementNames.removeAt(0);
                // shapeConfirmationVisibility = false;
                historyUndo();
                setState(() {});
              },
              icon: const Icon(Icons.undo_rounded),
            )),
        Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
            child: IconButton.outlined(
              isSelected: false,
              highlightColor:
                  const Color.fromARGB(131, 238, 238, 238).withOpacity(0.5),
              tooltip: 'redo',
              onPressed: () async {
                if (redoElementIds.isEmpty) {
                  // await _mapController.addImageLayer(
                  //     redoElementIds[0], redoElementIds[0]);
                  // elementIds.insert(0, redoElementIds[0]);
                  // elementNames.insert(0, redoElementNames[0]);
                  // redoElementIds.removeAt(0);
                  // redoElementNames.removeAt(0);
                  // shapeConfirmationVisibility = false;
                  historyRedo();
                  setState(() {});
                }
              },
              icon: const Icon(Icons.redo_rounded),
            )),
        Padding(
          padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
          child: IconButton.outlined(
              isSelected: false,
              tooltip: 'connector',
              highlightColor:
                  const Color.fromARGB(131, 238, 238, 238).withOpacity(0.5),
              onPressed: () {
                _toggleTools(desiredTool: PTools.connector);
              },
              icon: const Icon(Icons.polyline_rounded)),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
          child: IconButton.outlined(
              isSelected: false,
              tooltip: 'elementIds',
              highlightColor:
                  const Color.fromARGB(131, 238, 238, 238).withOpacity(0.5),
              onPressed: () {
                _toggleTools(desiredTool: PTools.shape);
              },
              icon: const Icon(Icons.shape_line)),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
          child: IconButton.outlined(
              isSelected: false,
              tooltip: 'pins',
              highlightColor:
                  const Color.fromARGB(131, 238, 238, 238).withOpacity(0.5),
              onPressed: () {
                _toggleTools(desiredTool: PTools.pin);
              },
              icon: const Icon(Icons.add_location_alt_rounded)),
        ),
      ]),
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
                tooltip: 'square',
                onPressed: () async {
                  if (!shapeConfirmationVisibility) {
                    await _putShapes(PShapes.square);
                  }
                },
                icon: const Icon(Icons.crop_square),
              )),
          Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: IconButton.outlined(
                isSelected: false,
                highlightColor:
                    const Color.fromARGB(131, 238, 238, 238).withOpacity(0.5),
                tooltip: 'circle',
                onPressed: () async {
                  if (!shapeConfirmationVisibility) {
                    await _putShapes(PShapes.circle);
                  }
                },
                icon: const Icon(Icons.circle_outlined),
              )),
          Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: IconButton.outlined(
                isSelected: false,
                highlightColor:
                    const Color.fromARGB(131, 238, 238, 238).withOpacity(0.5),
                tooltip: 'triangle',
                onPressed: () async {
                  await _putShapes(PShapes.triangle);
                },
                icon: const Icon(Icons.signal_cellular_4_bar_sharp),
              )),
          Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: IconButton.outlined(
                isSelected: false,
                highlightColor:
                    const Color.fromARGB(131, 238, 238, 238).withOpacity(0.5),
                tooltip: 'rectangle',
                onPressed: () async {
                  if (!shapeConfirmationVisibility) {
                    await _putShapes(PShapes.rectangle);
                  }
                },
                icon: const Icon(Icons.rectangle_outlined),
              )),
          Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: IconButton.outlined(
                isSelected: false,
                highlightColor:
                    const Color.fromARGB(131, 238, 238, 238).withOpacity(0.5),
                tooltip: 'polygon',
                onPressed: () async {
                  if (!shapeConfirmationVisibility) {
                    await _putShapes(PShapes.poly);
                  }
                },
                icon: const Icon(Icons.polyline_rounded),
              )),
        ]),
      ),
    );
  }

  Future<void> _putShapes(
    PShapes shape,
  ) async {
    LatLng topLeftLatLng = await _mapController.toLatLng(topLeft);
    LatLng topRightLatLng = await _mapController.toLatLng(topRight);
    LatLng bottomLeftLatLng = await _mapController.toLatLng(bottomLeft);
    LatLng bottomRightLatLng = await _mapController.toLatLng(bottomRight);
    double currZoom = _mapController.cameraPosition != null
        ? _mapController.cameraPosition!.zoom
        : 10;
    double minZoom = (currZoom - 2) <= 0 ? 0 : currZoom - 2;
    double maxZoom = currZoom + 3;

    // await _mapController.addCircle(CircleOptions(
    //     circleColor: 'red',
    //     geometry: topLeftLatLng,
    //     circleRadius: 5));
    // await _mapController.addCircle(CircleOptions(
    //     circleColor: 'red',
    //     geometry: topRightLatLng,
    //     circleRadius: 5));
    // await _mapController.addCircle(CircleOptions(
    //     circleColor: 'red',
    //     geometry: bottomLeftLatLng,
    //     circleRadius: 5));
    // await _mapController.addCircle(CircleOptions(
    //     circleColor: 'red',
    //     geometry: bottomRightLatLng,
    //     circleRadius: 5));
    // setState(() {});
    switch (shape) {
      case PShapes.circle:
        {
          final ByteData bytes =
              await rootBundle.load('lib/assets/pins/circle.png');
          final Uint8List uInt8Data = bytes.buffer.asUint8List();
          String sourceId = DateTime.now().microsecond.toString();
          elementIds.insert(0, sourceId);
          elementNames.insert(0, 'circle');
          lastShape = sourceId;
          await _mapController.addImageSource(
              sourceId,
              uInt8Data,
              LatLngQuad(
                  topLeft: topLeftLatLng,
                  topRight: topRightLatLng,
                  bottomRight: bottomRightLatLng,
                  bottomLeft: bottomLeftLatLng));

          await _mapController.addImageLayer(sourceId, sourceId,
              maxzoom: maxZoom, minzoom: minZoom);
          break;
        }
      case PShapes.square:
        {
          final ByteData bytes =
              await rootBundle.load('lib/assets/pins/square.png');
          final Uint8List uInt8Data = bytes.buffer.asUint8List();
          String sourceId = DateTime.now().microsecond.toString();
          elementIds.insert(0, sourceId);
          elementNames.insert(0, 'square');
          lastShape = sourceId;
          await _mapController.addImageSource(
              sourceId,
              uInt8Data,
              LatLngQuad(
                  topLeft: topLeftLatLng,
                  topRight: topRightLatLng,
                  bottomRight: bottomRightLatLng,
                  bottomLeft: bottomLeftLatLng));

          await _mapController.addImageLayer(sourceId, sourceId,
              maxzoom: maxZoom, minzoom: minZoom);
          break;
        }
      case PShapes.triangle:
        {
          final ByteData bytes =
              await rootBundle.load('lib/assets/pins/triangle.png');
          final Uint8List uInt8Data = bytes.buffer.asUint8List();
          String sourceId = DateTime.now().microsecond.toString();
          elementIds.insert(0, sourceId);
          elementNames.insert(0, 'triangle');
          lastShape = sourceId;
          await _mapController.addImageSource(
              sourceId,
              uInt8Data,
              LatLngQuad(
                  topLeft: topLeftLatLng,
                  topRight: topRightLatLng,
                  bottomRight: bottomRightLatLng,
                  bottomLeft: bottomLeftLatLng));

          await _mapController.addImageLayer(sourceId, sourceId,
              maxzoom: maxZoom, minzoom: minZoom);
          break;
        }
      case PShapes.rectangle:
        {
          final ByteData bytes =
              await rootBundle.load('lib/assets/pins/square.png');
          final Uint8List uInt8Data = bytes.buffer.asUint8List();
          String sourceId = DateTime.now().microsecond.toString();
          elementIds.insert(0, sourceId);
          elementNames.insert(0, 'rectangle');
          lastShape = sourceId;
          await _mapController.addImageSource(
              sourceId,
              uInt8Data,
              LatLngQuad(
                  topLeft: topLeftLatLng,
                  topRight: topRightLatLng,
                  bottomRight: bottomRightLatLng,
                  bottomLeft: bottomLeftLatLng));

          await _mapController.addImageLayer(sourceId, sourceId,
              maxzoom: maxZoom, minzoom: minZoom);
          break;
        }
      case PShapes.poly:
        {
          final ByteData bytes =
              await rootBundle.load('lib/assets/pins/circle.png');
          final Uint8List uInt8Data = bytes.buffer.asUint8List();
          String sourceId = DateTime.now().microsecond.toString();
          elementIds.insert(0, sourceId);
          elementNames.insert(0, 'poly');
          lastShape = sourceId;
          await _mapController.addImageSource(
              sourceId,
              uInt8Data,
              LatLngQuad(
                  topLeft: topLeftLatLng,
                  topRight: topRightLatLng,
                  bottomRight: bottomRightLatLng,
                  bottomLeft: bottomLeftLatLng));

          await _mapController.addImageLayer(sourceId, sourceId,
              maxzoom: maxZoom, minzoom: minZoom);
          break;
        }
      default:
    }
    shapeConfirmationVisibility = true;
    setState(() {});
  }

  void _centerTRBLPoints() {
    centerPoint = getCenterScreenPoint(context);
    centerPointAsPoint = Point<num>(centerPoint!.dx, centerPoint!.dy);
    topLeft = Point<num>(centerPoint!.dx - 400, centerPoint!.dy - 400);
    topRight = Point<num>(centerPoint!.dx + 400, centerPoint!.dy - 400);
    bottomLeft = Point<num>(centerPoint!.dx - 400, centerPoint!.dy + 400);
    bottomRight = Point<num>(centerPoint!.dx + 400, centerPoint!.dy + 400);
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
                //visualDensity: const VisualDensity(vertical: 3),
                onPressed: () {
                  _putPin(name: 'red-flag');
                },
                icon: Image.asset(
                  'lib/assets/pins/placeholder.png',
                  height: 40,
                  width: 40,
                ),
              )),
          // Padding(
          //     padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          //     child: IconButton.outlined(
          //       isSelected: false,
          //       highlightColor:
          //           const Color.fromARGB(131, 238, 238, 238).withOpacity(0.5),
          //       tooltip: 'yellow flag',
          //       visualDensity: const VisualDensity(vertical: 3),
          //       onPressed: () {},
          //       icon: Image.asset(
          //         'lib/assets/pins/red-flag-hint-pin.png',
          //         height: 30,
          //         width: 30,
          //       ),
          //     )),
          // Padding(
          //     padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          //     child: IconButton.outlined(
          //       isSelected: false,
          //       highlightColor:
          //           const Color.fromARGB(131, 238, 238, 238).withOpacity(0.5),
          //       tooltip: 'green flag',
          //       visualDensity: const VisualDensity(vertical: 3),
          //       onPressed: () {},
          //       icon: Image.asset(
          //         'lib/assets/pins/red-flag-hint-pin.png',
          //         height: 30,
          //         width: 30,
          //       ),
          //     )),
          // Padding(
          //     padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          //     child: IconButton.outlined(
          //       isSelected: false,
          //       highlightColor:
          //           const Color.fromARGB(131, 238, 238, 238).withOpacity(0.5),
          //       tooltip: 'blue flag',
          //       visualDensity: const VisualDensity(vertical: 3),
          //       onPressed: () {},
          //       icon: Image.asset(
          //         'lib/assets/pins/red-flag-hint-pin.png',
          //         height: 30,
          //         width: 30,
          //       ),
          //     )),
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
    _mapController.addSymbol(pins.last.options).then((symbol) {
      historyAdd(name: 'symbol', element: symbol);
    });
  }

  Offset getCenterScreenPoint(BuildContext context) {
    final screenSize = View.of(context).physicalSize;
    final centerPoint = Offset(screenSize.width / 2, screenSize.height / 2);
    return centerPoint;
  }

  void historyAdd({required String name, required Object element}) {
    context.read<PlannerHistoryProvider>().add(name: name, element: element);
  }

  void historyGet({required int index}) {
    context.read<PlannerHistoryProvider>().get(index);
  }

  void historyRedo() {
    context.read<PlannerHistoryProvider>().redo;
  }

  void historyUndo() {
    context.read<PlannerHistoryProvider>().undo;
  }

  void historyClear() {
    context.read<PlannerHistoryProvider>().clear;
  }

  void historyUndoRange(int start, int end) {
    context.read<PlannerHistoryProvider>().undoRange(start, end);
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
