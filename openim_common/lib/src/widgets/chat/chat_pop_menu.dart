import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class MenuInfo {
  String icon;
  String text;
  Function()? onTap;
  bool enabled;

  MenuInfo({
    required this.icon,
    required this.text,
    this.onTap,
    this.enabled = true,
  });
}

class ChatLongPressMenu extends StatelessWidget {
  final CustomPopupMenuController? popupMenuController;
  final List<MenuInfo> menus;

  const ChatLongPressMenu({
    Key? key,
    required this.popupMenuController,
    required this.menus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 256.w, maxHeight: 122.h),
      decoration: BoxDecoration(
        color: Styles.c_0C1C33_opacity85,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(15.w, 6.h, 15.w, 3.h),
        child: Wrap(
          children: menus
              .map((e) => _menuItem(
                    icon: e.icon,
                    label: e.text,
                    onTap: e.onTap,
                  ))
              .toList(),
        ),
      ),
      /*child: GridView.count(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 7.h),
        crossAxisCount: count,
        crossAxisSpacing: 4.w,
        mainAxisSpacing: 4.h,
        childAspectRatio: 42 / 52,
        children: menus
            .map((e) => _menuItem(
                  icon: e.icon,
                  label: e.text,
                  onTap: e.onTap,
                ))
            .toList(),
      ),*/
    );
  }

  Widget _menuItem({
    required String icon,
    required String label,
    Function()? onTap,
  }) =>
      GestureDetector(
        onTap: () {
          popupMenuController?.hideMenu();
          onTap?.call();
        },
        behavior: HitTestBehavior.translucent,
        child: SizedBox(
          width: 42.w,
          height: 52.h,
          child: _MenuItemView(icon: icon, label: label),
        ),
        /*child: SizedBox(
          width: 42.w,
          height: 52.h,
          child: _MenuItemView(icon: icon, label: label),
        ),*/
      );
}

class _MenuItemView extends StatelessWidget {
  const _MenuItemView({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);
  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        icon.toImage
          ..width = 28.w
          ..height = 28.h,
        label.toText
          ..style = Styles.ts_FFFFFF_10sp
          ..maxLines = 1
          ..overflow = TextOverflow.ellipsis,
      ],
    );
  }
}

final allMenus = <MenuInfo>[
  MenuInfo(
    icon: ImageRes.menuCopy,
    text: StrRes.menuCopy,
    onTap: () {},
  ),
  MenuInfo(
    icon: ImageRes.menuDel,
    text: StrRes.menuDel,
    onTap: () {},
  ),
  MenuInfo(
    icon: ImageRes.menuForward,
    text: StrRes.menuForward,
    onTap: () {},
  ),
  MenuInfo(
    icon: ImageRes.menuReply,
    text: StrRes.menuReply,
    onTap: () {},
  ),
  MenuInfo(
    icon: ImageRes.menuMulti,
    text: StrRes.menuMulti,
    onTap: () {},
  ),
  MenuInfo(
    icon: ImageRes.menuRevoke,
    text: StrRes.menuRevoke,
    onTap: () {},
  ),
  MenuInfo(
    icon: ImageRes.menuAddFace,
    text: StrRes.menuAdd,
    onTap: () {},
  ),
];
