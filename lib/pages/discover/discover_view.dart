import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'discover_logic.dart';

class DiscoverPage extends StatelessWidget {
  final logic = Get.find<DiscoverLogic>();

  DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.workbench(),
      backgroundColor: Styles.c_F8F9FA,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Obx(() => H5Container(url: logic.url.value));
  }
}
