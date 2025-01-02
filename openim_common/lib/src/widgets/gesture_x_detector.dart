library gesture_x_detector;

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math.dart' as vector;

class XGestureDetector extends StatefulWidget {
  const XGestureDetector(
      {super.key,
      required this.child,
      this.onTap,
      this.onMoveUpdate,
      this.onMoveEnd,
      this.onMoveStart,
      this.onScaleStart,
      this.onScaleUpdate,
      this.onScaleEnd,
      this.onDoubleTap,
      this.onPointerDown,
      this.onScrollEvent,
      this.bypassMoveEventAfterLongPress = true,
      this.bypassTapEventOnDoubleTap = false,
      this.doubleTapTimeConsider = 250,
      this.longPressTimeConsider = 350,
      this.onLongPress,
      this.onLongPressMove,
      this.onLongPressEnd,
      this.behavior = HitTestBehavior.deferToChild,
      this.longPressMaximumRangeAllowed = 25});

  final Widget child;

  final bool bypassTapEventOnDoubleTap;

  final bool bypassMoveEventAfterLongPress;

  final int doubleTapTimeConsider;

  final TapEventListener? onTap;

  final MoveEventListener? onMoveStart;

  final MoveEventListener? onMoveUpdate;

  final MoveEventListener? onMoveEnd;

  final void Function(Offset initialFocusPoint)? onScaleStart;

  final ScaleEventListener? onScaleUpdate;

  final void Function()? onScaleEnd;

  final TapEventListener? onDoubleTap;

  final TapEventListener? onLongPress;

  final MoveEventListener? onLongPressMove;

  final Function()? onLongPressEnd;

  final Function(ScrollEvent event)? onScrollEvent;

  final int longPressTimeConsider;

  final HitTestBehavior behavior;

  final int longPressMaximumRangeAllowed;

  final Function(PointerDownEvent event)? onPointerDown;

  @override
  State<XGestureDetector> createState() => _XGestureDetectorState();
}

enum _GestureState { PointerDown, MoveStart, ScaleStart, Scalling, LongPress, Unknown }

class _XGestureDetectorState extends State<XGestureDetector> {
  List<_Touch> touches = [];
  double initialScaleDistance = 1.0;
  _GestureState state = _GestureState.Unknown;
  Timer? doubleTapTimer;
  Timer? longPressTimer;
  Offset lastTouchUpPos = const Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: widget.behavior,
      onPointerDown: onPointerDown,
      onPointerUp: onPointerUp,
      onPointerMove: onPointerMove,
      onPointerCancel: onPointerUp,
      onPointerSignal: onPointerSignal,
      child: widget.child,
    );
  }

  void onPointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      widget.onScrollEvent?.call(ScrollEvent(event.pointer, event.localPosition, event.position, event.scrollDelta));
    }
  }

  void onPointerDown(PointerDownEvent event) {
    widget.onPointerDown?.call(event);
    touches.add(_Touch(event.pointer, event.localPosition));

    if (touchCount == 1) {
      state = _GestureState.PointerDown;
      startLongPressTimer(TapEvent.from(event));
    } else if (touchCount == 2) {
      state = _GestureState.ScaleStart;
    } else {
      state = _GestureState.Unknown;
    }
  }

  void initScaleAndRotate() {
    initialScaleDistance = (touches[0].currentOffset - touches[1].currentOffset).distance;
  }

  void onPointerMove(PointerMoveEvent event) {
    final touch = touches.firstWhere((touch) => touch.id == event.pointer);
    touch.currentOffset = event.localPosition;
    cleanupDoubleTimer();

    switch (state) {
      case _GestureState.LongPress:
        if (widget.bypassMoveEventAfterLongPress) {
          widget.onLongPressMove?.call(MoveEvent(event.localPosition, event.position, event.pointer,
              delta: event.delta, localDelta: event.localDelta));
        } else {
          switch2MoveStartState(touch, event);
        }
        break;
      case _GestureState.PointerDown:
        switch2MoveStartState(touch, event);
        break;
      case _GestureState.MoveStart:
        widget.onMoveUpdate?.call(MoveEvent(event.localPosition, event.position, event.pointer,
            delta: event.delta, localDelta: event.localDelta));
        break;
      case _GestureState.ScaleStart:
        touch.startOffset = touch.currentOffset;
        state = _GestureState.Scalling;
        initScaleAndRotate();
        if (widget.onScaleStart != null) {
          final centerOffset = (touches[0].currentOffset + touches[1].currentOffset) / 2;
          widget.onScaleStart!(centerOffset);
        }
        break;
      case _GestureState.Scalling:
        if (widget.onScaleUpdate != null) {
          var rotation = angleBetweenLines(touches[0], touches[1]);
          final newDistance = (touches[0].currentOffset - touches[1].currentOffset).distance;
          final centerOffset = (touches[0].currentOffset + touches[1].currentOffset) / 2;

          widget.onScaleUpdate!(ScaleEvent(centerOffset, newDistance / initialScaleDistance, rotation));
        }
        break;
      default:
        touch.startOffset = touch.currentOffset;
        break;
    }
  }

  void switch2MoveStartState(_Touch touch, PointerMoveEvent event) {
    state = _GestureState.MoveStart;
    touch.startOffset = event.localPosition;
    widget.onMoveStart?.call(MoveEvent(event.localPosition, event.localPosition, event.pointer));
  }

  double angleBetweenLines(_Touch f, _Touch s) {
    double angle1 = math.atan2(f.startOffset.dy - s.startOffset.dy, f.startOffset.dx - s.startOffset.dx);
    double angle2 = math.atan2(f.currentOffset.dy - s.currentOffset.dy, f.currentOffset.dx - s.currentOffset.dx);

    double angle = vector.degrees(angle1 - angle2) % 360;
    if (angle < -180.0) angle += 360.0;
    if (angle > 180.0) angle -= 360.0;
    return vector.radians(angle);
  }

  void onPointerUp(PointerEvent event) {
    touches.removeWhere((touch) => touch.id == event.pointer);

    if (state == _GestureState.PointerDown) {
      if (!widget.bypassTapEventOnDoubleTap || widget.onDoubleTap == null) {
        callOnTap(TapEvent.from(event));
      }
      if (widget.onDoubleTap != null) {
        final tapEvent = TapEvent.from(event);
        if (doubleTapTimer == null) {
          startDoubleTapTimer(tapEvent);
        } else {
          cleanupTimer();
          if ((event.localPosition - lastTouchUpPos).distanceSquared < 200) {
            widget.onDoubleTap!(tapEvent);
          } else {
            startDoubleTapTimer(tapEvent);
          }
        }
      }
    } else if (state == _GestureState.ScaleStart || state == _GestureState.Scalling) {
      state = _GestureState.Unknown;
      widget.onScaleEnd?.call();
    } else if (state == _GestureState.MoveStart) {
      state = _GestureState.Unknown;
      widget.onMoveEnd?.call(MoveEvent(event.localPosition, event.position, event.pointer));
    } else if (state == _GestureState.LongPress) {
      widget.onLongPressEnd?.call();
      state = _GestureState.Unknown;
    } else if (state == _GestureState.Unknown && touchCount == 2) {
      state = _GestureState.ScaleStart;
    } else {
      state = _GestureState.Unknown;
    }

    lastTouchUpPos = event.localPosition;
  }

  void startLongPressTimer(TapEvent event) {
    if (widget.onLongPress != null) {
      if (longPressTimer != null) {
        longPressTimer!.cancel();
        longPressTimer = null;
      }
      longPressTimer = Timer(Duration(milliseconds: widget.longPressTimeConsider), () {
        if (touchCount == 1 && touches[0].id == event.pointer && inLongPressRange(touches[0])) {
          state = _GestureState.LongPress;
          widget.onLongPress!(event);
          cleanupTimer();
        }
      });
    }
  }

  bool inLongPressRange(_Touch touch) {
    return (touch.currentOffset - touch.startOffset).distanceSquared < widget.longPressMaximumRangeAllowed;
  }

  void startDoubleTapTimer(TapEvent event) {
    doubleTapTimer = Timer(Duration(milliseconds: widget.doubleTapTimeConsider), () {
      state = _GestureState.Unknown;
      cleanupTimer();
      if (widget.bypassTapEventOnDoubleTap) {
        callOnTap(event);
      }
    });
  }

  void cleanupTimer() {
    cleanupDoubleTimer();
    if (longPressTimer != null) {
      longPressTimer!.cancel();
      longPressTimer = null;
    }
  }

  void cleanupDoubleTimer() {
    if (doubleTapTimer != null) {
      doubleTapTimer!.cancel();
      doubleTapTimer = null;
    }
  }

  void callOnTap(TapEvent event) {
    if (widget.onTap != null) {
      widget.onTap!(event);
    }
  }

  get touchCount => touches.length;
}

class _Touch {
  int id;
  Offset startOffset;
  late Offset currentOffset;

  _Touch(this.id, this.startOffset) {
    this.currentOffset = startOffset;
  }
}

@immutable
class MoveEvent extends TapEvent {
  final Offset localDelta;

  final Offset delta;

  const MoveEvent(
    Offset localPos,
    Offset position,
    int pointer, {
    this.localDelta = const Offset(0, 0),
    this.delta = const Offset(0, 0),
  }) : super(localPos, position, pointer);
}

@immutable
class TapEvent {
  final int pointer;

  final Offset localPos;

  final Offset position;

  const TapEvent(this.localPos, this.position, this.pointer);

  static from(PointerEvent event) {
    return TapEvent(event.localPosition, event.position, event.pointer);
  }
}

@immutable
class ScaleEvent {
  final Offset focalPoint;

  final double scale;

  final double rotationAngle;

  const ScaleEvent(this.focalPoint, this.scale, this.rotationAngle);
}

@immutable
class ScrollEvent {
  final int pointer;

  final Offset localPos;

  final Offset position;

  final Offset scrollDelta;

  const ScrollEvent(this.pointer, this.localPos, this.position, this.scrollDelta);
}

typedef ScaleEventListener = void Function(ScaleEvent event);

typedef TapEventListener = void Function(TapEvent event);

typedef MoveEventListener = void Function(MoveEvent event);
