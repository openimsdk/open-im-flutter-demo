/*
 * Copyright (c) 2015-2019 StoneHui
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

library gesture_zoom_box;

import 'dart:math';

import 'package:flutter/material.dart';

typedef DoubleCallback = void Function(double v);

class GestureZoomBox extends StatefulWidget {
  final double maxScale;
  final double doubleTapScale;
  final Widget child;
  final VoidCallback? onPressed;
  final DoubleCallback? onScaleListener;
  final Duration duration;

  const GestureZoomBox(
      {Key? key,
      this.maxScale = 5.0,
      this.doubleTapScale = 2.0,
      required this.child,
      this.onPressed,
      this.duration = const Duration(milliseconds: 200),
      this.onScaleListener})
      : assert(maxScale >= 1.0),
        assert(doubleTapScale >= 1.0 && doubleTapScale <= maxScale),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GestureZoomBoxState();
  }
}

class _GestureZoomBoxState extends State<GestureZoomBox> with TickerProviderStateMixin {
  AnimationController? _scaleAnimController;

  AnimationController? _offsetAnimController;

  ScaleUpdateDetails? _firstScaleUpdateDetails;

  ScaleUpdateDetails? _latestScaleUpdateDetails;

  double _scale = 1.0;

  Offset _offset = Offset.zero;

  Offset? _doubleTapPosition;

  bool _isScaling = false;
  bool _isDragging = false;

  double _maxDragOver = 100;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..translate(_offset.dx, _offset.dy)
        ..scale(_scale, _scale),
      child: Listener(
        onPointerUp: _onPointerUp,
        child: GestureDetector(
          onTap: widget.onPressed,
          onDoubleTap: _onDoubleTap,
          onScaleStart: _onScaleStart,
          onScaleUpdate: _onScaleUpdate,
          onScaleEnd: _onScaleEnd,
          child: widget.child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scaleAnimController?.dispose();
    _offsetAnimController?.dispose();
    super.dispose();
  }

  _onPointerUp(PointerUpEvent event) {
    _doubleTapPosition = event.localPosition;
  }

  _onDoubleTap() {
    double targetScale = _scale == 1.0 ? widget.doubleTapScale : 1.0;
    _animationScale(targetScale);
    if (targetScale == 1.0) {
      _animationOffset(Offset.zero);
    }
  }

  _onScaleStart(ScaleStartDetails details) {
    _scaleAnimController?.stop();
    _offsetAnimController?.stop();
    _isScaling = false;
    _isDragging = false;
    _firstScaleUpdateDetails = null;
    _latestScaleUpdateDetails = null;
  }

  _onScaleUpdate(ScaleUpdateDetails details) {
    if (_firstScaleUpdateDetails == null) {
      _firstScaleUpdateDetails = details;
      return;
    }

    setState(() {
      if (details.scale != 1.0) {
        _scaling(details);
      } else {
        _dragging(details);
      }
    });
  }

  _scaling(ScaleUpdateDetails details) {
    if (_isDragging) {
      return;
    }
    final latestScaleUpdateDetails = _latestScaleUpdateDetails, size = context.size;
    _isScaling = true;
    if (latestScaleUpdateDetails == null || size == null) {
      _latestScaleUpdateDetails = details;
      return;
    }

    double scaleIncrement = details.scale - latestScaleUpdateDetails.scale;
    if (details.scale < 1.0 && _scale > 1.0) {
      scaleIncrement *= _scale;
    }
    if (_scale < 1.0 && scaleIncrement < 0) {
      scaleIncrement *= (_scale - 0.5);
    } else if (_scale > widget.maxScale && scaleIncrement > 0) {
      scaleIncrement *= (2.0 - (_scale - widget.maxScale));
    }
    _scale = max(_scale + scaleIncrement, 0.0);

    double scaleOffsetX = size.width * (_scale - 1.0) / 2;
    double scaleOffsetY = size.height * (_scale - 1.0) / 2;

    double scalePointDX = (details.localFocalPoint.dx + scaleOffsetX - _offset.dx) / _scale;
    double scalePointDY = (details.localFocalPoint.dy + scaleOffsetY - _offset.dy) / _scale;

    _offset += Offset(
      (size.width / 2 - scalePointDX) * scaleIncrement,
      (size.height / 2 - scalePointDY) * scaleIncrement,
    );

    _latestScaleUpdateDetails = details;
  }

  _dragging(ScaleUpdateDetails details) {
    if (_isScaling) {
      return;
    }
    final latestScaleUpdateDetails = _latestScaleUpdateDetails, size = context.size;
    _isDragging = true;
    if (latestScaleUpdateDetails == null || size == null) {
      _latestScaleUpdateDetails = details;
      return;
    }

    double offsetXIncrement = (details.localFocalPoint.dx - latestScaleUpdateDetails.localFocalPoint.dx) * _scale;
    double offsetYIncrement = (details.localFocalPoint.dy - latestScaleUpdateDetails.localFocalPoint.dy) * _scale;

    double scaleOffsetX = (size.width * _scale - MediaQuery.of(context).size.width) / 2;
    if (scaleOffsetX <= 0) {
      offsetXIncrement = 0;
    } else if (_offset.dx > scaleOffsetX) {
      offsetXIncrement *= (_maxDragOver - (_offset.dx - scaleOffsetX)) / _maxDragOver;
    } else if (_offset.dx < -scaleOffsetX) {
      offsetXIncrement *= (_maxDragOver - (-scaleOffsetX - _offset.dx)) / _maxDragOver;
    }

    double scaleOffsetY = (size.height * _scale - MediaQuery.of(context).size.height) / 2;
    if (scaleOffsetY <= 0) {
      offsetYIncrement = 0;
    } else if (_offset.dy > scaleOffsetY) {
      offsetYIncrement *= (_maxDragOver - (_offset.dy - scaleOffsetY)) / _maxDragOver;
    } else if (_offset.dy < -scaleOffsetY) {
      offsetYIncrement *= (_maxDragOver - (-scaleOffsetY - _offset.dy)) / _maxDragOver;
    }

    _offset += Offset(offsetXIncrement, offsetYIncrement);

    _latestScaleUpdateDetails = details;
  }

  _onScaleEnd(ScaleEndDetails details) {
    final size = context.size;

    if (size == null) {
      return;
    }
    widget.onScaleListener?.call(_scale);

    if (_scale < 1.0) {
      _animationScale(1.0);
    } else if (_scale > widget.maxScale) {
      _animationScale(widget.maxScale);
    }
    if (_scale <= 1.0) {
      _animationOffset(Offset.zero);
    } else if (_isDragging) {
      double realScale = _scale > widget.maxScale ? widget.maxScale : _scale;
      double targetOffsetX = _offset.dx, targetOffsetY = _offset.dy;

      double scaleOffsetX = (size.width * realScale - MediaQuery.of(context).size.width) / 2;
      if (scaleOffsetX <= 0) {
        targetOffsetX = 0;
      } else if (_offset.dx > scaleOffsetX) {
        targetOffsetX = scaleOffsetX;
      } else if (_offset.dx < -scaleOffsetX) {
        targetOffsetX = -scaleOffsetX;
      }

      double scaleOffsetY = (size.height * realScale - MediaQuery.of(context).size.height) / 2;
      if (scaleOffsetY < 0) {
        targetOffsetY = 0;
      } else if (_offset.dy > scaleOffsetY) {
        targetOffsetY = scaleOffsetY;
      } else if (_offset.dy < -scaleOffsetY) {
        targetOffsetY = -scaleOffsetY;
      }
      if (_offset.dx != targetOffsetX || _offset.dy != targetOffsetY) {
        _animationOffset(Offset(targetOffsetX, targetOffsetY));
      } else {
        double duration = (widget.duration.inSeconds + widget.duration.inMilliseconds / 1000);
        Offset targetOffset = _offset + details.velocity.pixelsPerSecond * duration;
        targetOffsetX = targetOffset.dx;
        if (targetOffsetX > scaleOffsetX) {
          targetOffsetX = scaleOffsetX;
        } else if (targetOffsetX < -scaleOffsetX) {
          targetOffsetX = -scaleOffsetX;
        }

        targetOffsetY = targetOffset.dy;
        if (targetOffsetY > scaleOffsetY) {
          targetOffsetY = scaleOffsetY;
        } else if (targetOffsetY < -scaleOffsetY) {
          targetOffsetY = -scaleOffsetY;
        }

        _animationOffset(Offset(targetOffsetX, targetOffsetY));
      }
    }

    _isScaling = false;
    _isDragging = false;
    _latestScaleUpdateDetails = null;
  }

  _animationScale(double targetScale) {
    _scaleAnimController?.dispose();
    final scaleAnimController = _scaleAnimController = AnimationController(vsync: this, duration: widget.duration);
    Animation anim = Tween<double>(begin: _scale, end: targetScale).animate(scaleAnimController);
    anim.addListener(() {
      setState(() {
        _scaling(ScaleUpdateDetails(
          focalPoint: _doubleTapPosition!,
          localFocalPoint: _doubleTapPosition!,
          scale: anim.value,
          horizontalScale: anim.value,
          verticalScale: anim.value,
        ));
      });
    });
    anim.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onScaleEnd(ScaleEndDetails());
      }
    });
    scaleAnimController.forward();
  }

  _animationOffset(Offset targetOffset) {
    _offsetAnimController?.dispose();
    final offsetAnimController = _offsetAnimController = AnimationController(vsync: this, duration: widget.duration);
    Animation anim = offsetAnimController.drive(Tween<Offset>(begin: _offset, end: targetOffset));
    anim.addListener(() {
      setState(() {
        _offset = anim.value;
      });
    });
    offsetAnimController.fling();
  }
}
