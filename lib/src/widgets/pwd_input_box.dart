import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_enterprise_chat/src/res/images.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';

class PwdInputBox extends StatelessWidget {
  const PwdInputBox({
    Key? key,
    required this.controller,
    required this.labelStyle,
    required this.textStyle,
    required this.hintStyle,
    this.clearBtnColor,
    this.eyesBtnColor,
    this.showClearBtn = false,
    this.obscureText = true,
    this.onClickEyesBtn,
    this.inputFormatters,
    this.maxLength,
    this.autofocus = false,
  }) : super(key: key);
  final TextStyle labelStyle;
  final TextStyle textStyle;
  final TextStyle hintStyle;
  final Color? eyesBtnColor;
  final Color? clearBtnColor;
  final bool showClearBtn;
  final bool obscureText;
  final TextEditingController controller;
  final Function? onClickEyesBtn;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: BorderDirectional(
          bottom: BorderSide(
            color: Color(0xFFD8D8D8),
            width: 1.h,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            StrRes.pwd,
            style: labelStyle,
          ),
          SizedBox(height: 10.h),
          Container(
            height: 28.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: _textField()),
                _clearBtn(),
                SizedBox(width: 14.w),
                _eyesBtn(),
              ],
            ),
          ),
          SizedBox(height: 6.h),
        ],
      ),
    );
  }

  /// [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))]
  Widget _textField() => TextField(
        controller: controller,
        // keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
        style: textStyle,
        obscureText: obscureText,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        autofocus: autofocus,
        decoration: InputDecoration(
          hintText: StrRes.plsInputPwd,
          hintStyle: hintStyle,
          isDense: true,
          contentPadding: EdgeInsets.all(0),
          border: InputBorder.none,
        ),
      );

  Widget _clearBtn() => Visibility(
        visible: showClearBtn,
        child: GestureDetector(
          onTap: () {
            controller.clear();
          },
          behavior: HitTestBehavior.translucent,
          child: Container(
            // padding: EdgeInsets.all(7.w),
            child: Image.asset(
              ImageRes.ic_clearInput,
              color: clearBtnColor,
              width: 14.w,
              height: 14.w,
            ),
          ),
        ),
      );

  Widget _eyesBtn() => GestureDetector(
        onTap: () {
          onClickEyesBtn?.call();
        },
        behavior: HitTestBehavior.translucent,
        child: Container(
          // padding: EdgeInsets.all(7.w),
          child: Image.asset(
            obscureText ? ImageRes.ic_eyeClose : ImageRes.ic_eyeOpen,
            color: eyesBtnColor,
            width: 20.w,
            height: 12.w,
          ),
        ),
      );
}
