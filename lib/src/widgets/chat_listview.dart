import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';
import 'package:openim_enterprise_chat/src/res/styles.dart';
import 'package:openim_enterprise_chat/src/widgets/touch_close_keyboard.dart';

class ChatListView extends StatefulWidget {
  const ChatListView({
    Key? key,
    this.onTouch,
    this.onLoad,
    this.itemCount,
    this.controller,
    required this.listViewKey,
    required this.itemBuilder,
  }) : super(key: key);
  final Function()? onTouch;
  final Future<bool> Function()? onLoad;
  final int? itemCount;
  final ScrollController? controller;
  final IndexedWidgetBuilder itemBuilder;
  final ObjectKey listViewKey;

  @override
  _ChatListViewState createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  var _loadMore = true;

  bool _fillFirstPage() => true;

  // bool _fillFirstPage() => (widget.itemCount ?? 0) >= widget.pageSize;

  @override
  void initState() {
    _onLoadMore();
    widget.controller?.addListener(() {
      var max = widget.controller!.position.maxScrollExtent;
      if (widget.controller!.offset >= max && _fillFirstPage()) {
        print('-------------scroll to bottom-------------------------');
        _onLoadMore();
      }
    });
    super.initState();
  }

  void _onLoadMore() {
    widget.onLoad?.call().then((hasMore) {
      if (!mounted) return;
      setState(() {
        _loadMore = hasMore;
      });
    });
  }

  Widget _buildLoadMoreView() => Container(
        height: 20.h,
        child: CupertinoActivityIndicator(),
      );

  int _length() {
    if (widget.itemCount == null || widget.itemCount == 0) {
      return 0;
    }
    return widget.itemCount! + /*(_loadMore ? 1 : 0)*/ 1;
  }

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      onTouch: widget.onTouch,
      child: Align(
        alignment: Alignment.topCenter,
        child: ListView.builder(
          key: widget.listViewKey,
          reverse: true,
          shrinkWrap: true,
          itemCount: _length(),
          padding: EdgeInsets.only(top: 10.h),
          controller: widget.controller,
          itemBuilder: (context, index) {
            if (index == widget.itemCount) {
              if (_loadMore) {
                return _buildLoadMoreView();
              }
              return Container(
                alignment: Alignment.center,
                child: Text(
                  StrRes.noMore,
                  style: PageStyle.ts_999999_10sp,
                ),
              );
            }
            return widget.itemBuilder(context, index);
          },
        ),
      ),
    );
  }
}
