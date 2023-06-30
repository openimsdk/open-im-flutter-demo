import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'server_config_logic.dart';

class ServerConfigPage extends StatelessWidget {
  final logic = Get.find<ServerConfigLogic>();

  ServerConfigPage({super.key});

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
                color: const Color(0xFF000000).withOpacity(0.15),
                offset: const Offset(0, 1),
                spreadRadius: 0,
                blurRadius: 4,
              ),
            ]),
        padding: const EdgeInsets.all(10),
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
        appBar: TitleBar.back(
          title: '服务器配置',
          right: '保存'.toText
            ..style = Styles.ts_0C1C33_17sp
            ..onTap = logic.confirm,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              '修改配置后，保存并重启才能生效'.toText
                ..style = const TextStyle(color: Colors.red),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => logic.switchServer(true),
                    child: "切换为IP".toText,
                  ),
                  ElevatedButton(
                    onPressed: () => logic.switchServer(false),
                    child: "切换为域名".toText,
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
              ),
              _buildItemField(
                label: 'IM API服务器地址',
                // hintText: Config.imApiUrl(),
                controller: logic.imApiCtrl,
              ),
              _buildItemField(
                label: 'IM WS地址',
                // hintText: Config.imWsUrl(),
                controller: logic.imWsCtrl,
              ),
              // Visibility(
              //   visible: false,
              //   child: _buildItemField(
              //     label: '商业版管理后台',
              //     // hintText: Config.imWsUrl(),
              //     controller: logic.chatTokenCtrl,
              //   ),
              // ),
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
