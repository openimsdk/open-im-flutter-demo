import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_enterprise_chat/src/res/styles.dart';

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
      decoration: showUnderline
          ? BoxDecoration(
              border: BorderDirectional(
                bottom: BorderSide(color: PageStyle.c_D8D8D8),
              ),
            )
          : null,
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
          child: Container(
            height: height ?? 53.h,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    labels.elementAt(i),
                    style: i == index
                        ? PageStyle.ts_333333_16sp
                        : PageStyle.ts_333333_16sp,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Visibility(
                    visible: i == index,
                    child: Container(
                      height: indicatorHeight ?? 3.h,
                      width: indicatorWidth ?? 34.h,
                      color: indicatorColor ?? PageStyle.c_1D6BED,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class CustomTabBar2 extends StatelessWidget {
  const CustomTabBar2({
    Key? key,
    required this.tabs,
    this.index = 0,
    this.onTabChanged,
    this.margin,
  }) : super(key: key);
  final List<TabInfo> tabs;
  final int index;
  final Function(int index)? onTabChanged;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          tabs.length,
          (i) => GestureDetector(
            onTap: () {
              if (null != onTabChanged) onTabChanged!(i);
            },
            behavior: HitTestBehavior.translucent,
            child: Column(
              children: [
                Image.asset(
                  index == i ? tabs[i].iconSel : tabs[i].iconUnsel,
                  width: tabs[i].iconWidth,
                  height: tabs[i].iconHeight,
                ),
                SizedBox(
                  height: 9.h,
                ),
                Text(
                  tabs[i].label,
                  style: index == i ? tabs[i].styleSel : tabs[i].styleUnsel,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
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
