import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'add_method_logic.dart';

class AddContactsMethodPage extends StatelessWidget {
  final logic = Get.find<AddContactsMethodLogic>();

  AddContactsMethodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrRes.add),
      body: Column(
        children: [
          10.verticalSpace,
          _buildItemView(
            icon: ImageRes.scanBlue,
            text: StrRes.scan,
            hintText: StrRes.scanHint,
            onTap: logic.scan,
          ),
          _buildItemView(
            icon: ImageRes.addFriendBlue,
            text: StrRes.addFriend,
            hintText: StrRes.addFriendHint,
            onTap: logic.addFriend,
          ),
          _buildItemView(
            icon: ImageRes.createGroupBlue,
            text: StrRes.createGroup,
            hintText: StrRes.createGroupHint,
            onTap: logic.createGroup,
          ),
          _buildItemView(
            icon: ImageRes.addGroupBLue,
            text: StrRes.addGroup,
            hintText: StrRes.addGroupHint,
            onTap: logic.addGroup,
            underline: false,
          ),
        ],
      ),
    );
  }

  Widget _buildItemView({
    required String icon,
    required String text,
    required String hintText,
    bool underline = true,
    Function()? onTap,
  }) =>
      Ink(
        color: Styles.c_FFFFFF,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: 74.h,
            child: Row(
              children: [
                22.horizontalSpace,
                icon.toImage
                  ..width = 28.w
                  ..height = 28.h,
                16.horizontalSpace,
                Expanded(
                  child: Container(
                    decoration: underline
                        ? BoxDecoration(
                            border: BorderDirectional(
                              bottom: BorderSide(
                                color: Styles.c_E8EAEF,
                                width: .5,
                              ),
                            ),
                          )
                        : null,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              text.toText..style = Styles.ts_0C1C33_17sp,
                              4.verticalSpace,
                              hintText.toText..style = Styles.ts_8E9AB0_12sp,
                            ],
                          ),
                        ),
                        ImageRes.rightArrow.toImage
                          ..width = 24.w
                          ..height = 24.h,
                        16.horizontalSpace,
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
}
