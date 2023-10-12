import 'dart:async';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:video_player/video_player.dart';

abstract class VideoControllerService {
  Future<VideoPlayerController> getVideo(String videoUrl);
}

class CachedVideoControllerService extends VideoControllerService {
  final BaseCacheManager _cacheManager;

  CachedVideoControllerService(this._cacheManager);

  @override
  Future<VideoPlayerController> getVideo(String videoUrl) async {
    final fileInfo = await _cacheManager.getFileFromCache(videoUrl);

    if (fileInfo == null) {
      Logger.print('[VideoControllerService]: No video in cache');

      Logger.print('[VideoControllerService]: Saving video to cache');
      unawaited(_cacheManager.downloadFile(videoUrl));

      return VideoPlayerController.network(videoUrl);
    } else {
      Logger.print('[VideoControllerService]: Loading video from cache');
      return VideoPlayerController.file(fileInfo.file);
    }
  }
}

class ChatVideoPlayerView extends StatefulWidget {
  const ChatVideoPlayerView({
    Key? key,
    this.path,
    this.url,
    this.coverUrl,
    this.heroTag,
    this.oDownload,
  }) : super(key: key);
  final String? path;
  final String? url;
  final String? coverUrl;
  final String? heroTag;
  final Function(String? url)? oDownload;

  @override
  State<ChatVideoPlayerView> createState() => _ChatVideoPlayerViewState();
}

class _ChatVideoPlayerViewState extends State<ChatVideoPlayerView> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  final _cachedVideoControllerService =
      CachedVideoControllerService(DefaultCacheManager());

  @override
  void initState() {
    initializePlayer();
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    File? file;
    bool existFile = false;
    if (IMUtils.isNotNullEmptyStr(_path) &&
        (await Permissions.checkStorage())) {
      file = File(_path!);
      existFile = await file.exists();
      if (!existFile) {
        file = null;
      }
    }

    if (null != file) {
      _videoPlayerController = VideoPlayerController.file(file);
    } else {
      _videoPlayerController =
          await _cachedVideoControllerService.getVideo(_url!);
    }

    await _videoPlayerController.initialize();

    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      showControlsOnInitialize: true,
      customControls: const CustomMaterialControls(),
      optionsTranslation: OptionsTranslation(
        playbackSpeedButtonText: StrRes.playSpeed,
        cancelButtonText: StrRes.cancel,
      ),
      additionalOptions: (context) => [
        OptionItem(
          onTap: () {
            widget.oDownload?.call(widget.url);
            Get.back();
          },
          iconData: Icons.download,
          title: StrRes.download,
        ),
      ],
    );
  }

  Future<void> toggleVideo() async {
    await _videoPlayerController.pause();
    await initializePlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: widget.heroTag != null
          ? Hero(tag: widget.heroTag!, child: _buildChildView())
          : _buildChildView(),
    );
  }

  Widget _buildChildView() => SafeArea(
        child: Stack(
          children: [
            if (_chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized)
              Chewie(controller: _chewieController!)
            else
              _buildCoverView(),
          ],
        ),
      );

  Widget _buildCoverView() => Stack(
        alignment: Alignment.center,
        children: [
          if (null != widget.coverUrl)
            Center(
              child: ImageUtil.networkImage(
                url: widget.coverUrl!,
                loadProgress: false,
              ),
            ),
          const CircularProgressIndicator(),
        ],
      );

  String? get _path => widget.path;

  String? get _url => widget.url;
}
