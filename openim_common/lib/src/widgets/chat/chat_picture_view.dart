import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';
import 'package:path_provider/path_provider.dart';

class ChatPictureView extends StatefulWidget {
  const ChatPictureView({
    Key? key,
    required this.message,
    required this.isISend,
  }) : super(key: key);
  final bool isISend;
  final Message message;

  @override
  State<ChatPictureView> createState() => _ChatPictureViewState();
}

class _ChatPictureViewState extends State<ChatPictureView> {
  String? _sourcePath;
  String? _sourceUrl;

  String? _snapshotUrl;
  late double _trulyWidth;
  late double _trulyHeight;

  Message get _message => widget.message;

  Widget? _child;

  @override
  void initState() {
    final picture = _message.pictureElem;
    _sourcePath = picture?.sourcePath;

    _sourceUrl = picture?.bigPicture?.url;
    final snap = picture?.snapshotPicture?.url;
    _snapshotUrl = snap?.adjustThumbnailAbsoluteString(960);

    var w = picture?.sourcePicture?.width?.toDouble() ?? 1.0;
    var h = picture?.sourcePicture?.height?.toDouble() ?? 1.0;

    if (pictureWidth > w) {
      _trulyWidth = w;
      _trulyHeight = h;
    } else {
      _trulyWidth = pictureWidth;
      _trulyHeight = _trulyWidth * h / w;
    }

    final height = pictureWidth * 1.sh / 1.sw;

    if (_trulyHeight > 2 * height) {
      _trulyHeight = _trulyWidth;
    }

    if (Platform.isIOS) {
      if (_sourcePath?.contains('/Library/Caches/') == true) {
        getApplicationCacheDirectory().then((value) {
          final path = _sourcePath!.split('/Library/Caches').last;
          _sourcePath = value.path + path;
          _createChildView();
        });
      } else {
        _createChildView();
      }
    } else {
      _createChildView();
    }
    super.initState();
  }

  Future<bool> _checkingPath() async {
    var valid = IMUtils.isNotNullEmptyStr(_sourcePath);
    if (!valid) {
      return false;
    }
    if (Platform.isIOS) {
      final exist = await File(_sourcePath!).exists();
      valid = valid && exist;
    } else {
      valid = valid && File(_sourcePath!).existsSync();
    }
    _message.exMap['validPath_$_sourcePath'] = valid;

    return valid;
  }

  bool? get isValidPath => _message.exMap['validPath_$_sourcePath'];

  _createChildView() async {
    if (widget.isISend && (isValidPath == true || isValidPath == null && await _checkingPath())) {
      _child = _buildPathPicture(path: _sourcePath!);
    } else if (IMUtils.isNotNullEmptyStr(_snapshotUrl)) {
      _child = _buildUrlPicture(url: _snapshotUrl!);
    } else if (IMUtils.isNotNullEmptyStr(_sourceUrl)) {
      _child = _buildUrlPicture(url: _sourceUrl!);
    }
    if (null != _child) {
      if (!mounted) return;
      setState(() {});
    }
  }

  Widget _buildUrlPicture({required String url}) => ImageUtil.networkImage(
        url: url,
        height: _trulyHeight,
        width: _trulyWidth,
        fit: BoxFit.fitWidth,
      );

  Widget _buildPathPicture({required String path}) => Stack(
        children: [
          ImageUtil.fileImage(
            file: File(path),
            height: _trulyHeight,
            width: _trulyWidth,
            fit: BoxFit.fitWidth,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final child = ClipRRect(
      borderRadius: borderRadius(widget.isISend),
      child: SizedBox(width: _trulyWidth, height: _trulyHeight, child: _child),
    );
    return child;
  }
}
