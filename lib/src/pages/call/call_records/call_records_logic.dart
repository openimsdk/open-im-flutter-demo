import 'dart:convert';

import 'package:get/get.dart';
import 'package:openim_demo/src/models/call_records.dart';
import 'package:openim_demo/src/utils/data_persistence.dart';

class CallRecordsLogic extends GetxController {
  var index = 0.obs;
  var list = <CallRecords>[].obs;
  var missedList = <CallRecords>[].obs;
  var _needUpdate = false;

  @override
  void onInit() {
    list.addAll(DataPersistence.getCallRecords() ?? []);
    list.forEach((element) {
      if (!element.success) {
        missedList.add(element);
      }
    });
    print(
        'list----${DateTime.now().millisecondsSinceEpoch}---${json.encode(list)}');
    super.onInit();
  }

  @override
  void onClose() {
    if (_needUpdate) {
      DataPersistence.putCallRecords(list);
    }
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
