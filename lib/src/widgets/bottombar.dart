import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_demo/src/res/styles.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    Key? key,
    this.index = 0,
    required this.items,
  }) : super(key: key);
  final int index;
  final List<BottomBarItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.only(
      //   bottom: MediaQuery.of(context).padding.bottom,
      // ),
      child: Container(
        height: 49.h + MediaQuery.of(context).padding.bottom,
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          boxShadow: [
            BoxShadow(
              color: PageStyle.c_000000_opacity12p,
              offset: Offset(0, -1),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: List.generate(
              items.length,
              (index) => _buildItemView(
                    i: index,
                    item: items.elementAt(index),
                  )).toList(),
        ),
      ),
    );
  }

  Widget _buildItemView({required int i, required BottomBarItem item}) => Expanded(
        child: GestureDetector(
          onTap: () {
            if (item.onClick != null) item.onClick!(i);
          },
          behavior: HitTestBehavior.translucent,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 32.h,
                child: Text(
                  item.label,
                  style: i == index
                      ? (item.selectedStyle ?? PageStyle.ts_1B72EC_10sp)
                      : (item.unselectedStyle ?? PageStyle.ts_1B72EC_10sp),
                ),
              ),
              Positioned(
                top: 6.h,
                child: Image.asset(
                  i == index ? item.selectedImgRes : item.unselectedImgRes,
                  width: item.imgWidth,
                  height: item.imgHeight,
                ),
              ),
              Positioned(
                top: 3.h,
                child: Container(
                  padding: EdgeInsets.only(left: 15.w),
                  child: UnreadCountView(
                    count: item.count?.toInt() ?? 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class BottomBarItem {
  final String selectedImgRes;
  final String unselectedImgRes;
  final String label;
  final TextStyle? selectedStyle;
  final TextStyle? unselectedStyle;
  final double imgWidth;
  final double imgHeight;
  final Function(int index)? onClick;
  final Stream<int>? steam;
  final int? count;

  BottomBarItem(
      {required this.selectedImgRes,
      required this.unselectedImgRes,
      required this.label,
      this.selectedStyle,
      this.unselectedStyle,
      required this.imgWidth,
      required this.imgHeight,
      this.onClick,
      this.steam,
      this.count});
}
