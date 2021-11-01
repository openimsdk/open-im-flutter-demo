// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:openim_enterprise_chat/src/res/images.dart';
// import 'package:openim_enterprise_chat/src/res/strings.dart';
// import 'package:openim_enterprise_chat/src/res/styles.dart';
// import 'package:openim_enterprise_chat/src/widgets/avatar_view.dart';
// import 'package:openim_enterprise_chat/src/widgets/call_view.dart';
//
// class MakeVideoCallView extends StatelessWidget {
//   MakeVideoCallView({Key? key, required this.logic}) : super(key: key);
//
//   // final logic = Get.find<CallLogic>();
//   final CallLogic logic;
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Positioned(
//           top: 53.h,
//           left: 26.w,
//           child: GestureDetector(
//             onTap: () => logic.toggleWindowSize(),
//             behavior: HitTestBehavior.translucent,
//             child: Image.asset(
//               ImageRes.ic_callClose,
//               width: 27.w,
//               height: 26.h,
//             ),
//           ),
//         ),
//         Positioned(
//           top: 113.h,
//           left: 23.w,
//           child: AvatarView(
//             size: 90.h,
//             url: logic.icon,
//           ),
//         ),
//         Positioned(
//           top: 125.h,
//           left: 43.w + 90.h,
//           child: Text(
//             logic.name,
//             style: PageStyle.ts_FFFFFF_32sp,
//           ),
//         ),
//         Positioned(
//           top: 172.h,
//           left: 43.w + 90.h,
//           child: Text(
//             StrRes.waitingAcceptVideoCall,
//             style: PageStyle.ts_FFFFFF_14sp,
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
//                     onTap: () => logic.cancel(),
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
//                     StrRes.cancel,
//                     style: PageStyle.ts_FFFFFF_16sp,
//                   )
//                 ],
//               ),
//               Spacer(),
//               Column(
//                 children: [
//                   GestureDetector(
//                     // onTap: () => logic.toVoice(),
//                     behavior: HitTestBehavior.translucent,
//                     child: Image.asset(
//                       ImageRes.ic_callConvert,
//                       width: 64.w,
//                       height: 64.h,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 16.h,
//                   ),
//                   Text(
//                     StrRes.convertVoice,
//                     style: PageStyle.ts_FFFFFF_16sp,
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
