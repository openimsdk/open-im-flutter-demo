import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

extension ScrollControllerExt on ScrollController {
  Future scrollToBottom(Function()? onScrollStop) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      while (position.pixels != position.maxScrollExtent) {
        jumpTo(position.maxScrollExtent);
        await SchedulerBinding.instance.endOfFrame;
      }
      onScrollStop?.call();
    });
  }

  Future scrollToTop() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      while (position.pixels != position.minScrollExtent) {
        jumpTo(position.minScrollExtent);
        await SchedulerBinding.instance.endOfFrame;
      }
    });
  }
}

class CustomChatListViewController<E> extends ChangeNotifier {
  final _topList = <E>[];

  final _bottomList = <E>[];

  List<E> get topList => _topList;

  List<E> get bottomList => _bottomList;

  List<E> get list => _topList + _bottomList;

  int get length => list.length;

  bool topHasMore = true;
  bool bottomHasMore = true;

  CustomChatListViewController(List<E> list) {
    _bottomList.addAll(list);
  }

  void insertToTop(E data) {
    _topList.insert(0, data);
  }

  void insertAllToTop(Iterable<E> iterable) {
    _topList.insertAll(0, iterable);
  }

  void insertToBottom(E data) {
    _bottomList.add(data);
  }

  void insertAllToBottom(Iterable<E> iterable) {
    _bottomList.addAll(iterable);
  }

  void bottomLoadCompleted(bool hasMore) {
    bottomHasMore = hasMore;
    notifyListeners();
  }

  void topLoadCompleted(bool hasMore) {
    topHasMore = hasMore;
    notifyListeners();
  }

  E elementAt(int position) => list.elementAt(position);

  E removeAt(int position) => list.removeAt(position);

  bool remove(Object? value) => list.remove(value);
}

typedef CustomChatListViewItemBuilder<T> = Widget Function(
  BuildContext context,
  int index,
  int position,
  T data,
);

class CustomChatListView extends StatefulWidget {
  const CustomChatListView({
    Key? key,
    required this.itemBuilder,
    required this.controller,
    this.scrollController,
    this.onScrollToTopLoad,
    this.onScrollToBottomLoad,
    this.enabledBottomLoad = false,
    this.enabledTopLoad = false,
    this.indicatorColor,
  }) : super(key: key);

  final CustomChatListViewItemBuilder itemBuilder;

  final CustomChatListViewController controller;

  final ScrollController? scrollController;

  final Future<bool> Function()? onScrollToTopLoad;

  final Future<bool> Function()? onScrollToBottomLoad;

  final bool enabledTopLoad;

  final bool enabledBottomLoad;

  final Color? indicatorColor;

  @override
  State<CustomChatListView> createState() => _CustomChatListViewState();
}

class _CustomChatListViewState extends State<CustomChatListView> {
  final Key centerKey = const ValueKey('second-sliver-list');

  bool _bottomHasMore = true;

  bool _topHasMore = true;

  bool get _isBottom => widget.scrollController!.offset == widget.scrollController!.position.maxScrollExtent;

  bool get _isTop => widget.scrollController!.offset == widget.scrollController!.position.minScrollExtent;

  @override
  void initState() {
    widget.controller.addListener(_loadFinished);
    widget.scrollController?.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_loadFinished);
    widget.scrollController?.removeListener(_scrollListener);
    super.dispose();
  }

  void _loadFinished() {
    setState(() {
      _topHasMore = widget.controller.topHasMore;
      _bottomHasMore = widget.controller.bottomHasMore;
    });
  }

  void _scrollListener() {
    if (widget.enabledBottomLoad && _isBottom && _bottomHasMore) {
      _onScrollToBottomLoadMore();
    } else if (widget.enabledTopLoad && _isTop && _topHasMore) {
      _onScrollToTopLoadMore();
    }
  }

  void _onScrollToBottomLoadMore() {
    widget.onScrollToBottomLoad?.call().then((hasMore) {
      if (!mounted) return;
      setState(() {
        _bottomHasMore = hasMore;
      });
    });
  }

  void _onScrollToTopLoadMore() {
    widget.onScrollToTopLoad?.call().then((hasMore) {
      if (!mounted) return;
      setState(() {
        _topHasMore = hasMore;
      });
    });
  }

  Widget _buildLoadMoreView() => Container(
        alignment: Alignment.center,
        height: 44,
        child: CupertinoActivityIndicator(
          color: widget.indicatorColor ?? Colors.blueAccent,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      center: centerKey,
      controller: widget.scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: <Widget>[
        if (_topHasMore && widget.enabledTopLoad) SliverToBoxAdapter(child: _buildLoadMoreView()),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) {
              return widget.itemBuilder(
                context,
                index,
                widget.controller.topList.length - index - 1,
                widget.controller.topList.elementAt(widget.controller.topList.length - 1 - index),
              );
            },
            childCount: widget.controller.topList.length,
          ),
        ),
        SliverList(
          key: centerKey,
          delegate: SliverChildBuilderDelegate(
            (_, index) {
              return widget.itemBuilder(
                context,
                index,
                widget.controller.topList.length + index,
                widget.controller.bottomList.elementAt(index),
              );
            },
            childCount: widget.controller.bottomList.length,
          ),
        ),
        if (_bottomHasMore && widget.enabledBottomLoad) SliverToBoxAdapter(child: _buildLoadMoreView()),
      ],
    );
  }
}

class ChatListView extends StatefulWidget {
  const ChatListView({
    Key? key,
    this.physics,
    this.onTouch,
    this.itemCount,
    this.controller,
    required this.itemBuilder,
    this.enabledScrollTopLoad = false,
    this.onScrollToBottomLoad,
    this.onScrollToTopLoad,
    this.onScrollToBottom,
    this.onScrollToTop,
  }) : super(key: key);
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final int? itemCount;
  final IndexedWidgetBuilder itemBuilder;

  final Future<bool> Function()? onScrollToBottomLoad;

  final Future<bool> Function()? onScrollToTopLoad;
  final Function()? onScrollToBottom;
  final Function()? onScrollToTop;

  final bool enabledScrollTopLoad;
  final Function()? onTouch;

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  bool _scrollToBottomLoadMore = true;
  bool _scrollToTopLoadMore = true;

  bool get _isBottom => widget.controller!.offset >= widget.controller!.position.maxScrollExtent;

  bool get _isTop => widget.controller!.offset <= 0;

  @override
  void dispose() {
    widget.controller?.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  void initState() {
    _onScrollToBottomLoadMore();
    widget.controller?.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    if (_isBottom) {
      Logger.print('-------------ChatListView scroll to bottom');
      _onScrollToBottomLoadMore();
    } else if (_isTop) {
      Logger.print('-------------ChatListView scroll to top');
      _onScrollToTopLoadMore();
    }
  }

  void _onScrollToBottomLoadMore() {
    widget.onScrollToBottom?.call();
    widget.onScrollToBottomLoad?.call().then((hasMore) {
      if (!mounted) return;
      setState(() {
        _scrollToBottomLoadMore = hasMore;
      });
    });
  }

  void _onScrollToTopLoadMore() {
    widget.onScrollToTop?.call();
    if (widget.enabledScrollTopLoad) {
      widget.onScrollToTopLoad?.call().then((hasMore) {
        if (!mounted) return;
        setState(() {
          _scrollToTopLoadMore = hasMore;
        });
      });
    }
  }

  Widget get loadMoreView => Container(
        alignment: Alignment.center,
        height: 44,
        child: CupertinoActivityIndicator(color: Styles.c_0089FF),
      );

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      onTouch: widget.onTouch,
      child: Align(
        alignment: Alignment.topCenter,
        child: ListView.builder(
          reverse: true,
          shrinkWrap: true,
          physics: widget.physics ?? const ClampingScrollPhysics(),
          itemCount: widget.itemCount ?? 0,
          padding: EdgeInsets.only(top: 10.h),
          controller: widget.controller,
          itemBuilder: (context, index) => _wrapLoadMoreItem(index),
        ),
      ),
    );
  }

  Widget _wrapLoadMoreItem(int index) {
    final child = widget.itemBuilder(context, index);
    if (index == widget.itemCount! - 1) {
      return _scrollToBottomLoadMore ? Column(children: [loadMoreView, child]) : child;
    }
    if (index == 0 && widget.enabledScrollTopLoad) {
      return _scrollToTopLoadMore ? Column(children: [child, loadMoreView]) : child;
    }
    return child;
  }
}

class PositionRetainedScrollPhysics extends ClampingScrollPhysics {
  final bool shouldRetain;

  const PositionRetainedScrollPhysics({super.parent, this.shouldRetain = true});

  @override
  PositionRetainedScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return PositionRetainedScrollPhysics(
      parent: buildParent(ancestor),
      shouldRetain: shouldRetain,
    );
  }

  @override
  double adjustPositionForNewDimensions({
    required ScrollMetrics oldPosition,
    required ScrollMetrics newPosition,
    required bool isScrolling,
    required double velocity,
  }) {
    final position = super.adjustPositionForNewDimensions(
      oldPosition: oldPosition,
      newPosition: newPosition,
      isScrolling: isScrolling,
      velocity: velocity,
    );

    final diff = newPosition.maxScrollExtent - oldPosition.maxScrollExtent;

    if (oldPosition.pixels > oldPosition.minScrollExtent && diff > 0 && shouldRetain) {
      return position + diff;
    } else {
      return position;
    }
  }
}
