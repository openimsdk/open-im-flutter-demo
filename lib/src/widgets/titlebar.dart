import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/images.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/search_box.dart';

import 'avatar_view.dart';
import 'image_button.dart';

class EnterpriseTitleBar extends StatelessWidget
    implements PreferredSizeWidget {
  const EnterpriseTitleBar({
    Key? key,
    this.height,
    this.left,
    this.center,
    this.right,
    this.backgroundColor,
    this.topPadding = 0.0,
    this.showShadow = true,
  }) : super(key: key);
  final double? height;
  final Widget? left;
  final Widget? center;
  final Widget? right;
  final Color? backgroundColor;
  final double topPadding;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    return _appbar(
      backgroundColor: backgroundColor,
      left: left,
      center: center,
      right: right,
      height: height! + data.padding.top,
      topPadding: data.padding.top,
      showShadow: showShadow,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? 50.h);

  static Widget backButton({double left = 32}) {
    return Container(
      margin: EdgeInsets.only(top: 26.h, left: left.w),
      child: ImageButton(
        onTap: () => Get.back(),
        imgStrRes: ImageRes.ic_backBigBlue,
        alignment: Alignment.centerLeft,
        imgWidth: 36.w,
        imgHeight: 33.h,
      ),
    );
  }

  static Widget _appbar({
    Color? backgroundColor,
    double? height,
    Widget? left,
    Widget? center,
    Widget? right,
    double topPadding = 0.0,
    bool showShadow = true,
  }) =>
      Container(
        height: height,
        padding: EdgeInsets.only(left: 12.w, right: 12.w, top: topPadding),
        decoration: BoxDecoration(
          color: backgroundColor ?? PageStyle.c_FFFFFF,
          boxShadow: showShadow
              ? [
                  BoxShadow(
                    color: Color(0xFF000000).withOpacity(0.15),
                    offset: Offset(0, 1),
                    spreadRadius: 0,
                    blurRadius: 4,
                  )
                ]
              : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: left,
            ),
            Align(
              alignment: Alignment.center,
              child: center,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: right,
            )
          ],
        ),
      );

  EnterpriseTitleBar.back({
    String? title,
    TextStyle? style,
    String? subTitle,
    TextStyle? subStyle,
    String? leftTile,
    double? height,
    dynamic result,
    Color? backgroundColor,
    List<Widget> actions = const [],
    Function()? onTap,
    bool showBackArrow = true,
    bool showShadow = true,
  })  : height = height ?? 44.h,
        topPadding = 0,
        // height = height ?? 84.h,
        // topPadding = 40.h,
        backgroundColor = backgroundColor,
        showShadow = showShadow,
        left = showBackArrow
            ? Row(
                children: [
                  GestureDetector(
                    onTap: onTap ?? () => Get.back(result: result),
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                      height: 44.h,
                      child: Center(
                        child: null != leftTile
                            ? Text(
                                leftTile,
                                style: PageStyle.ts_333333_18sp,
                              )
                            : Image.asset(
                                ImageRes.ic_back,
                                width: 12.w,
                                height: 20.h,
                              ),
                      ),
                    ),
                  ),
                  Spacer()
                ],
              )
            : null,
        right = Row(
          mainAxisSize: MainAxisSize.min,
          children: actions,
        ),
        center = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (null != title)
              Text(
                title,
                style: style ?? PageStyle.ts_333333_18sp,
              ),
            if (null != subTitle)
              Text(
                subTitle,
                style: subStyle ?? PageStyle.ts_999999_10sp,
              ),
          ],
        );

  EnterpriseTitleBar.conversationTitle({
    String? avatarUrl,
    String? title,
    String? subTitle,
    TextStyle? tileStyle,
    TextStyle? subTStyle,
    List<Widget> actions = const [],
    Widget? titleView,
    Widget? subTitleView,
  })  : //height = 124.h,
        // topPadding = 53.h,
        height = 71.h,
        topPadding = 0,
        backgroundColor = null,
        left = null,
        right = null,
        showShadow = true,
        center = Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 10.w),
            AvatarView(
              size: 49.h,
              url: avatarUrl,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (null != title)
                    Text(
                      title,
                      style: tileStyle ?? PageStyle.ts_333333_12sp,
                    ),
                  if (null != titleView) titleView,
                  if (null != subTitle)
                    Text(
                      subTitle,
                      style: subTStyle ?? PageStyle.ts_333333_18sp,
                    ),
                  if (null != subTitleView) subTitleView,
                ],
              ),
            ),
            Row(
              children: actions,
            ),
          ],
        );

  EnterpriseTitleBar.chatTitle({
    String? title,
    String? subTitle,
    double? height,
    String? leftButton,
    Function()? onClickCallBtn,
    Function()? onClickMoreBtn,
    Function()? onClose,
    Color? backgroundColor,
    bool showOnlineStatus = false,
    bool online = false,
  })  : //height = height ?? 84.h,
        // topPadding = 40.h,
        height = height ?? 44.h,
        topPadding = 0,
        backgroundColor = backgroundColor,
        showShadow = true,
        left = Row(
          children: [
            GestureDetector(
              onTap: onClose,
              behavior: HitTestBehavior.translucent,
              child: Container(
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                height: 44.h,
                child: Center(
                  child: null != leftButton
                      ? Text(
                          leftButton,
                          style: PageStyle.ts_333333_18sp,
                        )
                      : Image.asset(
                          ImageRes.ic_back,
                          width: 12.w,
                          height: 20.h,
                        ),
                ),
              ),
            ),
            Spacer()
          ],
        ),
        right = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TitleImageButton(
              imageStr: ImageRes.ic_call,
              imageWidth: 25.w,
              imageHeight: 24.h,
              onTap: onClickCallBtn,
              // height: 44.h,
            ),
            TitleImageButton(
              imageStr: ImageRes.ic_more,
              imageWidth: 20.w,
              imageHeight: 24.h,
              onTap: onClickMoreBtn,
              // height: 44.h,
            ),
          ],
        ),
        center = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (null != title)
              Text(
                title,
                style: PageStyle.ts_333333_18sp,
              ),
            if (null != subTitle && subTitle.isNotEmpty)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showOnlineStatus)
                    Container(
                      margin: EdgeInsets.only(right: 4.w, top: 2.h),
                      width: 6.h,
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: online ? PageStyle.c_10CC64 : PageStyle.c_959595,
                        shape: BoxShape.circle,
                      ),
                    ),
                  Text(
                    subTitle,
                    style: PageStyle.ts_999999_10sp,
                  )
                ],
              ),
          ],
        );

  EnterpriseTitleBar.leftTitle({
    String? title,
    TextStyle? textStyle,
    double? height,
    List<Widget> actions = const [],
    Color? backgroundColor,
  })  : //height = height ?? 84.h,
        //topPadding = 40.h,
        height = height ?? 44.h,
        topPadding = 0,
        backgroundColor = backgroundColor,
        showShadow = true,
        center = null,
        right = Row(
          mainAxisSize: MainAxisSize.min,
          children: actions,
        ),
        left = Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            title ?? '',
            style: textStyle ?? PageStyle.ts_1B72EC_22sp,
          ),
        );

  EnterpriseTitleBar.searchTitle({required SearchBox searchBox})
      : //height = 107.h,
        // topPadding = 54.h,
        height = 53.h,
        topPadding = 0,
        backgroundColor = Colors.white,
        showShadow = false,
        center = Container(
          padding: EdgeInsets.only(left: 12.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: searchBox),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => Get.back(),
                child: Container(
                  padding: EdgeInsets.only(left: 17.w, right: 7.w),
                  alignment: Alignment.center,
                  height: 40.h,
                  child: Text(
                    StrRes.cancel,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        right = null,
        left = null;
/*  static AppBar conversationTitle({
    String? avatarUrl,
    required String title,
    required String subTitle,
    TextStyle? tileStyle,
    TextStyle? subTStyle,
    Function()? onClickCallBtn,
    Function()? onClickAddBtn,
  }) =>
      AppBar(
        backgroundColor: PageStyle.bgColor,
        titleSpacing: 10.w,
        title: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 12.w),
              ChatAvatarView(
                size: 49.h,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: tileStyle ?? TitleStyle.title1,
                    ),
                    Text(
                      subTitle,
                      style: subTStyle ?? TitleStyle.title2,
                    ),
                  ],
                ),
              ),
              TitleImageButton(
                imageStr: ImageRes.ic_callBlack,
                imageHeight: 23.h,
                imageWidth: 23.w,
                onTap: onClickCallBtn,
                height: 50.h,
              ),
              TitleImageButton(
                imageStr: ImageRes.ic_addBlack,
                imageHeight: 24.h,
                imageWidth: 23.w,
                onTap: onClickAddBtn,
                height: 50.h,
              ),
            ],
          ),
        ),
      );*/

/*{
    return Container(
      // height: 124.h,
      padding: EdgeInsets.fromLTRB(22.w, 53.h, 22.w, 18.h),
      decoration: BoxDecoration(
        color: PageStyle.bgColor,
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000).withOpacity(0.15),
            offset: Offset(0, 1),
            spreadRadius: 0,
            blurRadius: 4,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ChatAvatarView(
            size: 49.h,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: tileStyle ?? TitleStyle.title1,
                ),
                Text(
                  subTitle,
                  style: subTStyle ?? TitleStyle.title2,
                ),
              ],
            ),
          ),
          ImageButton(
            imgStrRes: ImageRes.ic_callBlack,
            imgWidth: 23.w,
            imgHeight: 23.h,
            onTap: onClickCallBtn,
          ),
          SizedBox(width: 16.w),
          ImageButton(
            imgStrRes: ImageRes.ic_addBlack,
            imgWidth: 24.w,
            imgHeight: 23.h,
            onTap: onClickCallBtn,
          ),
        ],
      ),
    );
  }*/

/* static AppBar chatTitle({
    String? title,
    String? subTitle,
    double? height,
    Function()? onClickCallBtn,
    Function()? onClickMoreBtn,
    String? leftButton,
    Function()? onClose,
    Color? backgroundColor,
    dynamic result,
  }) =>
      _buildAppBar(
        left: GestureDetector(
          onTap: onClose ?? () => Get.back(result: result),
          behavior: HitTestBehavior.translucent,
          child: Container(
            color: Colors.red,
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            // height: 50.h,
            width: 50.w,
            alignment: Alignment.centerLeft,
            child: null != leftButton
                ? Text(
                    leftButton,
                    style: TitleStyle.title3,
                  )
                : Image.asset(
                    ImageRes.ic_back,
                    width: 12.w,
                    height: 20.h,
                  ),
          ),
        ),
        center: Column(
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (null != title)
              Text(
                title,
                style: TitleStyle.title3,
              ),
            if (null != subTitle)
              Text(
                subTitle,
                style: TitleStyle.title4,
              ),
          ],
        ),
        right: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ImageButton(
              imgStrRes: ImageRes.ic_call,
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 5.h,
              ),
              imgWidth: 25.w,
              imgHeight: 24.h,
              onTap: onClickCallBtn,
              alignment: Alignment.centerLeft,
              isInk: false,
            ),
            ImageButton(
              imgStrRes: ImageRes.ic_more,
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 5.h,
              ),
              imgWidth: 20.w,
              imgHeight: 24.h,
              isInk: false,
              onTap: onClickMoreBtn,
            ),
          ],
        ),
      );

  static AppBar _buildAppBar({
    Color? backgroundColor,
    double? height,
    Widget? left,
    Widget? center,
    Widget? right,
  }) =>
      AppBar(
        backgroundColor: backgroundColor ?? PageStyle.appBarBgColor,
        titleSpacing: 12.w,
        toolbarHeight: height,
        automaticallyImplyLeading: false,
        title: Stack(
          // alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: left,
            ),
            Align(
              alignment: Alignment.center,
              child: center,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: right,
            )
          ],
        ),
      );*/

/*=>
      EnterpriseTitleBar.back(
        title: title,
        subTitle: subTitle,
        leftTile: leftTitle,
        height: 50.h,
        onTap: onClose,
        result: result,
        actions: [
          ImageButton(
            imgStrRes: ImageRes.ic_call,
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 5.h,
            ),
            imgWidth: 25.w,
            imgHeight: 24.h,
            onTap: onClickCallBtn,
            alignment: Alignment.centerLeft,
            isInk: false,
          ),
          ImageButton(
            imgStrRes: ImageRes.ic_more,
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 5.h,
            ),
            imgWidth: 20.w,
            imgHeight: 24.h,
            isInk: false,
            onTap: onClickMoreBtn,
          )
        ],
      );*/

}

class TitleImageButton extends StatelessWidget {
  const TitleImageButton({
    Key? key,
    required this.imageStr,
    required this.imageWidth,
    required this.imageHeight,
    this.width,
    this.height,
    this.onTap,
    this.padding,
    this.color,
  }) : super(key: key);
  final String imageStr;
  final double imageWidth;
  final double imageHeight;
  final double? width;
  final double? height;
  final Function()? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        width: width,
        height: height ?? 44.h,
        child: Center(
          child: Image.asset(
            imageStr,
            width: imageWidth,
            height: imageHeight,
            color: color,
          ),
        ),
        padding: padding ?? EdgeInsets.only(left: 10.w, right: 10.w),
      ),
    );
  }
}
