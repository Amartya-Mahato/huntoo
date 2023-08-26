import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:flutter/gestures.dart';


class CustomZoomPanBehavior extends MapZoomPanBehavior {
  CustomZoomPanBehavior();

  late MapTapCallback onTap;

  bool isPointerDown = false;
  bool isDoublePointerDown = false;
  int? currentPointerId;
  Offset? downPosition;
  final Duration holdDelay = const Duration(milliseconds: 500);

  @override
  void handleEvent(PointerEvent event) async {
    if (event is PointerDownEvent) {
      if (!isDoublePointerDown) {
        if (!isPointerDown) {
          isPointerDown = true;
          currentPointerId = event.pointer;
          downPosition = event.localPosition;
          await Future.delayed(holdDelay);

          if (isPointerDown &&
              currentPointerId == event.pointer &&
              !isDoublePointerDown) {
            onTap(downPosition!);
            super.handleEvent(event);
          }

          isPointerDown = false;
          currentPointerId = null;
        } else {
          isDoublePointerDown = true;
        }
      }
    } else if (event is PointerMoveEvent) {
      if (isPointerDown && currentPointerId == event.pointer) {
        double distance = (event.localPosition - downPosition!).distance;
        if (distance > 10) {
          isPointerDown = false;
          currentPointerId = null;
        }
      }
    } else if (event is PointerUpEvent) {
      if (isPointerDown && currentPointerId == event.pointer) {
        isPointerDown = false;
        currentPointerId = null;
      }
      if (isDoublePointerDown && !event.down) {
        isDoublePointerDown = false;
      }
    }
  }
}

typedef MapTapCallback = void Function(Offset position);