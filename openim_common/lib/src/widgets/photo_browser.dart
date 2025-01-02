import 'dart:async';
import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:media_kit_video/media_kit_video_controls/media_kit_video_controls.dart' as media_kit_video_controls;
import 'package:openim_common/openim_common.dart';

import 'custom_mk_controls.dart';
import 'photo_browser_hero.dart';

class MediaSource {
  final String? url;
  final String thumbnail;
  final File? file;
  final bool isVideo;
  final String? tag;

  MediaSource({required this.thumbnail, this.url, this.file, this.isVideo = false, this.tag});
}

class MediaBrowser extends StatefulWidget {
  const MediaBrowser({
    super.key,
    required this.sources,
    required this.initialIndex,
    this.muted = false,
    this.onAutoPlay,
    this.onSave,
    this.onLongPress,
  });
  final int initialIndex;
  final List<MediaSource> sources;
  final bool muted;
  final bool Function(int index)? onAutoPlay;
  final ValueChanged<int>? onSave;
  final ValueChanged<int>? onLongPress;
  @override
  State<MediaBrowser> createState() => _MediaBrowserState();
}

class _MediaBrowserState extends State<MediaBrowser> with TickerProviderStateMixin {
  GlobalKey<ExtendedImageSlidePageState> slidePagekey = GlobalKey<ExtendedImageSlidePageState>();

  final List<int> _cachedIndexes = <int>[];
  int currentIndex = 0;

  List<double> doubleTapScales = <double>[1.0, 2.0];
  late AnimationController _doubleClickAnimationController;
  Animation<double>? _doubleClickAnimation;
  late VoidCallback _doubleClickAnimationListener;

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    _doubleClickAnimationController = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    Logger.print('[MediaBrowser] dispose', fileName: 'media_browser.dart');
    _doubleClickAnimationController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _preloadImage(currentIndex - 1 < 0 ? 0 : currentIndex - 1);
    _preloadImage(currentIndex + 1);
  }

  void _preloadImage(int index) {
    if (_cachedIndexes.contains(index)) {
      return;
    }
    if (0 <= index && index < widget.sources.length) {
      final s = widget.sources[index];
      final url = s.isVideo ? s.thumbnail : s.url!;
      precacheImage(ExtendedNetworkImageProvider(url, cache: true), context);

      _cachedIndexes.add(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      child: ExtendedImageSlidePage(
        key: slidePagekey,
        slideAxis: SlideAxis.both,
        slideType: SlideType.wholePage,
        resetPageDuration: const Duration(milliseconds: 300),
        slidePageBackgroundHandler: (offset, pageSize) {
          double rate = 1 - (offset.dy.abs() / (size.height / 2));
          rate = rate > 0 ? rate : 0;
          return Colors.black.withOpacity(rate);
        },
        child: GestureDetector(
          onTap: () {
            slidePagekey.currentState!.popPage();
            Navigator.pop(context);
          },
          onLongPress: () => widget.onLongPress?.call(currentIndex),
          child: ExtendedImageGesturePageView.builder(
            controller: ExtendedPageController(
              initialPage: currentIndex,
              pageSpacing: 8,
              shouldIgnorePointerWhenScrolling: true,
            ),
            itemCount: widget.sources.length,
            onPageChanged: (int page) {
              _preloadImage(page - 1);
              _preloadImage(page + 1);
            },
            itemBuilder: (BuildContext context, int index) {
              final s = widget.sources[index];

              return s.isVideo
                  ? ExtendedImageSlidePageHandler(
                      child: VideoPlayerView(
                        url: s.url,
                        coverUrl: s.thumbnail,
                        file: s.file,
                        heroTag: s.tag,
                        autoPlay: widget.onAutoPlay?.call(index) ?? false,
                        muted: widget.muted,
                        onDownload: (url, file) => widget.onSave?.call(currentIndex),
                      ),
                      heroBuilderForSlidingPage: (Widget result) {
                        return Hero(
                          tag: s.tag ?? s.thumbnail,
                          child: result,
                          flightShuttleBuilder: (BuildContext flightContext,
                              Animation<double> animation,
                              HeroFlightDirection flightDirection,
                              BuildContext fromHeroContext,
                              BuildContext toHeroContext) {
                            final Hero hero = (flightDirection == HeroFlightDirection.pop
                                ? fromHeroContext.widget
                                : toHeroContext.widget) as Hero;

                            return hero.child;
                          },
                        );
                      },
                    )
                  : HeroWidget(
                      tag: s.tag ?? s.thumbnail,
                      slideType: SlideType.onlyImage,
                      slidePagekey: slidePagekey,
                      child: s.file != null && s.file!.existsSync()
                          ? ExtendedImage.file(
                              s.file!,
                              enableSlideOutPage: true,
                              fit: BoxFit.contain,
                              mode: ExtendedImageMode.gesture,
                            )
                          : ExtendedImage.network(
                              s.url ?? s.thumbnail,
                              enableSlideOutPage: true,
                              fit: BoxFit.contain,
                              mode: ExtendedImageMode.gesture,
                              initGestureConfigHandler: (ExtendedImageState state) {
                                return GestureConfig(
                                  minScale: 0.9,
                                  animationMinScale: 0.7,
                                  maxScale: 3.0,
                                  animationMaxScale: 3.5,
                                  speed: 1.0,
                                  inPageView: true,
                                  initialAlignment: InitialAlignment.center,
                                );
                              },
                              onDoubleTap: (state) {
                                final Offset? pointerDownPosition = state.pointerDownPosition;
                                final double? begin = state.gestureDetails!.totalScale;
                                double end;

                                _doubleClickAnimation?.removeListener(_doubleClickAnimationListener);

                                _doubleClickAnimationController.stop();

                                _doubleClickAnimationController.reset();

                                if (begin == doubleTapScales[0]) {
                                  end = doubleTapScales[1];
                                } else {
                                  end = doubleTapScales[0];
                                }

                                _doubleClickAnimationListener = () {
                                  state.handleDoubleTap(
                                      scale: _doubleClickAnimation!.value, doubleTapPosition: pointerDownPosition);
                                };
                                _doubleClickAnimation =
                                    _doubleClickAnimationController.drive(Tween<double>(begin: begin, end: end));

                                _doubleClickAnimation!.addListener(_doubleClickAnimationListener);

                                _doubleClickAnimationController.forward();
                              },
                              loadStateChanged: (state) {
                                if (state.extendedImageLoadState == LoadState.loading) {
                                  return Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      ExtendedImage.network(
                                        s.thumbnail,
                                        enableLoadState: false,
                                      ),
                                      const CupertinoActivityIndicator(
                                        radius: 15,
                                      ),
                                    ],
                                  );
                                } else if (state.extendedImageLoadState == LoadState.failed) {
                                  state.imageProvider.evict();

                                  return ImageRes.pictureError.toImage;
                                }
                                return null;
                              },
                            ),
                    );
            },
          ),
        ),
      ),
    );
  }
}

class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({
    super.key,
    this.path,
    this.url,
    this.coverUrl,
    this.file,
    this.heroTag,
    this.onDownload,
    this.autoPlay = true,
    this.muted = false,
  });
  final String? path;
  final String? url;
  final File? file;
  final String? coverUrl;
  final String? heroTag;
  final bool autoPlay;
  final bool muted;
  final Function(String? url, File? file)? onDownload;
  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late final player = Player();
  late final controller = VideoController(player);
  final _cacheManager = DefaultCacheManager();
  bool _showCover = true;

  @override
  void initState() {
    super.initState();
    player.stream.playing.listen((event) {
      if (event && _showCover) {
        setState(() {
          _showCover = false;
        });
      }
    });

    unawaited(_cacheManager.downloadFile(widget.url!));

    () async {
      final fileInfo = await _cacheManager.getFileFromCache(widget.url!);

      if (fileInfo?.file != null) {
        player.open(Media(fileInfo!.file.path));
      } else {
        player.open(Media(widget.url!));
      }
    }();
    media_kit_video_controls.kDefaultMaterialVideoControlsThemeDataFullscreen.copyWith();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MaterialVideoControlsTheme(
          normal: media_kit_video_controls.kDefaultMaterialVideoControlsThemeData.copyWith(
            bottomButtonBarMargin: const EdgeInsets.only(bottom: 70),
            seekBarMargin: const EdgeInsets.only(bottom: 60, left: 24, right: 24),
            seekBarThumbColor: Colors.white,
            seekBarPositionColor: Colors.white,
            bottomButtonBar: [
              const MaterialPlayOrPauseButton(),
              const MaterialPositionIndicator(),
              const Spacer(),
              MaterialCustomButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    _showActionSheet(context);
                  }),
            ],
          ),
          fullscreen: media_kit_video_controls.kDefaultMaterialVideoControlsThemeDataFullscreen,
          child: Video(
            controller: controller,
            fit: BoxFit.contain,
            controls: (state) {
              return CustomMKMaterialVideoControls(state);
            },
          ),
        ),
        if (_showCover) _buildCoverView(context)
      ],
    );
  }

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);
                final file = await _cacheManager.getFileFromCache(widget.url!);

                widget.onDownload?.call(widget.url, file?.file);
              },
              child: Text(StrRes.download),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            isDestructiveAction: true,
            child: Text(StrRes.cancel),
          ),
        );
      },
    );
  }

  Widget _buildCoverView(BuildContext context) {
    if (widget.coverUrl == null) {
      return const SizedBox.shrink();
    }

    final screenSize = MediaQuery.of(context).size;

    return Stack(
      alignment: Alignment.center,
      children: [
        ImageUtil.networkImage(
          url: widget.coverUrl!,
          loadProgress: false,
          height: screenSize.height,
          width: screenSize.width,
          fit: BoxFit.fitWidth,
        ),
        const CupertinoActivityIndicator(
          color: Colors.white,
          radius: 15,
        ),
      ],
    );
  }
}
