import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:openim_common/openim_common.dart';

class ChatFacePreview extends StatelessWidget {
  const ChatFacePreview({
    Key? key,
    required this.url,
  }) : super(key: key);
  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrRes.emoji),
      backgroundColor: Styles.c_FFFFFF,
      body: Center(
        child: _networkGestureImage(url),
      ),
    );
  }

  Widget _networkGestureImage(String url) => ExtendedImage.network(
        url,
        fit: BoxFit.contain,
        mode: ExtendedImageMode.gesture,
        clearMemoryCacheWhenDispose: true,
        clearMemoryCacheIfFailed: true,
        handleLoadingProgress: true,
        enableSlideOutPage: true,
        initGestureConfigHandler: (ExtendedImageState state) {
          return GestureConfig(
            inPageView: true,
            initialScale: 1.0,
            maxScale: 5.0,
            animationMaxScale: 6.0,
            initialAlignment: InitialAlignment.center,
          );
        },
        loadStateChanged: (ExtendedImageState state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              {
                final ImageChunkEvent? loadingProgress = state.loadingProgress;
                final double? progress = loadingProgress?.expectedTotalBytes != null
                    ? loadingProgress!.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null;

                return SizedBox(
                  width: 15.0,
                  height: 15.0,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Styles.c_0089FF,
                      strokeWidth: 1.5,
                      value: progress ?? 0,
                    ),
                  ),
                );
              }
            case LoadState.completed:
              return null;
            case LoadState.failed:
              state.imageProvider.evict();
              return ImageRes.pictureError.toImage;
          }
        },
      );
}
