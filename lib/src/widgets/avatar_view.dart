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
    this.isCircle = true,
    this.borderRadius,
    this.enabledPreview = false,
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

  @override
  Widget build(BuildContext context) {
    var uuid = Uuid().v4();
    return ChatAvatarView(
        visible: visible,
        size: size ?? 42.h,
        onTap: onTap ??
            (enabledPreview
                ? () {
                    if (url != null && url!.trim().isNotEmpty) {
                      Get.to(() => IMUtil.previewPic(tag: uuid, url: url));
                    }
                  }
                : null),
        url: url,
        text: text,
        textStyle: textStyle,
        onLongPress: onLongPress,
        isCircle: isCircle,
        borderRadius: borderRadius);
  }
}
