import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

class TitleBar extends StatelessWidget implements PreferredSizeWidget {
  const TitleBar({
    Key? key,
    this.height,
    this.left,
    this.center,
    this.right,
    this.backgroundColor,
    this.showUnderline = false,
  }) : super(key: key);
  final double? height;
  final Widget? left;
  final Widget? center;
  final Widget? right;
  final Color? backgroundColor;
  final bool showUnderline;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Container(
        color: backgroundColor ?? Styles.c_FFFFFF,
        padding: EdgeInsets.only(top: mq.padding.top),
        child: Container(
          height: height,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: showUnderline
              ? BoxDecoration(
                  border: BorderDirectional(
                    bottom: BorderSide(color: Styles.c_E8EAEF, width: .5),
                  ),
                )
              : null,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (null != left) Positioned(left: 0, child: left!),
              if (null != center) center!,
              if (null != right) Positioned(right: 0, child: right!),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? 44.h);

  TitleBar.conversation({
    super.key,
    String? statusStr,
    bool isFailed = false,
    Function()? onClickCallBtn,
    Function()? onScan,
    Function()? onAddFriend,
    Function()? onAddGroup,
    Function()? onCreateGroup,
    Function()? onVideoMeeting,
    CustomPopupMenuController? popCtrl,
  })  : backgroundColor = null,
        height = 62.h,
        showUnderline = false,
        center = null,
        left = Row(
          children: [
            AvatarView(
              width: 42.w,
              height: 42.h,
              text: OpenIM.iMManager.userInfo.nickname,
              url: OpenIM.iMManager.userInfo.faceURL,
            ),
            10.horizontalSpace,
            if (null != OpenIM.iMManager.userInfo.nickname)
              OpenIM.iMManager.userInfo.nickname!.toText
                ..style = Styles.ts_0C1C33_17sp
                ..maxLines = 1
                ..overflow = TextOverflow.ellipsis,
            10.horizontalSpace,
            if (null != statusStr)
              SyncStatusView(
                isFailed: isFailed,
                statusStr: statusStr,
              ),
          ],
        ),
        right = Row(
          children: [
            // ImageRes.callBack.toImage
            //   ..width = 28.w
            //   ..height = 28.h
            //   ..onTap = onClickCallBtn,
            // 16.horizontalSpace,
            PopButton(
              popCtrl: popCtrl,
              menus: [
                PopMenuInfo(
                  text: StrRes.scan,
                  icon: ImageRes.popMenuScan,
                  onTap: onScan,
                ),
                PopMenuInfo(
                  text: StrRes.addFriend,
                  icon: ImageRes.popMenuAddFriend,
                  onTap: onAddFriend,
                ),
                PopMenuInfo(
                  text: StrRes.addGroup,
                  icon: ImageRes.popMenuAddGroup,
                  onTap: onAddGroup,
                ),
                PopMenuInfo(
                  text: StrRes.createGroup,
                  icon: ImageRes.popMenuCreateGroup,
                  onTap: onCreateGroup,
                ),
                // PopMenuInfo(
                //   text: StrRes.videoMeeting,
                //   icon: ImageRes.popMenuVideoMeeting,
                //   onTap: onVideoMeeting,
                // ),
              ],
              child: ImageRes.addBlack.toImage
                ..width = 28.w
                ..height = 28.h /*..onTap = onClickAddBtn*/,
            ),
          ],
        );

  TitleBar.chat({
    super.key,
    String? title,
    String? subTitle,
    bool showOnlineStatus = false,
    bool isOnline = false,
    bool isMultiModel = false,
    bool showCallBtn = true,
    Function()? onClickCallBtn,
    Function()? onClickMoreBtn,
    Function()? onCloseMultiModel,
  })  : backgroundColor = null,
        height = 48.h,
        showUnderline = true,
        center = Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (null != title)
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 160.w),
                child: title.toText
                  ..style = Styles.ts_0C1C33_17sp_semibold
                  ..maxLines = 1
                  ..overflow = TextOverflow.ellipsis,
              ),
            if (null != subTitle)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showOnlineStatus)
                    Container(
                      width: 6.w,
                      height: 6.h,
                      margin: EdgeInsets.only(right: 4.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isOnline ? Styles.c_18E875 : Styles.c_FF381F,
                      ),
                    ),
                  subTitle.toText..style = Styles.ts_8E9AB0_10sp,
                ],
              ),
          ],
        ),
        left = isMultiModel
            ? (StrRes.cancel.toText
              ..style = Styles.ts_0C1C33_17sp
              ..onTap = onCloseMultiModel)
            : (ImageRes.backBlack.toImage
              ..width = 24.w
              ..height = 24.h
              ..onTap = (() => Get.back())),
        right = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // if (showCallBtn)
            //   ImageRes.callBack.toImage
            //     ..width = 28.w
            //     ..height = 28.h
            //     ..onTap = onClickCallBtn,
            // 16.horizontalSpace,
            ImageRes.moreBlack.toImage
              ..width = 28.w
              ..height = 28.h
              ..onTap = onClickMoreBtn,
          ],
        );

  TitleBar.back({
    super.key,
    String? title,
    String? leftTitle,
    TextStyle? titleStyle,
    TextStyle? leftTitleStyle,
    String? result,
    Color? backgroundColor,
    Color? backIconColor,
    this.right,
    this.showUnderline = false,
    Function()? onTap,
  })  : height = 44.h,
        backgroundColor = backgroundColor ?? Styles.c_FFFFFF,
        center = (title ?? '').toText
          ..style = (titleStyle ?? Styles.ts_0C1C33_17sp_semibold),
        left = GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onTap ?? (() => Get.back(result: result)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageRes.backBlack.toImage
                ..width = 24.w
                ..height = 24.h
                ..color = backIconColor,
              if (null != leftTitle)
                leftTitle.toText
                  ..style = (leftTitleStyle ?? Styles.ts_0C1C33_17sp_semibold),
            ],
          ),
        );

  TitleBar.contacts({
    super.key,
    this.showUnderline = false,
    Function()? onClickSearch,
    Function()? onClickAddContacts,
  })  : height = 44.h,
        backgroundColor = Styles.c_FFFFFF,
        center = null,
        left = StrRes.contacts.toText..style = Styles.ts_0C1C33_20sp_semibold,
        right = Row(
          children: [
            ImageRes.addContacts.toImage
              ..width = 28.w
              ..height = 28.h
              ..onTap = onClickAddContacts,
          ],
        );

  TitleBar.workbench({
    super.key,
    this.showUnderline = false,
  })  : height = 44.h,
        backgroundColor = Styles.c_FFFFFF,
        center = null,
        left = StrRes.workbench.toText..style = Styles.ts_0C1C33_20sp_semibold,
        right = null;

  TitleBar.search({
    super.key,
    String? hintText,
    TextEditingController? controller,
    FocusNode? focusNode,
    bool autofocus = true,
    Function(String)? onSubmitted,
    Function()? onCleared,
    ValueChanged<String>? onChanged,
  })  : height = 44.h,
        backgroundColor = Styles.c_FFFFFF,
        center = Container(
          margin: EdgeInsets.only(left: 35.w),
          child: SearchBox(
            enabled: true,
            autofocus: autofocus,
            hintText: hintText,
            controller: controller,
            focusNode: focusNode,
            onSubmitted: onSubmitted,
            onCleared: onCleared,
            onChanged: onChanged,
          ),
        ),
        showUnderline = true,
        right = null,
        left = ImageRes.backBlack.toImage
          ..width = 24.w
          ..height = 24.h
          ..onTap = (() => Get.back());
}
