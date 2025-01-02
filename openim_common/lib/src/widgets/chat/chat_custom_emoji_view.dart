import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:openim_common/openim_common.dart';

class ChatCustomEmojiView extends StatelessWidget {
  const ChatCustomEmojiView({
    Key? key,
    this.index,
    this.data,
    this.heroTag,
    required this.isISend,
  }) : super(key: key);

  final int? index;

  final String? data;
  final bool isISend;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    try {
      if (data != null) {
        var map = json.decode(data!);
        var url = map['url'];
        var w = map['width'] ?? 1.0;
        var h = map['height'] ?? 1.0;
        if (w is int) {
          w = w.toDouble();
        }
        if (h is int) {
          h = h.toDouble();
        }
        double trulyWidth;
        double trulyHeight;
        if (pictureWidth < w) {
          trulyWidth = pictureWidth;
          trulyHeight = trulyWidth * h / w;
        } else {
          trulyWidth = w;
          trulyHeight = h;
        }
        final child = ClipRRect(
          borderRadius: borderRadius(isISend),
          child: ImageUtil.networkImage(
            url: url,
            width: trulyWidth,
            height: trulyHeight,
            fit: BoxFit.fitWidth,
          ),
        );
        return null != heroTag ? Hero(tag: heroTag!, child: child) : child;
      }
    } catch (e, s) {
      Logger.print('e:$e  s:$s');
    }

    return Container();
  }
}
