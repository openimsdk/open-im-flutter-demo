import 'dart:async';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:openim_demo/src/pages/register/select_avatar/select_avatar_view.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/utils/http_util.dart';
import 'package:openim_demo/src/utils/im_util.dart';

import 'bottom_sheet_view.dart';

class IMWidget {
  static final ImagePicker _picker = ImagePicker();


  static void openPhotoSheet({
    Function(String path, String? url)? onData,
    bool crop = true,
    bool toUrl = true,
    bool isAvatar = false,
    bool fromGallery = true,
    bool fromCamera = true,
    Function(int? index)? onIndexAvatar,
  }) {
    Get.bottomSheet(
      BottomSheetView(
        items: [
          if (isAvatar)
            SheetItem(
              label: StrRes.defaultAvatar,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              onTap: () async {
                var index = await Get.to(() => SelectAvatarPage());
                onIndexAvatar?.call(index);
              },
            ),
          if (fromGallery)
            SheetItem(
              label: StrRes.album,
              borderRadius: isAvatar
                  ? null
                  : BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
              onTap: () {
                PermissionUtil.storage(() async {
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (null != image?.path) {
                    var map = await _uCropPic(
                      image!.path,
                      crop: crop,
                      toUrl: toUrl,
                    );
                    onData?.call(map['path'], map['url']);
                  }
                });
              },
            ),
          if (fromCamera)
            SheetItem(
              label: StrRes.camera,
              onTap: () {
                PermissionUtil.camera(() async {
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (null != image?.path) {
                    var map = await _uCropPic(
                      image!.path,
                      crop: crop,
                      toUrl: toUrl,
                    );
                    onData?.call(map['path'], map['url']);
                  }
                });
              },
            ),
        ],
      ),
    );
  }

  static Future<Map<String, dynamic>> _uCropPic(
    String path, {
    bool crop = true,
    bool toUrl = true,
  }) async {
    CroppedFile? cropFile;
    String? url;
    if (crop) {
      cropFile = await IMUtil.uCrop(path);
      if (cropFile == null) {
        // 放弃选择
        return {'path': cropFile?.path ?? path, 'url': url};
      }
    }

    if (toUrl) {
      if (null != cropFile) {
        print('-----------crop path: ${cropFile.path}');
        url = await HttpUtil.uploadImageForMinio(path: cropFile.path);
      } else {
        print('-----------source path: $path');
        url = await HttpUtil.uploadImageForMinio(path: path);
      }
      print('url:$url');
    }
    return {'path': cropFile?.path ?? path, 'url': url};
  }

  static void showToast(String msg) {
    if (msg.trim().isNotEmpty) EasyLoading.showToast(msg);
  }

  static Future<String?> showCountryCodePicker() async {
    Completer<String> completer = Completer();
    showCountryPicker(
      context: Get.context!,
      showPhoneCode: true,
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Colors.white,
        textStyle: TextStyle(fontSize: 16.sp, color: Colors.blueGrey),
        bottomSheetHeight: 500.h,
        // Optional. Country list modal height
        //Optional. Sets the border radius for the bottomsheet.
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0.r),
          topRight: Radius.circular(8.0.r),
        ),
        //Optional. Styles the search field.
        inputDecoration: InputDecoration(
          labelText: StrRes.search,
          // hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
      ),
      onSelect: (Country country) {
        completer.complete("+" + country.phoneCode);
      },
    );
    return completer.future;
  }

  static void openNoDisturbSettingSheet({bool isGroup = false, Function(int index)? onTap}) {
    Get.bottomSheet(
      BottomSheetView(
        items: [
          SheetItem(
            label: StrRes.receiveMessageButNotPrompt,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            onTap: () => onTap?.call(0),
          ),
          SheetItem(
            label: isGroup ? StrRes.blockGroupMessages : StrRes.blockFriends,
            onTap: () => onTap?.call(1),
          ),
        ],
      ),
    );
  }
}
