import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sprintf/sprintf.dart';

class UpgradeViewV2 extends StatefulWidget {
  final Function()? onLater;
  final Function()? onIgnore;
  final Function() onNow;
  final UpgradeInfoV2 upgradeInfo;
  final PackageInfo packageInfo;
  final PublishSubject? subject;

  const UpgradeViewV2({
    super.key,
    this.onLater,
    this.onIgnore,
    required this.onNow,
    required this.upgradeInfo,
    required this.packageInfo,
    this.subject,
  });

  @override
  State<UpgradeViewV2> createState() => _UpgradeViewV2State();
}

class _UpgradeViewV2State extends State<UpgradeViewV2> {
  double _progress = 0.0;
  bool _showProgress = false;

  @override
  void initState() {
    widget.subject?.stream.listen((progress) {
      if (!mounted) return;
      setState(() {
        _progress = progress;
      });
    });
    super.initState();
  }

  void _startDownload() {
    if (Platform.isAndroid) {
      Get.back();
    } else {
      if (!widget.upgradeInfo.needForceUpdate!) {
        Get.back();
      }
    }
    widget.onNow.call();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !widget.upgradeInfo.needForceUpdate!;
      },
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 46.w),
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 12.h,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StrRes.upgradeFind,
                style: TextStyle(
                  color: const Color(0xFF333333),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                sprintf(StrRes.upgradeVersion, [
                  '${widget.upgradeInfo.buildVersion!} + ${widget.upgradeInfo.buildVersionNo!}',
                  '${widget.packageInfo.version} + ${widget.packageInfo.buildNumber}'
                ]),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF333333),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                StrRes.upgradeDescription,
                style: TextStyle(
                  color: const Color(0xFF333333),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Text(
                widget.upgradeInfo.buildUpdateDescription ?? '',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF333333),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              if (!widget.upgradeInfo.needForceUpdate! && !_showProgress)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildButton(
                      text: StrRes.upgradeIgnore,
                      onTap: widget.onIgnore ?? () => Get.back(),
                    ),
                    _buildButton(
                      text: StrRes.upgradeLater,
                      onTap: widget.onLater ?? () => Get.back(),
                    ),
                    _buildButton(
                      text: StrRes.upgradeNow,
                      onTap: _startDownload,
                    ),
                  ],
                ),
              if (widget.upgradeInfo.needForceUpdate! && !_showProgress)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildButton(
                      text: StrRes.upgradeNow,
                      onTap: _startDownload,
                    )
                  ],
                ),
              if (_showProgress)
                SizedBox(
                  height: 44.h,
                  child: Center(
                    child: LinearPercentIndicator(
                      lineHeight: 20.h,
                      percent: _progress,
                      center: "${(_progress * 100).toInt()}%".toText..style = TextStyle(fontSize: 12.sp),
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      backgroundColor: Colors.grey.withOpacity(0.5),
                      progressColor: Colors.blueAccent,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({required String text, Function()? onTap}) => Ink(
        height: 44.h,
        child: InkWell(
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
              horizontal: 14.w,
            ),
            child: Text(
              text,
              style: TextStyle(
                color: const Color(0xFF1B72EC),
                fontSize: 16.sp,
              ),
            ),
          ),
        ),
      );
}
