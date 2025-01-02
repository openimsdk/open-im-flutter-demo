import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

enum OperateType {
  forward,
  save,
}

class PhotoBrowserBottomBar extends StatelessWidget {
  PhotoBrowserBottomBar({super.key, this.onPressedButton, this.onlySave});
  ValueChanged<OperateType>? onPressedButton;
  bool? onlySave;

  PhotoBrowserBottomBar.show(BuildContext context,
      {super.key, bool onlySave = false, ValueChanged<OperateType>? onPressedButton}) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return PhotoBrowserBottomBar(
            onPressedButton: onPressedButton,
            onlySave: onlySave,
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return _buildBar(context);
  }

  Widget _buildBar(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 142),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(8.0),
          topRight: const Radius.circular(8.0),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (onlySave == false)
                _buildItem(ImageRes.forwardIcon.toImage, StrRes.menuForward, onPressed: () {
                  Navigator.of(context).pop();
                  onPressedButton?.call(OperateType.forward);
                }),
              _buildItem(
                  ImageRes.saveIcon.toImage
                    ..width = 20
                    ..height = 20,
                  StrRes.save, onPressed: () {
                Navigator.of(context).pop();
                onPressedButton?.call(OperateType.save);
              })
            ],
          ),
          Divider(
            height: 6.h,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width, maxHeight: 40.h),
            child: CupertinoButton(
                padding: EdgeInsets.zero,
                minSize: 40.h,
                child: Text(StrRes.cancel, style: Styles.ts_0C1C33_12sp),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          )
        ],
      ),
    );
  }

  Widget _buildItem(Widget icon, String title, {VoidCallback? onPressed}) {
    return Column(children: [
      CupertinoButton(
          padding: EdgeInsets.only(top: 16, bottom: 8),
          child: Container(
            decoration: BoxDecoration(color: CupertinoColors.white, borderRadius: BorderRadius.all(Radius.circular(5))),
            height: 48,
            width: 48,
            child: Center(child: icon),
          ),
          onPressed: () {
            onPressed?.call();
          }),
      Text(
        title,
        textAlign: TextAlign.center,
        style: Styles.ts_0C1C33_10sp,
      )
    ]);
  }
}
