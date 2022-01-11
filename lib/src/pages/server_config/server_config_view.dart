import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/common/config.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/button.dart';
import 'package:openim_demo/src/widgets/titlebar.dart';
import 'package:openim_demo/src/widgets/touch_close_keyboard.dart';

import 'server_config_logic.dart';

class ServerConfigPage extends StatelessWidget {
  final logic = Get.find<ServerConfigLogic>();

  Widget _buildItemField({
    required String label,
    required String hintText,
    required TextEditingController controller,
  }) =>
      Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF000000).withOpacity(0.15),
                offset: Offset(0, 1),
                spreadRadius: 0,
                blurRadius: 4,
              ),
            ]),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(
          left: 22.w,
          right: 22.w,
          top: 10.h,
          bottom: 10.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
            ),
            TextField(
              controller: controller,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                hintText: hintText,
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        appBar: EnterpriseTitleBar.back(
          title: '服务器配置',
          showShadow: false,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildItemField(
                label: '请输入服务器地址',
                hintText: Config.serverIp(),
                controller: logic.ipCtrl,
              ),
              _buildItemField(
                label: '登录注册服务器地址',
                hintText: Config.appAuthUrl(),
                controller: logic.authCtrl,
              ),
              _buildItemField(
                label: 'IM API服务器地址',
                hintText: Config.imApiUrl(),
                controller: logic.imApiCtrl,
              ),
              _buildItemField(
                label: 'IM WS地址',
                hintText: Config.imWsUrl(),
                controller: logic.imWsCtrl,
              ),
              _buildItemField(
                label: '音视频通话服务器地址',
                hintText: Config.callUrl(),
                controller: logic.callCtrl,
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 22.w,
                  vertical: 10.h,
                ),
                child: Row(
                  children: [
                    Text(
                      '重启app后配置生效',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              Button(
                textStyle: PageStyle.ts_FFFFFF_18sp,
                text: '保存',
                background: PageStyle.c_1D6BED,
                onTap: () => logic.confirm(),
                margin: EdgeInsets.symmetric(horizontal: 22.w),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
