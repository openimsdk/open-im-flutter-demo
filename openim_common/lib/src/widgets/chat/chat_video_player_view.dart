import 'dart:async';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:video_player/video_player.dart';

import '../custom_cupertino_controls.dart';

abstract class VideoControllerService {
  Future<VideoPlayerController> getVideo(String videoUrl);
  Future<File?> getCacheFile(String videoUrl);
}

class CachedVideoControllerService extends VideoControllerService {
  final BaseCacheManager _cacheManager;

  CachedVideoControllerService(this._cacheManager);

  @override
  Future<VideoPlayerController> getVideo(String videoUrl) async {
    final file = await getCacheFile(videoUrl);

    if (file == null) {
      Logger.print('[VideoControllerService]: No video in cache');

      Logger.print('[VideoControllerService]: Saving video to cache');
      unawaited(_cacheManager.downloadFile(videoUrl));

      return VideoPlayerController.networkUrl(Uri.parse(videoUrl),
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
          httpHeaders: Platform.isAndroid
              ? {}
              : {
                  'AVURLAssetOutOfBandMIMETypeKey': 'video/mp4; codecs="avc1.42E01E, mp4a.40.2"',
                });
    } else {
      Logger.print('[VideoControllerService]: Loading video from cache');
      return VideoPlayerController.file(
        file,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
    }
  }

  @override
  Future<File?> getCacheFile(String videoUrl) async {
    final fileInfo = await _cacheManager.getFileFromCache(videoUrl);

    return fileInfo?.file;
  }
}

class ChatVideoPlayerView extends StatefulWidget {
  const ChatVideoPlayerView({
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
  State<ChatVideoPlayerView> createState() => _ChatVideoPlayerViewState();
}

class _ChatVideoPlayerViewState extends State<ChatVideoPlayerView> with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  final _cachedVideoControllerService = CachedVideoControllerService(DefaultCacheManager());

  @override
  void initState() {
    initializePlayer();
    super.initState();
  }

  @override
  void dispose() {
    Logger.print('[ChatVideoPlayerView]: dispose');

    () async {
      await _chewieController?.pause();
      await _videoPlayerController.pause();
      await _videoPlayerController.dispose();
      _chewieController?.dispose();
    }();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    var file = widget.file;

    if (file == null) {
      bool existFile = false;
      if (IMUtils.isNotNullEmptyStr(_path) && (await Permissions.checkStorage())) {
        file = File(_path!);
        existFile = await file.exists();
        if (!existFile) {
          file = null;
        }
      }
    }

    if (null != file && file.existsSync()) {
      _videoPlayerController = VideoPlayerController.file(
        file,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
    } else {
      _videoPlayerController = await _cachedVideoControllerService.getVideo(_url!);
    }

    await _videoPlayerController.initialize();
    if (widget.muted) {
      _videoPlayerController.setVolume(0);
    }
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: widget.autoPlay,
      looping: false,
      allowFullScreen: false,
      allowPlaybackSpeedChanging: false,
      showControlsOnInitialize: true,
      customControls: CustomCupertinoControls(backgroundColor: Colors.black.withOpacity(0.7), iconColor: Colors.white),
      optionsTranslation: OptionsTranslation(
        playbackSpeedButtonText: StrRes.playSpeed,
        cancelButtonText: StrRes.cancel,
      ),
      additionalOptions: (context) => [
        OptionItem(
          onTap: () async {
            final file = await _cachedVideoControllerService.getCacheFile(widget.url!);
            widget.onDownload?.call(widget.url, file);
            Get.back();
          },
          iconData: Icons.download_outlined,
          title: StrRes.download,
        ),
      ],
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  Future<void> toggleVideo() async {
    await _videoPlayerController.pause();
    await initializePlayer();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          if (_chewieController != null && _chewieController!.videoPlayerController.value.isInitialized)
            Chewie(controller: _chewieController!)
          else
            _buildCoverView(context),
        ],
      ),
    );
  }

  Widget _buildCoverView(BuildContext context) => null != widget.coverUrl
      ? Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: ImageUtil.networkImage(
                  url: widget.coverUrl!,
                  loadProgress: false,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fitWidth),
            ),
            const Center(
              child: CupertinoActivityIndicator(
                color: Colors.white,
                radius: 15,
              ),
            ),
          ],
        )
      : Container();

  String? get _path => widget.path;

  String? get _url => widget.url;
}
