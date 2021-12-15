import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_enterprise_chat/src/res/images.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';

enum InputWay { phone, email }

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
    this.inputWay = InputWay.phone,
    this.onAreaCode,
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
  final InputWay inputWay;
  final Function()? onAreaCode;

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
            inputWay == InputWay.phone ? StrRes.phoneNum : StrRes.email,
            style: labelStyle,
          ),
          SizedBox(height: 10.h),
          Container(
            height: 28.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (inputWay == InputWay.phone) _areaCodeView(),
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
        keyboardType: inputWay == InputWay.phone
            ? TextInputType.phone
            : TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        style: textStyle,
        autofocus: true,
        inputFormatters: inputWay == InputWay.phone
            ? [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ]
            : null,
        decoration: InputDecoration(
          hintText: inputWay == InputWay.phone
              ? StrRes.plsInputPhone
              : StrRes.plsInputEmail,
          hintStyle: hintStyle,
          isDense: true,
          contentPadding: EdgeInsets.all(0),
          border: InputBorder.none,
        ),
      );

  Widget _areaCodeView() => GestureDetector(
        onTap: onAreaCode,
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
