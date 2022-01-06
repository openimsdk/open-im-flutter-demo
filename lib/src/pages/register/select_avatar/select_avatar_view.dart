import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';
import 'package:openim_enterprise_chat/src/res/styles.dart';
import 'package:openim_enterprise_chat/src/widgets/titlebar.dart';

class SelectAvatarPage extends StatelessWidget {
  // final logic = Get.find<SelectAvatarLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EnterpriseTitleBar.back(
        title: StrRes.defaultAvatar,
        showShadow: false,
      ),
      backgroundColor: PageStyle.c_FFFFFF,
      body: GridView.builder(
        itemCount: indexAvatarList.length,
        padding: EdgeInsets.symmetric(
          horizontal: 22.w,
          vertical: 14.h,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1.0,
          mainAxisSpacing: 14.h,
          crossAxisSpacing: 19.w,
        ),
        itemBuilder: (_, index) {
          return Ink(
            child: InkWell(
              onTap: () {
                Get.back(result: index);
              },
              child: ImageUtil.assetImage(indexAvatarList.elementAt(index)),
            ),
          );
        },
      ),
    );
  }
}
