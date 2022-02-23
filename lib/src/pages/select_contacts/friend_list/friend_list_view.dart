import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/models/contacts_info.dart';
import 'package:openim_demo/src/widgets/azlist_view.dart';

import '../select_contacts_logic.dart';

class FriendListView extends StatelessWidget {
  final logic = Get.find<SelectContactsLogic>();

  FriendListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => WrapAzListView<ContactsInfo>(
          data: logic.contactsList.value,
          itemBuilder: (context, data, index) {
            var disabled = logic.defaultCheckedUidList.contains(data.userID);
            return InkWell(
                onTap: disabled ? null : () => logic.selectedContacts(data),
                child: buildAzListItemView(
                  name: data.getShowName(),
                  url: data.faceURL,
                  isMultiModel: logic.isMultiModel(),
                  checked: disabled ? true : logic.checkedList.contains(data),
                  enabled: !disabled,
                ));
          },
        ));
  }
}
