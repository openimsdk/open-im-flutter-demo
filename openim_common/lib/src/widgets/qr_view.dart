import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:openim_common/openim_common.dart';
import 'package:scan/scan.dart';
import 'package:url_launcher/url_launcher.dart';

import 'qr_scan_box.dart';

class QrcodeView extends StatefulWidget {
  const QrcodeView({Key? key}) : super(key: key);

  @override
  State<QrcodeView> createState() => _QrcodeViewState();
}

class _QrcodeViewState extends State<QrcodeView> with TickerProviderStateMixin {
  final _picker = ImagePicker();
  MobileScannerController controller = MobileScannerController();

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  AnimationController? _animationController;
  Timer? _timer;
  var scanArea = 300.w;
  var cutOutBottomOffset = 40.h;

  void _upState() {
    setState(() {});
  }

  @override
  void initState() {
    _initAnimation();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    _clearAnimation();
    super.dispose();
  }

  void _initAnimation() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _animationController!
      ..addListener(_upState)
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          _timer = Timer(const Duration(seconds: 1), () {
            _animationController?.reverse(from: 1.0);
          });
        } else if (state == AnimationStatus.dismissed) {
          _timer = Timer(const Duration(seconds: 1), () {
            _animationController?.forward(from: 0.0);
          });
        }
      });
    _animationController!.forward(from: 0.0);
  }

  void _clearAnimation() {
    _timer?.cancel();
    if (_animationController != null) {
      _animationController?.dispose();
      _animationController = null;
    }
  }

  void _readImage() {
    Permissions.storage(() async {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (null != image) {
        final result = await Scan.parse(image.path);
        _parse(result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          _buildQrView(),
          _scanOverlay(),
          _buildBackView(),
          _buildTools(),
        ],
      ),
    );
  }

  Widget _buildTools() => Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.only(bottom: 40.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => _readImage(),
                child: Container(
                  width: 45.w,
                  height: 45.h,
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/tool_img.png",
                    width: 35.w,
                    height: 35.h,
                    color: Colors.white54,
                    package: 'openim_common',
                  ),
                ),
              ),
              GestureDetector(
                  onTap: () => controller.toggleTorch(),
                  child: Container(
                    width: 80.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(40.r)),
                      border: Border.all(color: Colors.white30, width: 12.w),
                    ),
                    alignment: Alignment.center,
                    child: ValueListenableBuilder(
                      valueListenable: controller.torchState,
                      builder: (context, state, child) {
                        switch (state as TorchState) {
                          case TorchState.off:
                            return flashClose;
                          case TorchState.on:
                            return flashOpen;
                        }
                      },
                    ),
                  )),
              SizedBox(width: 45.w, height: 45.h),
            ],
          ),
        ),
      );

  final flashOpen = Image.asset(
    "assets/images/tool_flashlight_open.png",
    width: 35.w,
    height: 35.h,
    color: Colors.white,
    package: 'openim_common',
  );
  final flashClose = Image.asset(
    "assets/images/tool_flashlight_close.png",
    width: 35.w,
    height: 35.h,
    color: Colors.white,
    package: 'openim_common',
  );

  Widget _scanOverlay() => Align(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.only(bottom: cutOutBottomOffset * 2),
          child: CustomPaint(
            size: Size(scanArea, scanArea),
            painter: QrScanBoxPainter(
              boxLineColor: Colors.cyanAccent,
              animationValue: _animationController?.value ?? 0,
              isForward: _animationController?.status == AnimationStatus.forward,
            ),
          ),
        ),
      );

  Widget _buildBackView() => Positioned(
        top: 44.h,
        left: 22.w,
        child: IconButton(
          onPressed: () => Get.back(),
          icon: ImageRes.backBlack.toImage
            ..width = 24.w
            ..height = 24.h
            ..color = Colors.white,
        ),
      );

  Widget _buildQrView() {
    return MobileScanner(
      // fit: BoxFit.contain,
      controller: controller,
      onDetect: (capture) {
        final barcodes = capture.barcodes;
        if (barcodes.isNotEmpty) {
          _parse(barcodes.first.displayValue);
        }
      },
    );
  }

  void _parse(String? result) async {
    if (null != result) {
      controller.stop();
      if (result.startsWith(Config.friendScheme)) {
        var userID = result.substring(Config.friendScheme.length);
        PackageBridge.scanBridge?.scanOutUserID(userID);
        // AppNavigator.startFriendInfoFromScan(info: UserInfo(userID: uid));
      } else if (result.startsWith(Config.groupScheme)) {
        var groupID = result.substring(Config.groupScheme.length);
        PackageBridge.scanBridge?.scanOutGroupID(groupID);
        // AppNavigator.startSearchAddGroupFromScan(info: GroupInfo(groupID: gid));
      } else if (IMUtils.isUrlValid(result)) {
        final uri = Uri.parse(Uri.encodeFull(result));
        if (!await launchUrl(uri)) {
          // throw Exception('Could not launch $uri');
          IMViews.showToast('无法识别!');
          // controller?.resumeCamera();
          controller.start();
        }
      } else {
        Get.back(result: result);
        IMViews.showToast('扫码结果：$result');
      }
    } else {
      Get.back();
      IMViews.showToast('无法识别');
    }
  }
}
