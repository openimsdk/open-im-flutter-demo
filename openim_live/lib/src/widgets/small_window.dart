import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

import '../../openim_live.dart';

class SmallWindowView extends StatelessWidget {
  const SmallWindowView({
    Key? key,
    this.userInfo,
    this.groupInfo,
    required this.callState,
    this.opacity = 1,
    this.onTapMaximize,
    this.child,
    this.onPanUpdate,
  }) : super(key: key);
  final CallState callState;
  final UserInfo? userInfo;
  final GroupInfo? groupInfo;
  final double opacity;
  final Function()? onTapMaximize;
  final Widget? Function(CallState state)? child;
  final GestureDragUpdateCallback? onPanUpdate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapMaximize,
      onPanUpdate: onPanUpdate,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.r),
        child: child?.call(callState) ??
            Container(
              width: 84.w,
              height: 101.h,
              decoration: BoxDecoration(
                color: Styles.c_0C1C33_opacity80,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (null != userInfo)
                      AvatarView(
                        text: IMUtils.emptyStrToNull(userInfo!.remark) ??
                            userInfo!.nickname,
                        url: userInfo!.faceURL,
                      ),
                    if (null != groupInfo)
                      AvatarView(
                        text: groupInfo!.groupName,
                        url: groupInfo!.faceURL,
                      ),
                    10.verticalSpace,
                    callStateStr.toText
                      ..style = Styles.ts_FFFFFF_12sp
                      ..maxLines = 1
                      ..overflow = TextOverflow.ellipsis,
                  ],
                ),
              ),
            ),
      ),
    );
  }

  String get callStateStr {
    if (callState == CallState.call) {
      return StrRes.waitingToAnswer;
    } else if (callState == CallState.beCalled) {
      return StrRes.invitedYouToCall;
    } else if (callState == CallState.calling) {
      return StrRes.calling;
    } else if (callState == CallState.connecting) {
      return StrRes.connecting;
    }
    return 'unknown';
  }
}

// class SmallWindowView extends StatefulWidget {
//   const SmallWindowView({
//     Key? key,
//     required this.callStateStream,
//     this.userInfo,
//     this.groupInfo,
//     this.initState = CallState.call,
//     this.opacity = 1,
//     this.onTapMaximize,
//     this.child,
//   }) : super(key: key);
//   final Stream<CallState> callStateStream;
//   final CallState initState;
//   final UserInfo? userInfo;
//   final GroupInfo? groupInfo;
//   final double opacity;
//   final Function()? onTapMaximize;
//   final Widget? Function(CallState state)? child;
//
//   @override
//   State<SmallWindowView> createState() => _SmallWindowViewState();
// }
//
// class _SmallWindowViewState extends State<SmallWindowView> {
//   late CallState _callState;
//   StreamSubscription<CallState>? _sub;
//
//   @override
//   void dispose() {
//     _sub?.cancel();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     _onChangedCallState(widget.initState);
//     _sub = widget.callStateStream.listen(_onChangedCallState);
//     super.initState();
//   }
//
//   _onChangedCallState(CallState state) {
//     if (!mounted) return;
//     setState(() {
//       _callState = state;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: widget.onTapMaximize,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(6.r),
//         child: widget.child?.call(_callState) ??
//             Container(
//               width: 84.w,
//               height: 101.h,
//               decoration: BoxDecoration(
//                 color: Styles.c_0C1C33_opacity80,
//                 borderRadius: BorderRadius.circular(6.r),
//               ),
//               child: Material(
//                 color: Colors.transparent,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     if (null != widget.userInfo)
//                       AvatarView(
//                         text: IMUtils.emptyStrToNull(widget.userInfo!.remark) ??
//                             widget.userInfo!.nickname,
//                         url: widget.userInfo!.faceURL,
//                       ),
//                     if (null != widget.groupInfo)
//                       AvatarView(
//                         text: widget.groupInfo!.groupName,
//                         url: widget.groupInfo!.faceURL,
//                       ),
//                     10.verticalSpace,
//                     callStateStr.toText..style = Styles.ts_FFFFFF_12sp,
//                   ],
//                 ),
//               ),
//             ),
//       ),
//     );
//   }
//
//   String get callStateStr {
//     if (_callState == CallState.call) {
//       return StrRes.waitingToAnswer;
//     } else if (_callState == CallState.beCalled) {
//       return StrRes.invitedYouToCall;
//     } else if (_callState == CallState.calling) {
//       return StrRes.calling;
//     } else if (_callState == CallState.connecting) {
//       return StrRes.connecting;
//     }
//     return 'unknown';
//   }
// }

// class SmallWindowView extends StatelessWidget {
//   const SmallWindowView({
//     Key? key,
//     required this.callState,
//     required this.opacity,
//     required this.userInfo,
//     this.onTapMaximize,
//     this.child,
//   }) : super(key: key);
//   final CallState callState;
//   final UserInfo userInfo;
//   final double opacity;
//   final Function()? onTapMaximize;
//   final Widget? child;
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedOpacity(
//       opacity: opacity,
//       duration: const Duration(milliseconds: 200),
//       child: GestureDetector(
//         onTap: onTapMaximize,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(6.r),
//           child: child ??
//               Container(
//                 width: 84.w,
//                 height: 101.h,
//                 decoration: BoxDecoration(
//                   color: Styles.c_0C1C33_opacity80,
//                   borderRadius: BorderRadius.circular(6.r),
//                 ),
//                 child: Material(
//                   color: Colors.transparent,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       AvatarView(
//                         text: IMUtils.emptyStrToNull(userInfo.remark) ??
//                             userInfo.nickname,
//                         url: userInfo.faceURL,
//                       ),
//                       10.verticalSpace,
//                       callStateStr.toText..style = Styles.ts_FFFFFF_12sp,
//                     ],
//                   ),
//                 ),
//               ),
//         ),
//       ),
//     );
//   }
//
//   String get callStateStr {
//     if (callState == CallState.call) {
//       return StrRes.waitingToAnswer;
//     } else if (callState == CallState.beCalled) {
//       return StrRes.invitedYouToCall;
//     } else if (callState == CallState.calling) {
//       return StrRes.calling;
//     }
//     return 'unknown';
//   }
// }
