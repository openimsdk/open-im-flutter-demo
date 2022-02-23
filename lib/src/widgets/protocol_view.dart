import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/widgets/radio_button.dart';

class ProtocolView extends StatelessWidget {
  const ProtocolView({
    Key? key,
    required this.isChecked,
    required this.radioStyle,
    required this.style1,
    required this.style2,
    this.onTap,
    this.margin,
  }) : super(key: key);

  final bool isChecked;
  final RadioStyle radioStyle;
  final Function()? onTap;
  final TextStyle style1;
  final TextStyle style2;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 19.h, left: 48.w, right: 48.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: '',
                children: [
                  WidgetSpan(
                    child: Container(
                      margin: EdgeInsets.only(right: 6.w),
                      child: RadioButton(
                        isChecked: isChecked,
                        style: radioStyle,
                        onTap: onTap,
                      ),
                    ),
                  ),
                  TextSpan(
                    text: StrRes.iReadAgree,
                    style: style1,
                  ),
                  TextSpan(
                    text: StrRes.serviceAgreement,
                    style: style2,
                  ),
                  TextSpan(
                    text: StrRes.privacyPolicy,
                    style: style2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
