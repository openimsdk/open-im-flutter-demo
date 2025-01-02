import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class FavoriteManageLogic extends GetxController {
  var cacheLogic = Get.find<CacheController>();
  var isMultiModel = false.obs;
  var selectedList = <String>[].obs;

  void addFavorite() async {
    final List<AssetEntity>? assets = await AssetPicker.pickAssets(
      Get.context!,
      pickerConfig: const AssetPickerConfig(requestType: RequestType.image),
    );
    if (null != assets) {
      for (var asset in assets) {
        var path = (await asset.file)!.path;
        var width = asset.width;
        var height = asset.height;
        switch (asset.type) {
          case AssetType.image:
            cacheLogic.addFavoriteFromPath(path, width, height);
            IMViews.showToast(StrRes.addSuccessfully);
            break;
          default:
            break;
        }
      }
    }
  }

  void updateSelectedStatus(String url) {
    if (selectedList.contains(url)) {
      selectedList.remove(url);
    } else {
      selectedList.add(url);
    }
  }

  void manage() {
    isMultiModel.value = !isMultiModel.value;
    selectedList.clear();
  }

  void delete() {
    if (selectedList.isNotEmpty) {
      cacheLogic.delFavoriteList(selectedList);
      selectedList.clear();
    }
  }

  bool isChecked(String url) => selectedList.contains(url);
}
