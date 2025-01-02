import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ThumbnailViewer extends StatefulWidget {
  final String? thumbnailUrl;
  final String? imageUrl;
  final File? thumbnailFile;
  final File? imageFile;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  ThumbnailViewer({this.thumbnailUrl, this.imageUrl, this.thumbnailFile, this.imageFile, this.onTap, this.onLongPress});

  @override
  _ThumbnailViewerState createState() => _ThumbnailViewerState();
}

class _ThumbnailViewerState extends State<ThumbnailViewer> {
  bool showThumbnail = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: Center(
        child: showThumbnail
            ? (widget.thumbnailFile != null
                ? ExtendedImage.file(
                    widget.thumbnailFile!,
                  )
                : ExtendedImage.network(
                    widget.thumbnailUrl!,
                    fit: BoxFit.cover,
                    loadStateChanged: (state) {
                      if (state.extendedImageLoadState == LoadState.completed) {
                        setState(() {
                          showThumbnail = false;
                        });
                      }
                      return null;
                    },
                  ))
            : (widget.imageFile != null
                ? ExtendedImage.file(widget.imageFile!)
                : ExtendedImage.network(
                    widget.imageUrl!,
                  )),
      ),
    );
  }
}
