import 'package:get/get.dart';

import 'call_records_logic.dart';

class CallRecordsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CallRecordsLogic());
  }
}
