import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/utils/im_util.dart';

class AvatarView extends StatelessWidget {
  const AvatarView({
    Key? key,
    this.visible = true,
    this.size = 42.0,
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
  final double size;
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
    return ChatAvatarView(
        visible: visible,
        size: size,
        onTap: onTap ??
            (enabledPreview
                ? () {
                    if (url != null && url!.trim().isNotEmpty) {
                      Get.to(() => IMUtil.previewPic(id: url!, url: url));
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
