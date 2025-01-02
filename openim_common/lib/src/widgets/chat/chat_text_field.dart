import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class ChatTextField extends StatelessWidget {
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final String? hintText;

  final TextStyle? style;
  final TextStyle? atStyle;
  final bool enabled;
  final TextAlign textAlign;

  const ChatTextField({
    Key? key,
    this.focusNode,
    this.controller,
    this.hintText,
    this.style,
    this.atStyle,
    this.enabled = true,
    this.textAlign = TextAlign.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedTextField(
      style: style,
      focusNode: focusNode,
      controller: controller,
      keyboardType: TextInputType.multiline,
      enabled: enabled,
      autofocus: false,
      minLines: 1,
      maxLines: 4,
      textAlign: textAlign,
      decoration: InputDecoration(
        border: InputBorder.none,
        isDense: true,
        hintText: hintText,
        hintStyle: Styles.ts_8E9AB0_17sp,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 4.w,
          vertical: 8.h,
        ),
      ),
    );
  }
}
