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
          title: 'Server Configuration',
          right: 'Save'.toText
            ..style = Styles.ts_0C1C33_17sp
            ..onTap = logic.confirm,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              'After modifying the configuration, you need to save and restart for the changes to take effect'
                  .toText
                ..style = const TextStyle(color: Colors.red),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => logic.switchServer(true),
                    child: "Switch to IP".toText,
                  ),
                  ElevatedButton(
                    onPressed: () => logic.switchServer(false),
                    child: "Switch to Domain".toText,
                  ),
                ],
              ),
              Obx(() => _buildItemField(
                    label: 'Enter the server address',
                    hintText: logic.isIP.value ? 'IP' : 'Domain',
                    controller: logic.ipCtrl,
                  )),
              _buildItemField(
                label: 'Login/Register Server Address',
                controller: logic.authCtrl,
              ),
              _buildItemField(
                label: 'IM API Server Address',
                controller: logic.imApiCtrl,
              ),
              _buildItemField(
                label: 'IM WebSocket Address',
                controller: logic.imWsCtrl,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
