import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/utils/im_util.dart';
import 'package:uuid/uuid.dart';

class AvatarView extends StatelessWidget {
  const AvatarView({
    Key? key,
    this.visible = true,
    this.size,
    this.onTap,
    this.url,
    this.text,
    this.textStyle,
    this.onLongPress,
    this.isCircle = false,
    this.borderRadius,
    this.enabledPreview = false,
    this.lowMemory = true,
    this.isNineGrid = false,
    this.nineGridUrl = const [],
  }) : super(key: key);
  final bool visible;
  final double? size;
  final Function()? onTap;
  final Function()? onLongPress;
  final String? url;
  final bool isCircle;
  final BorderRadius? borderRadius;
  final enabledPreview;
  final String? text;
  final TextStyle? textStyle;
  final bool lowMemory;
  final bool isNineGrid;
  final List<String> nineGridUrl;

  @override
  Widget build(BuildContext context) {
    var tag = Uuid().v4();
    return Hero(
      tag: tag,
      child: ChatAvatarView(
        visible: visible,
        size: size ?? 42.h,
        onTap: onTap ??
            (enabledPreview
                ? () {
                    if (url != null && url!.trim().isNotEmpty) {
                      Get.to(() => IMUtil.previewPic(
                          tag: tag, picList: [PicInfo(url: url)]));
                    }
                  }
                : null),
        url: url,
        text: text,
        textStyle: textStyle,
        onLongPress: onLongPress,
        isCircle: isCircle,
        borderRadius: borderRadius,
        lowMemory: lowMemory,
        isNineGrid: false,
        nineGridUrls: [],
      ),
    );
  }

  AvatarView.nineGrid(
    this.visible,
    this.size,
    this.borderRadius,
    this.nineGridUrl,
  )   : lowMemory = false,
        url = null,
        isCircle = false,
        enabledPreview = false,
        isNineGrid = false,
        text = null,
        textStyle = null,
        onLongPress = null,
        onTap = null;
}
