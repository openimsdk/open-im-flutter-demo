import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_demo/src/res/images.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/radio_button.dart';

import 'avatar_view.dart';

class WrapAzListView<T extends ISuspensionBean> extends StatelessWidget {
  const WrapAzListView({
    Key? key,
    // this.itemScrollController,
    required this.data,
    required this.itemBuilder,
  }) : super(key: key);

  /// Controller for jumping or scrolling to an item.
  // final ItemScrollController? itemScrollController;
  final List<T> data;
  final Widget Function(BuildContext context, T data, int index) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return AzListView(
      data: data,
      // physics: AlwaysScrollableScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        var model = data[index];
        return itemBuilder(context, model, index);
      },
      // itemScrollController: itemScrollController,
      susItemBuilder: (BuildContext context, int index) {
        var model = data[index];
        if ('↑' == model.getSuspensionTag()) {
          return Container();
        }
        return _buildTagView(model.getSuspensionTag());
      },
      susItemHeight: 23.h,
      indexBarData: SuspensionUtil.getTagIndexList(data),
      indexBarOptions: IndexBarOptions(
        needRebuild: true,
        selectTextStyle: TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        // selectItemDecoration: BoxDecoration(
        //   shape: BoxShape.circle,
        //   color: Color(0xFF333333),
        // ),
        indexHintWidth: 96,
        indexHintHeight: 97,
        indexHintDecoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageRes.ic_indexBarBg),
            fit: BoxFit.contain,
          ),
        ),
        indexHintAlignment: Alignment.centerRight,
        indexHintTextStyle: TextStyle(
          fontSize: 24.0,
          color: Colors.black87,
        ),
        indexHintOffset: Offset(-30, 0),
      ),
    );
  }

  Widget _buildTagView(String tag) => Container(
        height: 23.h,
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        alignment: Alignment.centerLeft,
        width: 1.sw,
        color: PageStyle.c_F0F0F0,
        child: Text(
          tag,
          style: PageStyle.ts_666666_14sp,
        ),
      );
}

Widget buildAzListItemView({
  String? url,
  required String name,
  Function()? onTap,
  bool isMultiModel = false,
  bool checked = false,
  bool enabled = true,
  String? onlineStatus,
  List<Widget>? tags,
}) =>
    Ink(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 64.h,
          padding: EdgeInsets.only(left: isMultiModel ? 0 : 22.w),
          child: Row(
            children: [
              Visibility(
                visible: isMultiModel,
                child: Padding(
                  padding: EdgeInsets.only(left: 16.w, right: 12.w),
                  child: RadioButton1(
                    isChecked: checked,
                    enabled: enabled,
                  ),
                ),
              ),
              AvatarView(
                url: url,
                size: 44.h,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 14.w),
                  padding: EdgeInsets.only(right: 22.w),
                  decoration: BoxDecoration(
                    border: BorderDirectional(
                      bottom: BorderSide(
                        color: Color(0xFFF0F0F0),
                        width: 1,
                      ),
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          children: (tags ?? <Widget>[])
                            ..insert(
                                0,
                                Text(
                                  name,
                                  style: PageStyle.ts_333333_16sp,
                                  overflow: TextOverflow.ellipsis,
                                ))),
                      if (onlineStatus != null)
                        Text(
                          '[$onlineStatus]',
                          style: PageStyle.ts_999999_12sp,
                          overflow: TextOverflow.ellipsis,
                        )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
