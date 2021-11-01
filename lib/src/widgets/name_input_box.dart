import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_enterprise_chat/src/res/images.dart';

class NameInputBox extends StatelessWidget {
  const NameInputBox({
    Key? key,
    this.controller,
    this.topLabel,
    this.leftLabel,
    this.topLabelStyle,
    this.leftLabelStyle,
    this.textStyle,
    this.hintText,
    this.hintStyle,
    this.clearBtnColor,
    this.showClearBtn = false,
  }) : super(key: key);
  final String? topLabel;
  final String? leftLabel;
  final String? hintText;
  final TextStyle? topLabelStyle;
  final TextStyle? leftLabelStyle;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Color? clearBtnColor;
  final bool showClearBtn;
  final TextEditingController? controller;

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
          if (null != topLabel)
            Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Text(
                topLabel!,
                style: topLabelStyle,
              ),
            ),
          Container(
            height: 28.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (null != leftLabel)
                  Padding(
                    padding: EdgeInsets.only(right: 39.w),
                    child: Text(
                      leftLabel!,
                      style: leftLabelStyle,
                    ),
                  ),
                Expanded(child: _textField()),
                _clearBtn(),
              ],
            ),
          ),
          SizedBox(height: 6.h),
        ],
      ),
    );
  }

  Widget _textField() => TextField(
        controller: controller,
        // keyboardType: TextInputType.phone,
        // textInputAction: TextInputAction.next,
        style: textStyle,
        // inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
        decoration: InputDecoration(
          hintText: hintText,
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
            controller?.clear();
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
}
