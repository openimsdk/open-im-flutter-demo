import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart' hide Config;
import 'package:should_rebuild/should_rebuild.dart';

class ChatEmojiView extends StatefulWidget {
  const ChatEmojiView({
    Key? key,
    this.favoriteList = const [],
    this.onAddFavorite,
    this.onSelectedFavorite,
    required this.textEditingController,
    this.height,
    this.customEmojiLayout,
  }) : super(key: key);
  final List<String> favoriteList;
  final Function()? onAddFavorite;
  final Function(int index, String url)? onSelectedFavorite;
  final TextEditingController textEditingController;
  final double? height;
  final Widget? customEmojiLayout;

  @override
  State<ChatEmojiView> createState() => _ChatEmojiViewState();
}

class _ChatEmojiViewState extends State<ChatEmojiView> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Styles.c_FFFFFF,
      child: Column(
        children: [
          IndexedStack(
            index: _index,
            children: [
              widget.customEmojiLayout ??
                  ShouldRebuild<EmojiLayout>(
                    shouldRebuild: (oldWidget, newWidget) => false,
                    child: EmojiLayout(
                      controller: widget.textEditingController,
                    ),
                  ),
              _buildFavoriteLayout(),
            ],
          ),
          _buildTabView(),
        ],
      ),
    );
  }

  Widget _buildTabView() => Container(
        height: 56.h,
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          border: BorderDirectional(
            top: BorderSide(
              color: Styles.c_E8EAEF,
              width: 1.h,
            ),
          ),
        ),
        child: Row(
          children: [
            _buildTabSelectedBgView(selected: _index == 0, index: 0),
            _buildTabSelectedBgView(selected: _index == 1, index: 1),
          ],
        ),
      );

  Widget _buildTabSelectedBgView({
    bool selected = false,
    int index = 0,
  }) =>
      GestureDetector(
        onTap: () {
          setState(() {
            _index = index;
          });
        },
        child: Container(
          width: 62.w,
          height: 56.h,
          decoration: BoxDecoration(
            color: selected ? Styles.c_E8EAEF : null,
          ),
          child: Center(
            child: (index == 0 ? ImageRes.emojiTab : ImageRes.favoriteTab).toImage
              ..width = 28.w
              ..height = 28.h
              ..color = (selected ? Styles.c_0089FF : Styles.c_8E9AB0),
          ),
        ),
      );

  Widget _buildFavoriteLayout() => Container(
        color: Styles.c_FFFFFF,
        height: widget.height ?? 188.h,
        child: GridView.builder(
          padding: EdgeInsets.fromLTRB(22.w, 12.h, 22.w, 22.h),
          itemCount: widget.favoriteList.length + 1,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1,
            mainAxisSpacing: 22.h,
            crossAxisSpacing: 22.w,
          ),
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return GestureDetector(
                onTap: widget.onAddFavorite,
                child: ImageRes.addFavorite.toImage
                  ..width = 66.w
                  ..height = 66.h,
              );
            }
            var url = widget.favoriteList.elementAt(index - 1);
            return GestureDetector(
              onTap: () => widget.onSelectedFavorite?.call(index - 1, url),
              child: ImageUtil.networkImage(
                url: url,
                width: 66.w,
                height: 66.h,
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      );
}

class EmojiLayout extends StatelessWidget {
  const EmojiLayout({
    Key? key,
    required this.controller,
    this.height,
  }) : super(key: key);
  final TextEditingController controller;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 188.h,
      color: Styles.c_FFFFFF,
      child: EmojiPicker(
          onEmojiSelected: (category, emoji) {
            controller
              ..text += emoji.emoji
              ..selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
          },
          onBackspacePressed: () {
            controller
              ..text = controller.text.characters.skipLast(1).toString()
              ..selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
          },
          config: Config(
            checkPlatformCompatibility: true,
            emojiViewConfig: EmojiViewConfig(
              columns: 8,
              recentsLimit: 9,
              emojiSizeMax: 28 * (Platform.isIOS ? 1.20 : 1.0),
            ),
            skinToneConfig: SkinToneConfig(enabled: false),
            categoryViewConfig: CategoryViewConfig(),
            bottomActionBarConfig: BottomActionBarConfig(enabled: false),
            searchViewConfig: SearchViewConfig(),
          )),
    );
  }
}
