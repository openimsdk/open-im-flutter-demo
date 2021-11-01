import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_enterprise_chat/src/res/images.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';

class PhoneInputBox extends StatelessWidget {
  const PhoneInputBox({
    Key? key,
    required this.controller,
    required this.labelStyle,
    required this.textStyle,
    required this.hintStyle,
    required this.codeStyle,
    required this.code,
    this.arrowColor,
    this.clearBtnColor,
    this.showClearBtn = false,
  }) : super(key: key);
  final TextStyle labelStyle;
  final TextStyle textStyle;
  final TextStyle hintStyle;
  final TextStyle codeStyle;
  final String code;
  final Color? arrowColor;
  final Color? clearBtnColor;
  final bool showClearBtn;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: BorderDirectional(
          bottom: BorderSide(
            color: Color(0xFFD8D8D8),
            width: 0.5.h,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            StrRes.phoneNum,
            style: labelStyle,
          ),
          SizedBox(height: 10.h),
          Container(
            height: 28.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _areaCodeView(),
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
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
        style: textStyle,
        autofocus: true,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
        decoration: InputDecoration(
          hintText: StrRes.plsInputPhone,
          hintStyle: hintStyle,
          isDense: true,
          contentPadding: EdgeInsets.all(0),
          border: InputBorder.none,
        ),
      );

  Widget _areaCodeView() => GestureDetector(
        onTap: () {},
        behavior: HitTestBehavior.translucent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              code,
              style: codeStyle,
            ),
            SizedBox(width: 10.w),
            Image.asset(
              ImageRes.ic_areaCodeMoreArrow,
              color: arrowColor,
              width: 16.w,
              height: 10.h,
            ),
            SizedBox(width: 20.w),
            Container(
              width: 1.w,
              height: 16.h,
              decoration: BoxDecoration(
                color: Color(0xFFD8D8D8).withOpacity(0.4),
                borderRadius: BorderRadius.circular(0.5),
              ),
            ),
            SizedBox(width: 19.w),
          ],
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
}
