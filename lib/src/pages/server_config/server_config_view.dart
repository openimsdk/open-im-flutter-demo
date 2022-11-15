import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../widgets/titlebar.dart';
import '../../widgets/touch_close_keyboard.dart';
import 'server_config_logic.dart';

class ServerConfigPage extends StatelessWidget {
  final logic = Get.find<ServerConfigLogic>();

  Widget _buildItemField({
    required String label,
    String? hintText,
    required TextEditingController controller,
    bool enabled = true,
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
            Text(label),
            TextField(
              controller: controller,
              keyboardType: TextInputType.url,
              enabled: enabled,
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
              Text(
                '修改配置后，保存并重启才能生效',
                style: TextStyle(color: Colors.red),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: logic.switchServer,
                    child: Obx(() => Text(
                          logic.isIP.value ? "切换为域名" : "切换为IP",
                        )),
                  ),
                  ElevatedButton(
                    onPressed: logic.confirm,
                    child: Text('保存配置'),
                  ),
                ],
              ),
              Obx(() => _buildItemField(
                    label: '请输入服务器地址',
                    hintText: logic.isIP.value ? 'IP' : '域名',
                    // hintText: Config.serverIp(),
                    controller: logic.ipCtrl,
                  )),
              _buildItemField(
                label: '登录注册服务器地址',
                // hintText: Config.appAuthUrl(),
                controller: logic.authCtrl,
                enabled: false,
              ),
              _buildItemField(
                label: 'IM API服务器地址',
                // hintText: Config.imApiUrl(),
                controller: logic.imApiCtrl,
                enabled: false,
              ),
              _buildItemField(
                label: 'IM WS地址',
                // hintText: Config.imWsUrl(),
                controller: logic.imWsCtrl,
                enabled: false,
              ),
              GestureDetector(
                onTap: logic.showObjectStorageSheet,
                behavior: HitTestBehavior.translucent,
                child: _buildItemField(
                  label: '设置图片存储',
                  hintText: '',
                  controller: logic.objectStorageCtrl,
                  enabled: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
