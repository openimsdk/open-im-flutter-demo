// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:openim_enterprise_chat/src/res/images.dart';
// import 'package:openim_enterprise_chat/src/res/strings.dart';
// import 'package:openim_enterprise_chat/src/res/styles.dart';
// import 'package:openim_enterprise_chat/src/widgets/avatar_view.dart';
// import 'package:sprintf/sprintf.dart';
//
// import '../call_logic.dart';
//
// class BeInvitedGroupCallView extends StatelessWidget {
//   BeInvitedGroupCallView({Key? key}) : super(key: key);
//   final logic = Get.find<GroupCallLogic>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Positioned(
//           top: 69.h,
//           left: 22.w,
//           child: GestureDetector(
//             onTap: () => Get.back(),
//             child: Image.asset(
//               ImageRes.ic_back,
//               color: PageStyle.c_FFFFFF,
//               width: 12.w,
//               height: 21.h,
//             ),
//           ),
//         ),
//         Positioned(
//           top: 131.h,
//           // left: 22.w,
//           width: 375.w,
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 22.w),
//             child: Row(
//               children: [
//                 AvatarView(
//                   size: 54.h,
//                   url: logic.senderIcon.isEmpty ? null : logic.senderIcon.value,
//                 ),
//                 SizedBox(
//                   width: 16.w,
//                 ),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         sprintf(
//                           logic.isVoiceCall()
//                               ? StrRes.groupCallVoiceInvite
//                               : StrRes.groupCallVideoInvite,
//                           [logic.senderName.value],
//                         ),
//                         style: PageStyle.ts_FFFFFF_20sp,
//                       ),
//                       SizedBox(
//                         height: 4.h,
//                       ),
//                       Text(
//                         sprintf(
//                           logic.isVoiceCall()
//                               ? StrRes.xPersonGroupVoiceCalling
//                               : StrRes.xPersonGroupVideoCalling,
//                           [logic.seatMap.length],
//                         ),
//                         style: PageStyle.ts_FFFFFF_12sp,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Positioned(
//           top: 240.h,
//           width: 375.w,
//           child: Container(
//             height: 70.h,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: logic.seatMap.length,
//               padding: EdgeInsets.symmetric(horizontal: 22.w),
//               itemBuilder: (_, index) {
//                 return Container(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       AvatarView(
//                         size: 44.h,
//                         url: logic.getMemberAvatar(index),
//                       ),
//                       SizedBox(
//                         height: 4.h,
//                       ),
//                       Text(
//                         logic.getMemberName(index),
//                         style: PageStyle.ts_FFFFFF_12sp,
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//         Positioned(
//           top: 648.h,
//           width: 375.w,
//           child: Row(
//             children: [
//               SizedBox(
//                 width: 75.w,
//               ),
//               Column(
//                 children: [
//                   GestureDetector(
//                     onTap: () => logic.refuse(),
//                     behavior: HitTestBehavior.translucent,
//                     child: Image.asset(
//                       ImageRes.ic_callHangup,
//                       width: 64.w,
//                       height: 64.h,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 16.h,
//                   ),
//                   Text(
//                     StrRes.refuse,
//                     style: PageStyle.ts_999999_16sp,
//                   )
//                 ],
//               ),
//               Spacer(),
//               Column(
//                 children: [
//                   GestureDetector(
//                     onTap: () => logic.accept(),
//                     behavior: HitTestBehavior.translucent,
//                     child: Image.asset(
//                       ImageRes.ic_callPickup,
//                       width: 64.w,
//                       height: 64.h,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 16.h,
//                   ),
//                   Text(
//                     StrRes.pickup,
//                     style: PageStyle.ts_999999_16sp,
//                   )
//                 ],
//               ),
//               SizedBox(
//                 width: 75.w,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
