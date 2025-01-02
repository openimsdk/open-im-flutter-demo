import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
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
          child: Row(
            children: [
              if (null != left) left!,
              if (null != center) center!,
              if (null != right) right!,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? 44.h);

  TitleBar.conversation(
      {super.key,
      String? statusStr,
      bool isFailed = false,
      Function()? onScan,
      Function()? onAddFriend,
      Function()? onAddGroup,
      Function()? onCreateGroup,
      CustomPopupMenuController? popCtrl,
      this.left})
      : backgroundColor = null,
        height = 62.h,
        showUnderline = false,
        center = null,
        right = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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
    String? member,
    String? subTitle,
    bool showOnlineStatus = false,
    bool isOnline = false,
    bool isMultiModel = false,
    bool showCallBtn = true,
    bool isMuted = false,
    Function()? onClickCallBtn,
    Function()? onClickMoreBtn,
    Function()? onCloseMultiModel,
  })  : backgroundColor = null,
        height = 48.h,
        showUnderline = true,
        center = Flexible(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (null != title)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                      flex: 5,
                      child: Container(
                        child: title.trim().toText
                          ..style = Styles.ts_0C1C33_17sp_semibold
                          ..maxLines = 1
                          ..overflow = TextOverflow.ellipsis
                          ..textAlign = TextAlign.center,
                      )),
                  if (null != member)
                    Flexible(
                        flex: 2,
                        child: Container(
                            child: member.toText
                              ..style = Styles.ts_0C1C33_17sp_semibold
                              ..maxLines = 1))
                ],
              ),
            if (subTitle?.isNotEmpty == true)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showOnlineStatus)
                    Container(
                      width: 6.w,
                      height: 6.h,
                      margin: EdgeInsets.only(right: 4.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isOnline ? Styles.c_18E875 : Styles.c_8E9AB0,
                      ),
                    ),
                  subTitle!.toText..style = Styles.ts_8E9AB0_10sp,
                ],
              ),
          ],
        )),
        left = SizedBox(
            width: showCallBtn ? 48.w : 24.w,
            child: isMultiModel
                ? (StrRes.cancel.toText
                  ..style = Styles.ts_0C1C33_17sp
                  ..onTap = onCloseMultiModel)
                : (ImageRes.backBlack.toImage
                  ..width = 24.w
                  ..height = 24.h
                  ..onTap = (() => Get.back()))),
        right = SizedBox(
            width: 16.w + (showCallBtn ? 56.w : 28.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showCallBtn)
                  ImageRes.callBack.toImage
                    ..width = 28.w
                    ..height = 28.h
                    ..opacity = isMuted ? 0.4 : 1
                    ..onTap = isMuted ? null : onClickCallBtn,
                16.horizontalSpace,
                ImageRes.moreBlack.toImage
                  ..width = 28.w
                  ..height = 28.h
                  ..onTap = onClickMoreBtn,
              ],
            ));

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
        center = Expanded(
            child: (title ?? '').toText
              ..style = (titleStyle ?? Styles.ts_0C1C33_17sp_semibold)
              ..textAlign = TextAlign.center),
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
              if (null != leftTitle) leftTitle.toText..style = (leftTitleStyle ?? Styles.ts_0C1C33_17sp_semibold),
            ],
          ),
        );

  TitleBar.contacts({
    super.key,
    this.showUnderline = false,
    Function()? onClickAddContacts,
  })  : height = 44.h,
        backgroundColor = Styles.c_FFFFFF,
        center = Spacer(),
        left = StrRes.contacts.toText..style = Styles.ts_0C1C33_20sp_semibold,
        right = Row(
          children: [
            16.horizontalSpace,
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
        center = Expanded(
          child: Container(
              child: SearchBox(
            enabled: true,
            autofocus: autofocus,
            hintText: hintText,
            controller: controller,
            focusNode: focusNode,
            onSubmitted: onSubmitted,
            onCleared: onCleared,
            onChanged: onChanged,
          )),
        ),
        showUnderline = true,
        right = null,
        left = ImageRes.backBlack.toImage
          ..width = 24.w
          ..height = 24.h
          ..onTap = (() => Get.back());
}
