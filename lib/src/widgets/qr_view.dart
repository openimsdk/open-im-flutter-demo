import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:openim_demo/src/res/images.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';
import 'package:openim_demo/src/widgets/qr_scan_box.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:r_scan/r_scan.dart';

class IMQrcodeUrl {
  static final addFriend = "io.openim.app/addFriend/";
  static final joinGroup = "io.openim.app/joinGroup/";
}

class QrcodeView extends StatefulWidget {
  const QrcodeView({Key? key}) : super(key: key);

  @override
  _QrcodeViewState createState() => _QrcodeViewState();
}

class _QrcodeViewState extends State<QrcodeView> with TickerProviderStateMixin {
  final _picker = ImagePicker();

  // Barcode? result;
  QRViewController? controller;

  // Stream? stream;
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
    // stream?.cancel();
    controller?.dispose();
    _clearAnimation();
    super.dispose();
  }

  void _initAnimation() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _animationController!
      ..addListener(_upState)
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          _timer = Timer(Duration(seconds: 1), () {
            _animationController?.reverse(from: 1.0);
          });
        } else if (state == AnimationStatus.dismissed) {
          _timer = Timer(Duration(seconds: 1), () {
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

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  void _readImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (null != image) {
      final result = await RScan.scanImagePath(image.path);
      _parse(result.message);
    }
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
                  width: 45,
                  height: 45,
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/tool_img.png",
                    width: 25,
                    height: 25,
                    color: Colors.white54,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await controller?.toggleFlash();
                  setState(() {});
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    border: Border.all(color: Colors.white30, width: 12),
                  ),
                  alignment: Alignment.center,
                  child: FutureBuilder(
                    future: controller?.getFlashStatus(),
                    builder: (context, snapshot) {
                      return snapshot.data == true ? flashOpen : flashClose;
                    },
                  ),
                ),
              ),
              SizedBox(width: 45, height: 45),
            ],
          ),
        ),
      );

  final flashOpen = Image.asset(
    "assets/images/tool_flashlight_open.png",
    width: 35,
    height: 35,
    color: Colors.white,
  );
  final flashClose = Image.asset(
    "assets/images/tool_flashlight_close.png",
    width: 35,
    height: 35,
    color: Colors.white,
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
              isForward:
                  _animationController?.status == AnimationStatus.forward,
            ),
          ),
        ),
      );

  Widget _buildBackView() => Positioned(
        top: 44.h,
        left: 22.w,
        child: IconButton(
          onPressed: () => Get.back(),
          icon: ImageIcon(
            AssetImage(ImageRes.ic_back),
            color: Colors.white,
            size: 25.h,
          ),
        ),
      );

  Widget _buildQrView() {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    // var scanArea = 300.w;
    // var scanArea = (MediaQuery.of(context).size.width < 400.w ||
    //     MediaQuery.of(context).size.height < 400)
    //     ? 150.0
    //     : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.white,
          borderRadius: 12,
          borderLength: 0,
          borderWidth: 0,
          cutOutBottomOffset: cutOutBottomOffset,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    this.controller?.scannedDataStream.asBroadcastStream().listen((scanData) {
      if (!mounted) return;
      _parse(scanData.code);
      // result = scanData;
      // setState(() {
      // Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}
      // });
    });
  }

  void _parse(String? result) {
    if (null != result) {
      controller?.pauseCamera();
      if (result.startsWith(IMQrcodeUrl.addFriend)) {
        var uid = result.substring(IMQrcodeUrl.addFriend.length);
        AppNavigator.startFriendInfo2(info: UserInfo(userID: uid));
        // Get.back();
      } else if (result.startsWith(IMQrcodeUrl.joinGroup)) {
        var gid = result.substring(IMQrcodeUrl.joinGroup.length);
        AppNavigator.startSearchAddGroup2(info: GroupInfo(groupID: gid));
        // Get.back();
      } else {
        Get.back();
        Get.snackbar('QRCode', result);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(result)),
        // );
      }
    } else {
      Get.back();
      Get.snackbar('QRCode', 'Not find');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Not find')),
      // );
    }
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }
}
