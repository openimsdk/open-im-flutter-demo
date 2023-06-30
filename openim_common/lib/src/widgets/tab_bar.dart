import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    Key? key,
    required this.index,
    required this.labels,
    this.selectedStyle,
    this.unselectedStyle,
    this.indicatorColor,
    this.indicatorHeight,
    this.indicatorWidth,
    this.onTabChanged,
    this.height,
    this.showUnderline = false,
  }) : super(key: key);
  final int index;
  final List<String> labels;
  final TextStyle? selectedStyle;
  final TextStyle? unselectedStyle;
  final double? height;
  final Color? indicatorColor;
  final double? indicatorHeight;
  final double? indicatorWidth;
  final Function(int index)? onTabChanged;
  final bool showUnderline;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Styles.c_FFFFFF,
        border: showUnderline
            ? BorderDirectional(
                bottom: BorderSide(color: Styles.c_E8EAEF, width: 1))
            : null,
      ),
      child: Row(
        children: List.generate(labels.length, (i) => _buildItemView(i)),
      ),
    );
  }

  Widget _buildItemView(int i) => Expanded(
        child: GestureDetector(
          onTap: () {
            if (null != onTabChanged) onTabChanged!(i);
          },
          behavior: HitTestBehavior.translucent,
          child: SizedBox(
            height: height ?? 42.h,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: labels.elementAt(i).toText
                    ..style = Styles.ts_0C1C33_17sp,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Visibility(
                    visible: i == index,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 4.h),
                      decoration: BoxDecoration(
                        color: Styles.c_0C1C33,
                        borderRadius: BorderRadius.circular(1.5.r),
                      ),
                      height: indicatorHeight ?? 3.h,
                      width: indicatorWidth ?? 20.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class TabInfo {
  String label;
  TextStyle styleSel;
  TextStyle styleUnsel;
  double iconHeight;
  double iconWidth;
  String iconSel;
  String iconUnsel;

  TabInfo({
    required this.label,
    required this.styleSel,
    required this.styleUnsel,
    required this.iconSel,
    required this.iconUnsel,
    required this.iconHeight,
    required this.iconWidth,
  });
}
