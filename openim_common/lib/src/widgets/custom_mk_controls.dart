import 'dart:async';
import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:screen_brightness/screen_brightness.dart';

import 'package:media_kit_video/media_kit_video_controls/src/controls/methods/video_state.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/extensions/duration.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/widgets/video_controls_theme_data_injector.dart';

Widget CustomMKMaterialVideoControls(VideoState state) {
  return const VideoControlsThemeDataInjector(
    child: _MaterialVideoControls(),
  );
}

MaterialVideoControlsThemeData _theme(BuildContext context) => FullscreenInheritedWidget.maybeOf(context) == null
    ? MaterialVideoControlsTheme.maybeOf(context)?.normal ?? kDefaultMaterialVideoControlsThemeData
    : MaterialVideoControlsTheme.maybeOf(context)?.fullscreen ?? kDefaultMaterialVideoControlsThemeDataFullscreen;

class _CustomMKMaterialVideoControls extends StatefulWidget {
  const _CustomMKMaterialVideoControls({super.key});

  @override
  State<_CustomMKMaterialVideoControls> createState() => _CustomMMaterialVideoControlsState();
}

class _CustomMMaterialVideoControlsState extends State<_CustomMKMaterialVideoControls> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _MaterialVideoControls extends StatefulWidget {
  const _MaterialVideoControls();

  @override
  State<_MaterialVideoControls> createState() => _MaterialVideoControlsState();
}

class _MaterialVideoControlsState extends State<_MaterialVideoControls> {
  late bool mount = _theme(context).visibleOnMount;
  late bool visible = _theme(context).visibleOnMount;
  Timer? _timer;

  double _brightnessValue = 0.0;
  bool _brightnessIndicator = false;
  Timer? _brightnessTimer;

  double _volumeValue = 0.0;
  bool _volumeIndicator = false;
  Timer? _volumeTimer;

  bool _volumeInterceptEventStream = false;

  Offset _dragInitialDelta = Offset.zero; // Initial position for horizontal drag
  int swipeDuration = 0; // Duration to seek in video
  bool showSwipeDuration = false; // Whether to show the seek duration overlay

  bool _speedUpIndicator = false;
  late /* private */ var playlist = controller(context).player.state.playlist;
  late bool buffering = controller(context).player.state.buffering;

  bool _mountSeekBackwardButton = false;
  bool _mountSeekForwardButton = false;
  bool _hideSeekBackwardButton = false;
  bool _hideSeekForwardButton = false;
  Timer? _timerSeekBackwardButton;
  Timer? _timerSeekForwardButton;

  final ValueNotifier<Duration> _seekBarDeltaValueNotifier = ValueNotifier<Duration>(Duration.zero);

  final List<StreamSubscription> subscriptions = [];

  double get subtitleVerticalShiftOffset =>
      (_theme(context).padding?.bottom ?? 0.0) +
      (_theme(context).bottomButtonBarMargin.vertical) +
      (_theme(context).bottomButtonBar.isNotEmpty ? _theme(context).buttonBarHeight : 0.0);
  Offset? _tapPosition;

  void _handleDoubleTapDown(TapDownDetails details) {
    setState(() {
      _tapPosition = details.localPosition;
    });
  }

  void _handleLongPress() {
    setState(() {
      _speedUpIndicator = true;
    });
    controller(context).player.setRate(_theme(context).speedUpFactor);
  }

  void _handleLongPressEnd(LongPressEndDetails details) {
    setState(() {
      _speedUpIndicator = false;
    });
    controller(context).player.setRate(1.0);
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (subscriptions.isEmpty) {
      subscriptions.addAll(
        [
          controller(context).player.stream.playlist.listen(
            (event) {
              setState(() {
                playlist = event;
              });
            },
          ),
          controller(context).player.stream.buffering.listen(
            (event) {
              setState(() {
                buffering = event;
              });
            },
          ),
        ],
      );

      if (_theme(context).visibleOnMount) {
        _timer = Timer(
          _theme(context).controlsHoverDuration,
          () {
            if (mounted) {
              setState(() {
                visible = false;
              });
              unshiftSubtitle();
            }
          },
        );
      }
    }
  }

  @override
  void dispose() {
    for (final subscription in subscriptions) {
      subscription.cancel();
    }

    Future.microtask(() async {
      try {
        await ScreenBrightness().resetScreenBrightness();
      } catch (_) {}
    });

    _timerSeekBackwardButton?.cancel();
    _timerSeekForwardButton?.cancel();
    super.dispose();
  }

  void shiftSubtitle() {
    if (_theme(context).shiftSubtitlesOnControlsVisibilityChange) {
      state(context).setSubtitleViewPadding(
        state(context).widget.subtitleViewConfiguration.padding +
            EdgeInsets.fromLTRB(
              0.0,
              0.0,
              0.0,
              subtitleVerticalShiftOffset,
            ),
      );
    }
  }

  void unshiftSubtitle() {
    if (_theme(context).shiftSubtitlesOnControlsVisibilityChange) {
      state(context).setSubtitleViewPadding(
        state(context).widget.subtitleViewConfiguration.padding,
      );
    }
  }

  void onTap() {
    if (!visible) {
      setState(() {
        mount = true;
        visible = true;
      });
      shiftSubtitle();
      _timer?.cancel();
      _timer = Timer(_theme(context).controlsHoverDuration, () {
        if (mounted) {
          setState(() {
            visible = false;
          });
          unshiftSubtitle();
        }
      });
    } else {
      setState(() {
        visible = false;
      });
      unshiftSubtitle();
      _timer?.cancel();
    }
  }

  void onDoubleTapSeekBackward() {
    setState(() {
      _mountSeekBackwardButton = true;
    });
  }

  void onDoubleTapSeekForward() {
    setState(() {
      _mountSeekForwardButton = true;
    });
  }

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    if (_dragInitialDelta == Offset.zero) {
      _dragInitialDelta = details.localPosition;
      return;
    }

    final diff = _dragInitialDelta.dx - details.localPosition.dx;
    final duration = controller(context).player.state.duration.inSeconds;
    final position = controller(context).player.state.position.inSeconds;

    final seconds = -(diff * duration / _theme(context).horizontalGestureSensitivity).round();
    final relativePosition = position + seconds;

    if (relativePosition <= duration && relativePosition >= 0) {
      setState(() {
        swipeDuration = seconds;
        showSwipeDuration = true;
        _seekBarDeltaValueNotifier.value = Duration(seconds: seconds);
      });
    }
  }

  void onHorizontalDragEnd() {
    if (swipeDuration != 0) {
      Duration newPosition = controller(context).player.state.position + Duration(seconds: swipeDuration);
      newPosition = newPosition.clamp(
        Duration.zero,
        controller(context).player.state.duration,
      );
      controller(context).player.seek(newPosition);
    }

    setState(() {
      _dragInitialDelta = Offset.zero;
      showSwipeDuration = false;
    });
  }

  bool _isInSegment(double localX, int segmentIndex) {
    List<int> segmentRatios = _theme(context).seekOnDoubleTapLayoutTapsRatios;

    int totalRatios = segmentRatios.reduce((a, b) => a + b);

    double segmentWidthMultiplier = widgetWidth(context) / totalRatios;
    double start = 0;
    double end;

    for (int i = 0; i < segmentRatios.length; i++) {
      end = start + (segmentWidthMultiplier * segmentRatios[i]);

      if (i == segmentIndex && localX >= start && localX <= end) {
        return true;
      }

      start = end;
    }

    return false;
  }

  bool _isInRightSegment(double localX) {
    return _isInSegment(localX, 2);
  }

  bool _isInCenterSegment(double localX) {
    return _isInSegment(localX, 1);
  }

  bool _isInLeftSegment(double localX) {
    return _isInSegment(localX, 0);
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (!(_isInCenterSegment(event.position.dx))) {
      return;
    }

    onTap();
  }

  void _handleTapDown(TapDownDetails details) {
    if ((_isInCenterSegment(details.localPosition.dx))) {
      return;
    }

    onTap();
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      try {
        VolumeController().showSystemUI = false;
        _volumeValue = await VolumeController().getVolume();
        VolumeController().listener((value) {
          if (mounted && !_volumeInterceptEventStream) {
            setState(() {
              _volumeValue = value;
            });
          }
        });
      } catch (_) {}
    });

    Future.microtask(() async {
      try {
        _brightnessValue = await ScreenBrightness().current;
        ScreenBrightness().onCurrentBrightnessChanged.listen((value) {
          if (mounted) {
            setState(() {
              _brightnessValue = value;
            });
          }
        });
      } catch (_) {}
    });
  }

  Future<void> setVolume(double value) async {
    try {
      VolumeController().setVolume(value);
    } catch (_) {}
    setState(() {
      _volumeValue = value;
      _volumeIndicator = true;
      _volumeInterceptEventStream = true;
    });
    _volumeTimer?.cancel();
    _volumeTimer = Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _volumeIndicator = false;
          _volumeInterceptEventStream = false;
        });
      }
    });
  }

  Future<void> setBrightness(double value) async {
    try {
      await ScreenBrightness().setScreenBrightness(value);
    } catch (_) {}
    setState(() {
      _brightnessIndicator = true;
    });
    _brightnessTimer?.cancel();
    _brightnessTimer = Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _brightnessIndicator = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var seekOnDoubleTapEnabledWhileControlsAreVisible =
        (_theme(context).seekOnDoubleTap && _theme(context).seekOnDoubleTapEnabledWhileControlsVisible);
    assert(_theme(context).seekOnDoubleTapLayoutTapsRatios.length == 3,
        "The number of seekOnDoubleTapLayoutTapsRatios must be 3, i.e. [1, 1, 1]");
    assert(_theme(context).seekOnDoubleTapLayoutWidgetRatios.length == 3,
        "The number of seekOnDoubleTapLayoutWidgetRatios must be 3, i.e. [1, 1, 1]");
    return Theme(
      data: Theme.of(context).copyWith(
        focusColor: const Color(0x00000000),
        hoverColor: const Color(0x00000000),
        splashColor: const Color(0x00000000),
        highlightColor: const Color(0x00000000),
      ),
      child: Focus(
        autofocus: true,
        child: Material(
          elevation: 0.0,
          borderOnForeground: false,
          animationDuration: Duration.zero,
          color: const Color(0x00000000),
          shadowColor: const Color(0x00000000),
          surfaceTintColor: const Color(0x00000000),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              AnimatedOpacity(
                curve: Curves.easeInOut,
                opacity: visible ? 1.0 : 0.0,
                duration: _theme(context).controlsTransitionDuration,
                onEnd: () {
                  setState(() {
                    if (!visible) {
                      mount = false;
                    }
                  });
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: Container(
                        color: _theme(context).backdropColor,
                      ),
                    ),
                    Positioned.fill(
                      left: 16.0,
                      top: 16.0,
                      right: 16.0,
                      bottom: 16.0 + subtitleVerticalShiftOffset,
                      child: Listener(
                        onPointerDown: (event) => _handlePointerDown(event),
                        child: GestureDetector(
                          onTapDown: (details) => _handleTapDown(details),
                          onDoubleTapDown: _handleDoubleTapDown,
                          onLongPress: _theme(context).speedUpOnLongPress ? _handleLongPress : null,
                          onLongPressEnd: _theme(context).speedUpOnLongPress ? _handleLongPressEnd : null,
                          onDoubleTap: () {
                            if (_tapPosition == null) {
                              return;
                            }
                            if (_isInRightSegment(_tapPosition!.dx)) {
                              if ((!mount && _theme(context).seekOnDoubleTap) ||
                                  seekOnDoubleTapEnabledWhileControlsAreVisible) {
                                onDoubleTapSeekForward();
                              }
                            } else {
                              if (_isInLeftSegment(_tapPosition!.dx)) {
                                if ((!mount && _theme(context).seekOnDoubleTap) ||
                                    seekOnDoubleTapEnabledWhileControlsAreVisible) {
                                  onDoubleTapSeekBackward();
                                }
                              }
                            }
                          },
                          onHorizontalDragUpdate: (details) {
                            if ((!mount && _theme(context).seekGesture) ||
                                (_theme(context).seekGesture && _theme(context).gesturesEnabledWhileControlsVisible)) {
                              onHorizontalDragUpdate(details);
                            }
                          },
                          onHorizontalDragEnd: (details) {
                            onHorizontalDragEnd();
                          },
                          child: Container(
                            color: const Color(0x00000000),
                          ),
                        ),
                      ),
                    ),
                    if (mount)
                      Padding(
                        padding: _theme(context).padding ??
                            (isFullscreen(context) ? MediaQuery.of(context).padding : EdgeInsets.zero),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              height: _theme(context).buttonBarHeight,
                              margin: _theme(context).topButtonBarMargin,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: _theme(context).topButtonBar,
                              ),
                            ),
                            Expanded(
                              child: AnimatedOpacity(
                                curve: Curves.easeInOut,
                                opacity: buffering ? 0.0 : 1.0,
                                duration: _theme(context).controlsTransitionDuration,
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: _theme(context).primaryButtonBar,
                                  ),
                                ),
                              ),
                            ),
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                if (_theme(context).displaySeekBar)
                                  MaterialSeekBar(
                                    onSeekStart: () {
                                      _timer?.cancel();
                                    },
                                    onSeekEnd: () {
                                      _timer = Timer(
                                        _theme(context).controlsHoverDuration,
                                        () {
                                          if (mounted) {
                                            setState(() {
                                              visible = false;
                                            });
                                            unshiftSubtitle();
                                          }
                                        },
                                      );
                                    },
                                  ),
                                Container(
                                  height: _theme(context).buttonBarHeight,
                                  margin: _theme(context).bottomButtonBarMargin,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: _theme(context).bottomButtonBar,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              if (!mount)
                if (_mountSeekBackwardButton || _mountSeekForwardButton || showSwipeDuration)
                  Column(
                    children: [
                      const Spacer(),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          if (_theme(context).displaySeekBar)
                            MaterialSeekBar(
                              delta: _seekBarDeltaValueNotifier,
                            ),
                          Container(
                            height: _theme(context).buttonBarHeight,
                            margin: _theme(context).bottomButtonBarMargin,
                          ),
                        ],
                      ),
                    ],
                  ),
              IgnorePointer(
                child: Padding(
                  padding: _theme(context).padding ??
                      (isFullscreen(context) ? MediaQuery.of(context).padding : EdgeInsets.zero),
                  child: Column(
                    children: [
                      Container(
                        height: _theme(context).buttonBarHeight,
                        margin: _theme(context).topButtonBarMargin,
                      ),
                      Expanded(
                        child: Center(
                          child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(
                              begin: 0.0,
                              end: buffering ? 1.0 : 0.0,
                            ),
                            duration: _theme(context).controlsTransitionDuration,
                            builder: (context, value, child) {
                              if (value > 0.0) {
                                return Opacity(
                                  opacity: value,
                                  child: _theme(context).bufferingIndicatorBuilder?.call(context) ?? child!,
                                );
                              }
                              return const SizedBox.shrink();
                            },
                            child: const CircularProgressIndicator(
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: _theme(context).buttonBarHeight,
                        margin: _theme(context).bottomButtonBarMargin,
                      ),
                    ],
                  ),
                ),
              ),
              IgnorePointer(
                child: AnimatedOpacity(
                  curve: Curves.easeInOut,
                  opacity:
                      (!mount || _theme(context).gesturesEnabledWhileControlsVisible) && _volumeIndicator ? 1.0 : 0.0,
                  duration: _theme(context).controlsTransitionDuration,
                  child: _theme(context).volumeIndicatorBuilder?.call(context, _volumeValue) ??
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0x88000000),
                          borderRadius: BorderRadius.circular(64.0),
                        ),
                        height: 52.0,
                        width: 108.0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 52.0,
                              width: 42.0,
                              alignment: Alignment.centerRight,
                              child: Icon(
                                _volumeValue == 0.0
                                    ? Icons.volume_off
                                    : _volumeValue < 0.5
                                        ? Icons.volume_down
                                        : Icons.volume_up,
                                color: const Color(0xFFFFFFFF),
                                size: 24.0,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                '${(_volumeValue * 100.0).round()}%',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                          ],
                        ),
                      ),
                ),
              ),
              IgnorePointer(
                child: AnimatedOpacity(
                  curve: Curves.easeInOut,
                  opacity: (!mount || _theme(context).gesturesEnabledWhileControlsVisible) && _brightnessIndicator
                      ? 1.0
                      : 0.0,
                  duration: _theme(context).controlsTransitionDuration,
                  child: _theme(context).brightnessIndicatorBuilder?.call(context, _volumeValue) ??
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0x88000000),
                          borderRadius: BorderRadius.circular(64.0),
                        ),
                        height: 52.0,
                        width: 108.0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 52.0,
                              width: 42.0,
                              alignment: Alignment.centerRight,
                              child: Icon(
                                _brightnessValue < 1.0 / 3.0
                                    ? Icons.brightness_low
                                    : _brightnessValue < 2.0 / 3.0
                                        ? Icons.brightness_medium
                                        : Icons.brightness_high,
                                color: const Color(0xFFFFFFFF),
                                size: 24.0,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                '${(_brightnessValue * 100.0).round()}%',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                          ],
                        ),
                      ),
                ),
              ),
              IgnorePointer(
                child: Padding(
                  padding: _theme(context).padding ??
                      (isFullscreen(context) ? MediaQuery.of(context).padding : EdgeInsets.zero),
                  child: Column(
                    children: [
                      Container(
                        height: _theme(context).buttonBarHeight,
                        margin: _theme(context).topButtonBarMargin,
                      ),
                      Expanded(
                        child: AnimatedOpacity(
                          duration: _theme(context).controlsTransitionDuration,
                          opacity: _speedUpIndicator ? 1 : 0,
                          child:
                              _theme(context).speedUpIndicatorBuilder?.call(context, _theme(context).speedUpFactor) ??
                                  Container(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      margin: const EdgeInsets.all(16.0),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: const Color(0x88000000),
                                        borderRadius: BorderRadius.circular(64.0),
                                      ),
                                      height: 48.0,
                                      width: 108.0,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(width: 16.0),
                                          Expanded(
                                            child: Text(
                                              '${_theme(context).speedUpFactor.toStringAsFixed(1)}x',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Color(0xFFFFFFFF),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 48.0,
                                            width: 48.0 - 16.0,
                                            alignment: Alignment.centerRight,
                                            child: const Icon(
                                              Icons.fast_forward,
                                              color: Color(0xFFFFFFFF),
                                              size: 24.0,
                                            ),
                                          ),
                                          const SizedBox(width: 16.0),
                                        ],
                                      ),
                                    ),
                                  ),
                        ),
                      ),
                      Container(
                        height: _theme(context).buttonBarHeight,
                        margin: _theme(context).bottomButtonBarMargin,
                      ),
                    ],
                  ),
                ),
              ),
              IgnorePointer(
                child: AnimatedOpacity(
                  duration: _theme(context).controlsTransitionDuration,
                  opacity: showSwipeDuration ? 1 : 0,
                  child: _theme(context).seekIndicatorBuilder?.call(context, Duration(seconds: swipeDuration)) ??
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0x88000000),
                          borderRadius: BorderRadius.circular(64.0),
                        ),
                        height: 52.0,
                        width: 108.0,
                        child: Text(
                          swipeDuration > 0
                              ? "+ ${Duration(seconds: swipeDuration).label()}"
                              : "- ${Duration(seconds: swipeDuration).label()}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                ),
              ),
              if (!mount || seekOnDoubleTapEnabledWhileControlsAreVisible)
                if (_mountSeekBackwardButton || _mountSeekForwardButton)
                  Positioned.fill(
                    child: Row(
                      children: [
                        Expanded(
                          flex: _theme(context).seekOnDoubleTapLayoutWidgetRatios[0],
                          child: _mountSeekBackwardButton
                              ? AnimatedOpacity(
                                  opacity: _hideSeekBackwardButton ? 0 : 1.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: _BackwardSeekIndicator(
                                    onChanged: (value) {
                                      _seekBarDeltaValueNotifier.value = -value;
                                    },
                                    onSubmitted: (value) {
                                      _timerSeekBackwardButton?.cancel();
                                      _timerSeekBackwardButton = Timer(
                                        const Duration(milliseconds: 200),
                                        () {
                                          setState(() {
                                            _hideSeekBackwardButton = false;
                                            _mountSeekBackwardButton = false;
                                          });
                                        },
                                      );

                                      setState(() {
                                        _hideSeekBackwardButton = true;
                                      });
                                      var result = controller(context).player.state.position - value;
                                      result = result.clamp(
                                        Duration.zero,
                                        controller(context).player.state.duration,
                                      );
                                      controller(context).player.seek(result);
                                    },
                                  ),
                                )
                              : const SizedBox(),
                        ),
                        if (_theme(context).seekOnDoubleTapLayoutWidgetRatios[1] > 0)
                          Expanded(flex: _theme(context).seekOnDoubleTapLayoutWidgetRatios[1], child: SizedBox()),
                        Expanded(
                          flex: _theme(context).seekOnDoubleTapLayoutWidgetRatios[2],
                          child: _mountSeekForwardButton
                              ? AnimatedOpacity(
                                  opacity: _hideSeekForwardButton ? 0 : 1.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: _ForwardSeekIndicator(
                                    onChanged: (value) {
                                      _seekBarDeltaValueNotifier.value = value;
                                    },
                                    onSubmitted: (value) {
                                      _timerSeekForwardButton?.cancel();
                                      _timerSeekForwardButton = Timer(const Duration(milliseconds: 200), () {
                                        if (_hideSeekForwardButton) {
                                          setState(() {
                                            _hideSeekForwardButton = false;
                                            _mountSeekForwardButton = false;
                                          });
                                        }
                                      });
                                      setState(() {
                                        _hideSeekForwardButton = true;
                                      });

                                      var result = controller(context).player.state.position + value;
                                      result = result.clamp(
                                        Duration.zero,
                                        controller(context).player.state.duration,
                                      );
                                      controller(context).player.seek(result);
                                    },
                                  ),
                                )
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  double widgetWidth(BuildContext context) => (context.findRenderObject() as RenderBox).paintBounds.width;
}

class _BackwardSeekIndicator extends StatefulWidget {
  final void Function(Duration) onChanged;
  final void Function(Duration) onSubmitted;
  const _BackwardSeekIndicator({
    Key? key,
    required this.onChanged,
    required this.onSubmitted,
  }) : super(key: key);

  @override
  State<_BackwardSeekIndicator> createState() => _BackwardSeekIndicatorState();
}

class _BackwardSeekIndicatorState extends State<_BackwardSeekIndicator> {
  Duration value = const Duration(seconds: 10);

  Timer? timer;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(milliseconds: 400), () {
      widget.onSubmitted.call(value);
    });
  }

  void increment() {
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 400), () {
      widget.onSubmitted.call(value);
    });
    widget.onChanged.call(value);
    setState(() {
      value += const Duration(seconds: 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0x88767676),
            Color(0x00767676),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: InkWell(
        splashColor: const Color(0x44767676),
        onTap: increment,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.fast_rewind,
                size: 24.0,
                color: Color(0xFFFFFFFF),
              ),
              const SizedBox(height: 8.0),
              Text(
                '${value.inSeconds} seconds',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ForwardSeekIndicator extends StatefulWidget {
  final void Function(Duration) onChanged;
  final void Function(Duration) onSubmitted;
  const _ForwardSeekIndicator({
    Key? key,
    required this.onChanged,
    required this.onSubmitted,
  }) : super(key: key);

  @override
  State<_ForwardSeekIndicator> createState() => _ForwardSeekIndicatorState();
}

class _ForwardSeekIndicatorState extends State<_ForwardSeekIndicator> {
  Duration value = const Duration(seconds: 10);

  Timer? timer;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(milliseconds: 400), () {
      widget.onSubmitted.call(value);
    });
  }

  void increment() {
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 400), () {
      widget.onSubmitted.call(value);
    });
    widget.onChanged.call(value);
    setState(() {
      value += const Duration(seconds: 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0x00767676),
            Color(0x88767676),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: InkWell(
        splashColor: const Color(0x44767676),
        onTap: increment,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.fast_forward,
                size: 24.0,
                color: Color(0xFFFFFFFF),
              ),
              const SizedBox(height: 8.0),
              Text(
                '${value.inSeconds} seconds',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
