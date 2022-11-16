import 'package:get/get.dart';
import 'package:openim_demo/src/models/call_records.dart';

class CallRecordsLogic extends GetxController {
  var index = 0.obs;
  var list = <CallRecords>[].obs;
  var missedList = <CallRecords>[].obs;
  var _needUpdate = false;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  bool remove(CallRecords records) {
    _needUpdate = true;
    missedList.remove(records);
    return list.remove(records);
  }

  void switchTab(index) {
    this.index.value = index;
  }

  void call(CallRecords records) {}
}
