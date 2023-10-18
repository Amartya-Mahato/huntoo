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

import '../utils/random_string_generator.dart';
import '../widgets/maps/p_map.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  late final MaplibreMapController _mapController;
  PTools tools = PTools.none;
  List<String> elementIds = [];
  List<String> elementNames = [];
  List<String> redoElementNames = [];
  List<String> redoElementIds = [];
  List<HistoryElement> history = [];
  LatLng? lastConnectorSymbolLatLng;
  String lastShape = '';
  Offset? centerPoint;
  late final Point<num> centerPointAsPoint;
  late final Point<num> topLeft;
  late final Point<num> topRight;
  late final Point<num> bottomLeft;
  late final Point<num> bottomRight;
  bool shapeConfirmationVisibility = false;
  bool symbolConnector = false;
  bool pointConnector = false;
  Circle? circle;
  Object? object;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PMap map = PMap(
        onMapClick: _onMapClick,
        onMapCreated: _onMapCreated,
        onStyleLoadedCallback: _onStyleLoadedCallback);
    history = context.watch<PlannerHistoryProvider>().historyList;
    return SafeArea(
      child: Scaffold(
      extendBody: true,

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
            Visibility(
              visible: PTools.connector == tools,
              child: Positioned(
                left: 0,
                bottom: 0,
                child: Column(children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                      child: IconButton.outlined(
                        isSelected: false,
                        highlightColor: const Color.fromARGB(131, 238, 238, 238)
                            .withOpacity(0.5),
                        tooltip: 'square',
                        onPressed: () async {},
                        icon: const Icon(Icons.touch_app),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                      child: IconButton.outlined(
                        isSelected: false,
                        highlightColor: const Color.fromARGB(131, 238, 238, 238)
                            .withOpacity(0.5),
                        tooltip: 'circle',
                        onPressed: () async {
                          symbolConnector = true;
                        },
                        icon: const Icon(Icons.polyline_rounded),
                      )),
                ]),
              ),
            ),
            _shapeTools(),
            _pinTool(),
            _tools(),
            _shapeConfirmationButtons(context)
          ],
        ),
      ),
    );
  }

  void _onMapCreated(MaplibreMapController mapController) {
    _mapController = mapController;
    _mapController.onSymbolTapped.add(
      (argument) async {
        if (symbolConnector) {
          if (lastConnectorSymbolLatLng != null) {
            List<LatLng> tempLatLngList = [];
            Line tempLine;
            HistoryElement? hElement = historyGetLast();
            if (historyLength() > 0 && hElement!.name == 'sline') {
              tempLatLngList = _mapController.lines.last.options.geometry ?? [];
              tempLatLngList.add(argument.options.geometry!);

              tempLine = await _mapController.addLine(LineOptions(
                  lineColor: 'black',
                  lineWidth: 3,
                  geometry: tempLatLngList,
                  lineOpacity: 0.5));

              (historyGetLast()!.element as List).add(tempLine.toGeoJson());
              await _mapController.removeLine(_mapController.lines.last);
            } else {
              tempLatLngList = [
                lastConnectorSymbolLatLng!,
                argument.options.geometry!
              ];
              tempLine = await _mapController.addLine(LineOptions(
                  lineColor: 'black',
                  lineWidth: 3,
                  geometry: tempLatLngList,
                  lineOpacity: 0.5));
              historyAdd(
                  name: 'sline',
                  action: HAction.add,
                  category: HCategory.polyline,
                  element: [tempLine.toGeoJson()]);
            }
          }
          lastConnectorSymbolLatLng = argument.options.geometry!;
          setState(() {});
        } else {
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
        }
      },
    );
  }

  void _onStyleLoadedCallback() async {
    _centerTRBLPoints();
    final ByteData redFlagByte =
        await rootBundle.load('lib/assets/pins/red-flag-hint-pin.png');
    final Uint8List redFlagList = redFlagByte.buffer.asUint8List();
    await _mapController.addImage("red-flag", redFlagList);
    _mapController.onSymbolTapped.add((argument) {});
  }

  void _onMapClick(Point<double> point, LatLng coordinates) async {
    if (pointConnector) {
      if (lastConnectorSymbolLatLng != null) {}
    }
    // await _mapController.addCircle(CircleOptions(
    //     circleColor: 'red', geometry: coordinates, circleRadius: 5));
    // await _mapController.addLine(LineOptions(
    //     // lineJoin: "round",
    //     lineColor: 'black',
    //     lineWidth: 3,
    //     geometry: [
    //       coordinates,
    //       LatLng(coordinates.latitude + 0.01, coordinates.longitude + 0.01),
    //       LatLng(coordinates.latitude + 0.03, coordinates.longitude + 0.02),
    //       LatLng(coordinates.latitude + 0.06, coordinates.longitude + 0.01),
    //       LatLng(coordinates.latitude + 0.04, coordinates.longitude + 0.09),
    //     ]));

    // await _mapController.addFill(FillOptions(fillColor: 'black', geometry: [
    //   [
    //     coordinates,
    //     LatLng(coordinates.latitude + 0.01, coordinates.longitude + 0.01),
    //     LatLng(coordinates.latitude + 0.03, coordinates.longitude + 0.02),
    //     LatLng(coordinates.latitude + 0.06, coordinates.longitude + 0.01),
    //     LatLng(coordinates.latitude + 0.04, coordinates.longitude + 0.09),
    //     coordinates,
    //   ],
    // ]));
  }

  Future<void> _performOppositeHistoryAction(
      HistoryElement historyElement) async {
    switch (historyElement.action) {
      case HAction.delete:
        {
          await _addHistoryAction(historyElement);
          setState(() {});
          break;
        }
      case HAction.add:
        {
          await _deleteHistoryAction(historyElement);
          setState(() {});
          break;
        }
      case HAction.modify:
        {
          break;
        }
      default:
    }
  }

  Future<void> _performHistoryAction(HistoryElement historyElement) async {
    switch (historyElement.action) {
      case HAction.add:
        {
          await _addHistoryAction(historyElement);
          setState(() {});
          break;
        }
      case HAction.delete:
        {
          await _deleteHistoryAction(historyElement);
          setState(() {});
          break;
        }
      case HAction.modify:
        {
          break;
        }
      default:
    }
  }

  Future<void> _addHistoryAction(HistoryElement historyElement) async {
    switch (historyElement.catagory) {
      case HCategory.symbol:
        {
          LatLng latLng = LatLng(
              (historyElement.element as Map)['geometry']['coordinates'][1],
              (historyElement.element as Map)['geometry']['coordinates'][0]);
          await _mapController.addSymbol(SymbolOptions(
              iconImage: (historyElement.element as Map)['properties']
                  ['iconImage'],
              iconSize: 0.2,
              textField: '',
              fontNames: ['Open Sans Regular'],
              draggable: true,
              textSize: 15,
              textOffset: const Offset(-0.6, 1.3),
              textHaloColor: 'grey',
              geometry: latLng));
          break;
        }
      case HCategory.shape:
        {
          LatLng topLeftLatLng =
              (historyElement.element as Map)['coordinates']['topLeft'];
          LatLng topRightLatLng =
              (historyElement.element as Map)['coordinates']['topRight'];
          LatLng bottomLeftLatLng =
              (historyElement.element as Map)['coordinates']['bottomLeft'];
          LatLng bottomRightLatLng =
              (historyElement.element as Map)['coordinates']['bottomRight'];

          double minZoom = (historyElement.element as Map)['minzoom'];
          double maxZoom = (historyElement.element as Map)['maxzoom'];

          switch (historyElement.name) {
            case 'circle':
              {
                final ByteData bytes =
                    await rootBundle.load('lib/assets/pins/circle.png');
                final Uint8List uInt8Data = bytes.buffer.asUint8List();
                String sourceId = (historyElement.element as Map)['id'];
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
            case 'square':
              {
                final ByteData bytes =
                    await rootBundle.load('lib/assets/pins/square.png');
                final Uint8List uInt8Data = bytes.buffer.asUint8List();
                String sourceId = (historyElement.element as Map)['id'];
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
            case 'triangle':
              {
                final ByteData bytes =
                    await rootBundle.load('lib/assets/pins/triangle.png');
                final Uint8List uInt8Data = bytes.buffer.asUint8List();
                String sourceId = (historyElement.element as Map)['id'];
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
            case 'rectangle':
              {
                final ByteData bytes =
                    await rootBundle.load('lib/assets/pins/square.png');
                final Uint8List uInt8Data = bytes.buffer.asUint8List();
                String sourceId = (historyElement.element as Map)['id'];
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
            case 'poly':
              {
                final ByteData bytes =
                    await rootBundle.load('lib/assets/pins/circle.png');
                final Uint8List uInt8Data = bytes.buffer.asUint8List();
                String sourceId = (historyElement.element as Map)['id'];
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
          break;
        }
      case HCategory.polyline:
        {
          switch (historyElement.name) {
            case 'sline':
              {
                Line lastLine = _mapController.lines.last;
                List<LatLng> tempLatLngList = ((historyElement.element as List)
                        .last['geometry']['coordinates'] as List<dynamic>)
                    .map((e) => LatLng(e.last, e.first))
                    .toList();
                await _mapController.addLine(LineOptions(
                    lineColor: (historyElement.element as List)
                        .last['properties']['lineColor'],
                    lineWidth: 3,
                    geometry: tempLatLngList,
                    lineOpacity: 0.5));
                if (tempLatLngList.length > 2) {
                  await _mapController.removeLine(lastLine);
                }
                break;
              }
            default:
          }
          break;
        }
      default:
    }
  }

  Future<void> _deleteHistoryAction(HistoryElement historyElement) async {
    switch (historyElement.catagory) {
      case HCategory.symbol:
        {
          Set<Symbol> symbols = _mapController.symbols;
          await _mapController.removeSymbol(symbols.last);
          break;
        }
      case HCategory.shape:
        {
          switch (historyElement.name) {
            case 'circle' || 'square' || 'triangle' || 'rectangle':
              {
                await _mapController
                    .removeLayer((historyElement.element as Map)['id']);
                await _mapController
                    .removeSource((historyElement.element as Map)['id']);
                break;
              }
            case 'poly':
              {
                await _mapController
                    .removeLayer((historyElement.element as Map)['id']);
                break;
              }
            default:
          }
          break;
        }
      case HCategory.polyline:
        {
          switch (historyElement.name) {
            case 'sline':
              {
                Line tempLine = _mapController.lines.last;
                List<LatLng> tempLatLngList = tempLine.options.geometry!;
                if (tempLatLngList.length > 2) {
                  tempLatLngList.removeLast();
                  await _mapController.addLine(LineOptions(
                      lineColor: tempLine.options.lineColor,
                      lineWidth: 3,
                      geometry: tempLatLngList,
                      lineOpacity: 0.5));
                }
                await _mapController.removeLine(tempLine);
                break;
              }
            default:
          }
          break;
        }
      default:
    }
  }

  Visibility _historyPannel(BuildContext context) {
    return Visibility(
      visible: true,
      child: Positioned(
        // top: 30,
        child: SizedBox(
          height: 35,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
              itemCount: historyLength(),
              reverse: true,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                HistoryElement? historyElement =
                    historyGet(index: (historyLength() - index) - 1);
                return Padding(
                  padding: const EdgeInsets.only(
                      right: 5.0, left: 2.5, top: 5, bottom: 2.5),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(5)),
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: () async {
                        historyUndoRange((historyLength() - index));
                      },
                      child: historyElement.name == 'sline'
                          ? DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: object,
                                dropdownColor: Colors.black87,
                                iconEnabledColor: Colors.white70,
                                iconDisabledColor: Colors.white70,
                                // hint: const Text('sline', style: TextStyle(color: Colors.white70),),
                                onChanged: (obj) {
                                  object = obj;
                                  setState(() {});
                                },
                                items: List.generate(
                                    (historyElement.element as List).length,
                                    (index) => index + 1).map((e) {
                                  return DropdownMenuItem(
                                    onTap: () {},
                                    value:
                                        (historyElement.element as List)[e - 1],
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '$e. ',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: const Color.fromARGB(
                                                  255, 207, 207, 207)),
                                        ),
                                        Text(
                                          historyElement.name,
                                          style: GoogleFonts.montserrat(
                                              fontSize: 14,
                                              color: const Color.fromARGB(
                                                  255, 207, 207, 207)),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${historyLength() - index}. ',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Color.fromARGB(255, 207, 207, 207)),
                                ),
                                Text(
                                  historyElement.name,
                                  style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      color:
                                          Color.fromARGB(255, 207, 207, 207)),
                                ),
                              ],
                            ),
                    ),
                  ),
                );
              }),
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
                    if (symbolConnector) {
                    } else {
                      historyRemoveLast();
                      shapeConfirmationVisibility = false;
                    }
                    setState(() {});
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
                shapeConfirmationVisibility = false;
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
                  shapeConfirmationVisibility = false;
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
                lastConnectorSymbolLatLng = null;
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
                lastConnectorSymbolLatLng = null;
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
                lastConnectorSymbolLatLng = null;
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
          String sourceId = getRandomStr(30);
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
          historyAdd(
              name: 'circle',
              category: HCategory.shape,
              action: HAction.add,
              element: {
                'id': sourceId,
                'bytes': uInt8Data,
                'maxzoom': maxZoom,
                'minzoom': minZoom,
                'coordinates': {
                  'topLeft': topLeftLatLng,
                  'topRight': topRightLatLng,
                  'bottomRight': bottomRightLatLng,
                  'bottomLeft': bottomLeftLatLng
                }
              });
          break;
        }
      case PShapes.square:
        {
          final ByteData bytes =
              await rootBundle.load('lib/assets/pins/square.png');
          final Uint8List uInt8Data = bytes.buffer.asUint8List();
          String sourceId = getRandomStr(30);
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
          historyAdd(
              name: 'square',
              category: HCategory.shape,
              action: HAction.add,
              element: {
                'id': sourceId,
                'bytes': uInt8Data,
                'maxzoom': maxZoom,
                'minzoom': minZoom,
                'coordinates': {
                  'topLeft': topLeftLatLng,
                  'topRight': topRightLatLng,
                  'bottomRight': bottomRightLatLng,
                  'bottomLeft': bottomLeftLatLng
                }
              });
          break;
        }
      case PShapes.triangle:
        {
          final ByteData bytes =
              await rootBundle.load('lib/assets/pins/triangle.png');
          final Uint8List uInt8Data = bytes.buffer.asUint8List();
          String sourceId = getRandomStr(30);
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
          historyAdd(
              name: 'triangle',
              category: HCategory.shape,
              action: HAction.add,
              element: {
                'id': sourceId,
                'bytes': uInt8Data,
                'maxzoom': maxZoom,
                'minzoom': minZoom,
                'coordinates': {
                  'topLeft': topLeftLatLng,
                  'topRight': topRightLatLng,
                  'bottomRight': bottomRightLatLng,
                  'bottomLeft': bottomLeftLatLng
                }
              });
          break;
        }
      case PShapes.rectangle:
        {
          final ByteData bytes =
              await rootBundle.load('lib/assets/pins/square.png');
          final Uint8List uInt8Data = bytes.buffer.asUint8List();
          String sourceId = getRandomStr(30);
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
          historyAdd(
              name: 'rectangle',
              category: HCategory.shape,
              action: HAction.add,
              element: {
                'id': sourceId,
                'bytes': uInt8Data,
                'maxzoom': maxZoom,
                'minzoom': minZoom,
                'coordinates': {
                  'topLeft': topLeftLatLng,
                  'topRight': topRightLatLng,
                  'bottomRight': bottomRightLatLng,
                  'bottomLeft': bottomLeftLatLng
                }
              });
          break;
        }
      case PShapes.poly:
        {
          final ByteData bytes =
              await rootBundle.load('lib/assets/pins/circle.png');
          final Uint8List uInt8Data = bytes.buffer.asUint8List();
          String sourceId = getRandomStr(30);
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
          historyAdd(
              name: 'shape',
              category: HCategory.shape,
              action: HAction.add,
              element: {
                'id': sourceId,
                'bytes': uInt8Data,
                'maxzoom': maxZoom,
                'minzoom': minZoom,
                'coordinates': {
                  'topLeft': topLeftLatLng,
                  'topRight': topRightLatLng,
                  'bottomRight': bottomRightLatLng,
                  'bottomLeft': bottomLeftLatLng
                }
              });
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
      if (tools == desiredTool) {
        tools = PTools.none;
      } else {
        tools = desiredTool;
      }
    });
  }

  void _putPin({required String name}) async {
    LatLng centerLatlng = await _mapController.toLatLng(centerPointAsPoint);
    _mapController
        .addSymbol(SymbolOptions(
            iconImage: name,
            iconSize: 0.2,
            textField: '',
            fontNames: ['Open Sans Regular'],
            draggable: true,
            textSize: 15,
            textOffset: const Offset(-0.6, 1.3),
            textHaloColor: 'grey',
            geometry: centerLatlng))
        .then((symbol) {
      historyAdd(
          name: 'symbol',
          category: HCategory.symbol,
          action: HAction.add,
          element: symbol.toGeoJson());
    });
  }

  void _connectSymbols() {}

  Offset getCenterScreenPoint(BuildContext context) {
    final screenSize = View.of(context).physicalSize;
    final centerPoint = Offset(screenSize.width / 2, screenSize.height / 2);
    return centerPoint;
  }

  HistoryElement? historyGetFirst() {
    return context.read<PlannerHistoryProvider>().getFirst;
  }

  HistoryElement? historyGetLast() {
    return context.read<PlannerHistoryProvider>().getLast;
  }

  HistoryElement? historyRedoGetFirst() {
    return context.read<PlannerHistoryProvider>().redoGetFirst;
  }

  HistoryElement? historyRedoGetLast() {
    return context.read<PlannerHistoryProvider>().redoGetLast;
  }

  void historyRemoveLast() {
    HistoryElement? historyElement = historyGetLast();
    if (historyElement != null) {
      _performOppositeHistoryAction(historyElement);
      context.read<PlannerHistoryProvider>().removeLast;
    }
  }

  void historyRemoveFirst() {
    HistoryElement? historyElement = historyGetFirst();
    if (historyElement != null) {
      _performOppositeHistoryAction(historyElement);
      context.read<PlannerHistoryProvider>().removeFirst;
    }
  }

  void historyRemoveRange(int start, int end) {
    context.read<PlannerHistoryProvider>().removeRange(start: start, end: end);
  }

  void historyAdd(
      {required String name,
      required HAction action,
      required HCategory category,
      required Object element}) {
    context
        .read<PlannerHistoryProvider>()
        .add(name: name, action: action, element: element, category: category);
  }

  HistoryElement historyGet({required int index}) {
    return context.read<PlannerHistoryProvider>().get(index);
  }

  void historyRedo() {
    HistoryElement? historyElement = historyRedoGetLast();
    if (historyElement != null) {
      switch (historyElement.name) {
        case 'sline':
          {
            _performHistoryAction(historyElement);
            if (historyLength() > 0 && historyGetLast()!.name == 'sline') {
              (historyGetLast()!.element as List)
                  .add((historyRedoGetLast()!.element as List).removeLast());
            } else {
              context.read<PlannerHistoryProvider>().historyList.add(
                  HistoryElement(
                      name: historyElement.name,
                      element: [
                        (historyRedoGetLast()!.element as List).removeLast()
                      ],
                      action: historyElement.action,
                      catagory: historyElement.catagory));
            }
            if ((historyRedoGetLast()!.element as List).isEmpty) {
              context.read<PlannerHistoryProvider>().redoList.removeLast();
            }
            break;
          }
        default:
          {
            _performHistoryAction(historyElement);
            context.read<PlannerHistoryProvider>().redo;
            break;
          }
      }
    }
    setState(() {});
  }

  void historyUndo() {
    HistoryElement? historyElement = historyGetLast();

    if (historyElement != null) {
      switch (historyElement.name) {
        case 'sline':
          {
            print('--------------' + (historyElement.element as List).length.toString());
            _performOppositeHistoryAction(historyElement);
            if (historyRedoLength() > 0 &&
                historyRedoGetLast()!.name == 'sline') {
              (historyRedoGetLast()!.element as List)
                  .add((historyGetLast()!.element as List).removeLast());
            } else {
              context.read<PlannerHistoryProvider>().redoList.add(
                  HistoryElement(
                      name: historyElement.name,
                      element: [
                        (historyGetLast()!.element as List).removeLast()
                      ],
                      action: historyElement.action,
                      catagory: historyElement.catagory));
            }
            if ((historyGetLast()!.element as List).isEmpty) {
              historyRemoveLast();
            }
            print('++++++++++++++++' + (historyElement.element as List).length.toString());
            print('================' + historyLength().toString());
            break;
          }
        default:
          {
            _performOppositeHistoryAction(historyElement);
            context.read<PlannerHistoryProvider>().undo;
            break;
          }
      }
    }
    setState(() {});
  }

  void historyClear() {
    context.read<PlannerHistoryProvider>().clear;
  }

  Future<void> historyUndoRange(int start) async {
    for (int i = start; i < historyLength(); i++) {
      await _performOppositeHistoryAction(historyGet(index: i));
    }
    // ignore: use_build_context_synchronously
    context.read<PlannerHistoryProvider>().undoRange(start);
    setState(() {});
  }

  int historyLength() => context.read<PlannerHistoryProvider>().historyLength;
  int historyRedoLength() => context.read<PlannerHistoryProvider>().redoLength;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
