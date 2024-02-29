import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

class BottomSheetView extends StatelessWidget {
  const BottomSheetView({
    Key? key,
    required this.items,
    this.itemHeight,
    this.textStyle,
    this.mainAxisAlignment,
    this.isOverlaySheet = false,
    this.onCancel,
  }) : super(key: key);
  final List<SheetItem> items;
  final double? itemHeight;
  final TextStyle? textStyle;
  final MainAxisAlignment? mainAxisAlignment;
  final bool isOverlaySheet;
  final Function()? onCancel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: items.map(_parseItem).toList(),
              ),
            ),
            10.verticalSpace,
            _itemBgView(
              label: StrRes.cancel,
              onTap: isOverlaySheet ? onCancel : () => Get.back(),
              borderRadius: BorderRadius.circular(6.r),
              alignment: MainAxisAlignment.center,
            ),
            10.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _parseItem(SheetItem item) {
    BorderRadius? borderRadius;
    int length = items.length;
    bool isLast = items.indexOf(item) == items.length - 1;
    bool isFirst = items.indexOf(item) == 0;
    if (length == 1) {
      borderRadius = item.borderRadius ?? BorderRadius.circular(6.r);
    } else {
      borderRadius = item.borderRadius ??
          BorderRadius.only(
            topLeft: isFirst ? Radius.circular(6.r) : Radius.zero,
            topRight: isFirst ? Radius.circular(6.r) : Radius.zero,
            bottomLeft: isLast ? Radius.circular(6.r) : Radius.zero,
            bottomRight: isLast ? Radius.circular(6.r) : Radius.zero,
          );
    }
    return _itemBgView(
        label: item.label,
        textStyle: item.textStyle,
        icon: item.icon,
        alignment: item.alignment,
        line: !isLast,
        borderRadius: borderRadius,
        onTap: () {
          if (!isOverlaySheet) Get.back(result: item.result);
          item.onTap?.call();
        });
  }

  Widget _itemBgView({
    required String label,
    String? icon,
    Function()? onTap,
    BorderRadius? borderRadius,
    TextStyle? textStyle,
    MainAxisAlignment? alignment,
    bool line = false,
  }) =>
      Ink(
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          borderRadius: borderRadius,
        ),
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: line
                ? BoxDecoration(
                    border: BorderDirectional(
                      bottom: BorderSide(color: Styles.c_E8EAEF, width: 0.5),
                    ),
                  )
                : null,
            height: itemHeight ?? 56.h,
            child: Row(
              mainAxisAlignment:
                  alignment ?? mainAxisAlignment ?? MainAxisAlignment.center,
              children: [
                if (null != icon) 10.horizontalSpace,
                if (null != icon) _image(icon),
                if (null != icon) 5.horizontalSpace,
                _text(label, textStyle),
              ],
            ),
          ),
        ),
      );

  _text(String label, TextStyle? style) =>
      label.toText..style = (style ?? textStyle ?? Styles.ts_0C1C33_17sp);

  _image(String icon) => icon.toImage
    ..width = 24.w
    ..height = 24.h;
}

class SheetItem {
  final String label;
  final TextStyle? textStyle;
  final String? icon;
  final Function()? onTap;
  final BorderRadius? borderRadius;
  final MainAxisAlignment? alignment;
  final dynamic result;

  SheetItem({
    required this.label,
    this.textStyle,
    this.icon,
    this.onTap,
    this.borderRadius,
    this.alignment,
    this.result,
  });
}
