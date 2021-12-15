import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_enterprise_chat/src/res/images.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';

class PhoneEmailInputBox extends StatelessWidget {
  const PhoneEmailInputBox({
    Key? key,
    required this.phoneController,
    required this.emailController,
    this.emailFocusNode,
    this.phoneFocusNode,
    required this.labelStyle,
    required this.labelSelectedStyle,
    required this.textStyle,
    required this.hintStyle,
    required this.codeStyle,
    required this.code,
    this.arrowColor,
    this.clearBtnColor,
    this.indicatorColor,
    this.showClearBtn = false,
    this.index = 0,
    this.onChanged,
    this.onAreaCode,
  }) : super(key: key);
  final TextStyle labelStyle;
  final TextStyle labelSelectedStyle;
  final TextStyle textStyle;
  final TextStyle hintStyle;
  final TextStyle codeStyle;
  final String code;
  final Color? arrowColor;
  final Color? clearBtnColor;
  final Color? indicatorColor;
  final bool showClearBtn;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final FocusNode? phoneFocusNode;
  final FocusNode? emailFocusNode;
  final int index;
  final ValueChanged<int>? onChanged;
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
          Row(
            children: [
              _buildTabItem(
                label: StrRes.phoneNum,
                checked: index == 0,
                onTap: () => onChanged?.call(0),
              ),
              SizedBox(
                width: 34.w,
              ),
              _buildTabItem(
                label: StrRes.email,
                checked: index == 1,
                onTap: () => onChanged?.call(1),
              ),
            ],
          ),
          Container(
            height: 28.h,
            child: index == 0 ? _buildPhoneView() : _buildEmailView(),
          ),
          SizedBox(height: 6.h),
        ],
      ),
    );
  }

  Widget _buildEmailView() => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: _textEmailField()),
          _clearBtn(),
        ],
      );

  Widget _buildPhoneView() => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _areaCodeView(),
          Expanded(child: _textPhoneField()),
          _clearBtn(),
        ],
      );

  Widget _buildTabItem(
          {required String label, required bool checked, Function()? onTap}) =>
      GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: Container(
          margin: EdgeInsets.only(bottom: 32.h),
          padding: EdgeInsets.only(bottom: 4.h),
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(1.75),
            border: BorderDirectional(
              bottom: BorderSide(
                color: checked ? indicatorColor ?? Colors.white : Colors.white,
              ),
            ),
          ),
          child: Text(
            label,
            style: checked ? labelSelectedStyle : labelStyle,
          ),
        ),
      );

  Widget _textEmailField() => TextField(
        controller: emailController,
        focusNode: emailFocusNode,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        style: textStyle,
        autofocus: index == 1,
        // inputFormatters: [
        //   FilteringTextInputFormatter.allow(RegExp(
        //       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$'))
        // ],
        decoration: InputDecoration(
          hintText: StrRes.plsInputEmail,
          hintStyle: hintStyle,
          isDense: true,
          contentPadding: EdgeInsets.all(0),
          border: InputBorder.none,
        ),
      );

  Widget _textPhoneField() => TextField(
        controller: phoneController,
        focusNode: phoneFocusNode,
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
        style: textStyle,
        autofocus: index == 0,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          hintText: StrRes.plsInputPhone,
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
            if (index == 0) {
              phoneController.clear();
            } else {
              emailController.clear();
            }
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
