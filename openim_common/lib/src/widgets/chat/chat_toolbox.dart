import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class ChatToolBox extends StatelessWidget {
  const ChatToolBox({
    Key? key,
    this.onTapAlbum,
    this.onTapCall,
    this.onTapCamera,
    this.onTapCard,
    this.onTapFile,
    this.onTapLocation,
  }) : super(key: key);
  final Function()? onTapAlbum;
  final Function()? onTapCamera;
  final Function()? onTapCall;
  final Function()? onTapFile;
  final Function()? onTapCard;
  final Function()? onTapLocation;

  @override
  Widget build(BuildContext context) {
    final items = [
      ToolboxItemInfo(
        text: StrRes.toolboxAlbum,
        icon: ImageRes.toolboxAlbum,
        onTap: () => Permissions.storage(onTapAlbum),
      ),
      ToolboxItemInfo(
        text: StrRes.toolboxCamera,
        icon: ImageRes.toolboxCamera,
        onTap: () => Permissions.camera(onTapCamera),
      ),
      // ToolboxItemInfo(
      //   text: StrRes.toolboxCall,
      //   icon: ImageRes.toolboxCall,
      //   onTap: () => Permissions.cameraAndMicrophone(onTapCall),
      // ),
      // ToolboxItemInfo(
      //   text: StrRes.toolboxFile,
      //   icon: ImageRes.toolboxFile,
      //   onTap: () => Permissions.storage(onTapFile),
      // ),
      // ToolboxItemInfo(
      //     text: StrRes.toolboxCard,
      //     icon: ImageRes.toolboxCard,
      //     onTap: onTapCard),
      // ToolboxItemInfo(
      //   text: StrRes.toolboxLocation,
      //   icon: ImageRes.toolboxLocation,
      //   onTap: () => Permissions.location(onTapLocation),
      // ),
    ];

    return Container(
      color: Styles.c_F0F2F6,
      height: 224.h,
      child: GridView.builder(
        itemCount: items.length,
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 6.h,
          bottom: 6.h,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 78.w / 105.h,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 2.h,
        ),
        itemBuilder: (_, index) {
          final item = items.elementAt(index);
          return _buildItemView(
            icon: item.icon,
            text: item.text,
            onTap: item.onTap,
          );
        },
      ),
      // child: Column(
      //   children: [
      //     Row(
      //       children: [
      //         _buildItemView(
      //             text: StrRes.toolboxAlbum,
      //             icon: ImageRes.toolboxAlbum,
      //             onTap: onTapAlbum),
      //         30.horizontalSpace,
      //         _buildItemView(
      //             text: StrRes.toolboxCamera,
      //             icon: ImageRes.toolboxCamera,
      //             onTap: onTapCamera),
      //         30.horizontalSpace,
      //         _buildItemView(
      //             text: StrRes.toolboxCall,
      //             icon: ImageRes.toolboxCall,
      //             onTap: onTapCall),
      //         30.horizontalSpace,
      //         _buildItemView(
      //             text: StrRes.toolboxFile,
      //             icon: ImageRes.toolboxFile,
      //             onTap: onTapFile),
      //       ],
      //     ),
      //     22.verticalSpace,
      //     Row(
      //       children: [
      //         _buildItemView(
      //             text: StrRes.toolboxCard,
      //             icon: ImageRes.toolboxCard,
      //             onTap: onTapCard),
      //         30.horizontalSpace,
      //         _buildItemView(
      //             text: StrRes.toolboxLocation,
      //             icon: ImageRes.toolboxLocation,
      //             onTap: onTapLocation),
      //       ],
      //     ),
      //   ],
      // ),
    );
  }

  Widget _buildItemView({
    required String text,
    required String icon,
    Function()? onTap,
  }) =>
      Column(
        children: [
          icon.toImage
            ..width = 58.w
            ..height = 58.h
            ..onTap = onTap,
          10.verticalSpace,
          text.toText..style = Styles.ts_0C1C33_12sp,
        ],
      );
}

class ToolboxItemInfo {
  String text;
  String icon;
  Function()? onTap;

  ToolboxItemInfo({required this.text, required this.icon, this.onTap});
}
