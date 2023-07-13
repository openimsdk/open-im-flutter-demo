import 'dart:async';
import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:openim_common/openim_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:uuid/uuid.dart';

class IMViews {
  IMViews._();

  static final ImagePicker _picker = ImagePicker();

  static void showToast(String msg) {
    if (msg.trim().isNotEmpty) EasyLoading.showToast(msg);
  }

  static Widget buildHeader() => WaterDropMaterialHeader(
        backgroundColor: Styles.c_0089FF,
      );

  static Widget buildFooter() => CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            // body = Text("pull up load");
            body = const CupertinoActivityIndicator();
          } else if (mode == LoadStatus.loading) {
            body = const CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            // body = Text("Load Failed!Click retry!");
            body = const CupertinoActivityIndicator();
          } else if (mode == LoadStatus.canLoading) {
            // body = Text("release to load more");
            body = const CupertinoActivityIndicator();
          } else {
            // body = Text("No more Data");
            body = const SizedBox();
          }
          return SizedBox(
            height: 55.0,
            child: Center(child: body),
          );
        },
      );

  static openIMCallSheet(
    String label,
    Function(int index) onTapSheetItem,
  ) {
    return Get.bottomSheet(
      BottomSheetView(
        mainAxisAlignment: MainAxisAlignment.start,
        items: [
          SheetItem(
            label: StrRes.callVoice,
            icon: ImageRes.callVoice,
            alignment: MainAxisAlignment.start,
            onTap: () => onTapSheetItem.call(0),
          ),
          SheetItem(
            label: StrRes.callVideo,
            icon: ImageRes.callVideo,
            alignment: MainAxisAlignment.start,
            onTap: () => onTapSheetItem.call(1),
          ),
        ],
      ),
      // barrierColor: Colors.transparent,
    );
  }

  static openIMGroupCallSheet(
    String groupID,
    Function(int index) onTapSheetItem,
  ) {
    return Get.bottomSheet(
      BottomSheetView(
        mainAxisAlignment: MainAxisAlignment.start,
        items: [
          SheetItem(
            label: StrRes.callVoice,
            icon: ImageRes.callVoice,
            onTap: () => onTapSheetItem.call(0),
          ),
          SheetItem(
            label: StrRes.callVideo,
            icon: ImageRes.callVideo,
            onTap: () => onTapSheetItem.call(1),
          ),
        ],
      ),
      // barrierColor: Colors.transparent,
    );
  }

  static void openPhotoSheet({
    Function(dynamic path, dynamic url)? onData,
    bool crop = true,
    bool toUrl = true,
    bool fromGallery = true,
    bool fromCamera = true,
    List<SheetItem> items = const [],
  }) {
    Get.bottomSheet(
      BottomSheetView(
        items: [
          ...items,
          if (fromGallery)
            SheetItem(
              label: StrRes.toolboxAlbum,
              onTap: () {
                Permissions.storage(() async {
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
              label: StrRes.toolboxCamera,
              onTap: () {
                Permissions.camera(() async {
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
    if (crop && !path.endsWith('.gif')) {
      cropFile = await IMUtils.uCrop(path);
      if (cropFile == null) {
        // 放弃选择
        // return {'path': cropFile?.path ?? path, 'url': url};
        return {'path': null, 'url': null};
      }
    }
    if (toUrl) {
      String putID = const Uuid().v4();
      dynamic result;
      if (null != cropFile) {
        Logger.print('-----------crop path: ${cropFile.path}');
        // url = await HttpUtil.uploadImageForMinio(
        //   path: cropFile.path,
        //   compress: false,
        // );
        result = await LoadingView.singleton.wrap(
          asyncFunction: () => OpenIM.iMManager.uploadFile(
            id: putID,
            filePath: cropFile!.path,
            fileName: cropFile.path,
          ),
        );
      } else {
        Logger.print('-----------source path: $path');
        // url = await HttpUtil.uploadImageForMinio(
        //   path: path,
        //   compress: false,
        // );
        result = await LoadingView.singleton.wrap(
          asyncFunction: () => OpenIM.iMManager.uploadFile(
            id: putID,
            filePath: path,
            fileName: path,
          ),
        );
      }
      if (result is String) {
        url = jsonDecode(result)['url'];
        Logger.print('url:$url');
      }
    }
    return {'path': cropFile?.path ?? path, 'url': url};
  }

  static void openDownloadSheet(
    String url, {
    Function()? onDownload,
  }) {
    Get.bottomSheet(
      BottomSheetView(
        items: [
          SheetItem(
            label: StrRes.download,
            onTap: () {
              Permissions.storage(() => onDownload?.call());
            },
          ),
        ],
      ),
      barrierColor: Colors.transparent,
    );
  }

  static TextSpan getTimelineTextSpan(int ms) {
    int locTimeMs = DateTime.now().millisecondsSinceEpoch;
    var languageCode = Get.locale?.languageCode ?? 'zh';

    if (DateUtil.isToday(ms, locMs: locTimeMs)) {
      return TextSpan(
        text: languageCode == 'zh' ? '今天' : 'Today',
        style: Styles.ts_0C1C33_17sp_medium,
      );
    }

    if (DateUtil.isYesterdayByMs(ms, locTimeMs)) {
      return TextSpan(
        text: languageCode == 'zh' ? '昨天' : 'Yesterday',
        style: Styles.ts_0C1C33_17sp_medium,
      );
    }

    if (DateUtil.isWeek(ms, locMs: locTimeMs)) {
      final weekday = DateUtil.getWeekdayByMs(ms, languageCode: languageCode);
      if (weekday.contains('星期')) {
        return TextSpan(
          text: weekday.replaceAll('星期', ''),
          style: Styles.ts_0C1C33_17sp_medium,
          children: [
            TextSpan(
              text: '\n星期',
              style: Styles.ts_0C1C33_12sp_medium,
            ),
          ],
        );
      }
      return TextSpan(text: weekday, style: Styles.ts_0C1C33_17sp_medium);
    }

    // if (DateUtil.yearIsEqualByMs(ms, locTimeMs)) {
    //   final date = IMUtils.formatDateMs(ms, format: 'MM月dd');
    //   final one = date.split('月')[0];
    //   final two = date.split('月')[1];
    //   return TextSpan(
    //     text: two,
    //     style: Styles.ts_0C1C33_17sp_medium,
    //     children: [
    //       TextSpan(
    //         text: '\n$one${languageCode == 'zh' ? '月' : ''}',
    //         style: Styles.ts_0C1C33_12sp_medium,
    //       ),
    //     ],
    //   );
    // }
    final date = IMUtils.formatDateMs(ms, format: 'MM月dd');
    final one = date.split('月')[0];
    final two = date.split('月')[1];
    return TextSpan(
      text: '${int.parse(two)}',
      style: Styles.ts_0C1C33_17sp_medium,
      children: [
        TextSpan(
          text: '\n${int.parse(one)}${languageCode == 'zh' ? '月' : ''}',
          style: Styles.ts_0C1C33_12sp_medium,
        ),
      ],
    );
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
        completer.complete("+${country.phoneCode}");
      },
    );
    return completer.future;
  }
}
