import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_launcher/map_launcher.dart' as ml;
import 'package:openim_common/openim_common.dart';

class MapView extends StatelessWidget {
  const MapView({
    Key? key,
    required this.latitude,
    required this.longitude,
    required this.address1,
    required this.address2,
  }) : super(key: key);
  final double latitude;
  final double longitude;
  final String address1;
  final String address2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrRes.location),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(latitude, longitude),
                initialZoom: 15.0,
                maxZoom: 18.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://webrd01.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scale=1&style=8&x={x}&y={y}&z={z}',
                  userAgentPackageName: '',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(latitude, longitude),
                      child: Icon(
                        Icons.location_on_sharp,
                        color: Styles.c_FF381F,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      address1.toText..style = Styles.ts_0C1C33_17sp_semibold,
                      8.verticalSpace,
                      address2.toText..style = Styles.ts_8E9AB0_14sp,
                    ],
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _openMapSheet,
                  child: Container(
                    width: 35.w,
                    height: 35.w,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.map, color: Colors.white),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _openMapSheet() async {
    final availableMaps = await ml.MapLauncher.installedMaps;
    Get.bottomSheet(
      BottomSheetView(
        items: availableMaps
            .map((e) => SheetItem(
                  label: _mapLabel(e),
                  onTap: () async {
                    _launcherMap(e);
                  },
                ))
            .toList(),
      ),
    );
  }

  String _mapLabel(ml.AvailableMap map) {
    if (map.mapType == ml.MapType.google) {
      return StrRes.googleMap;
    } else if (map.mapType == ml.MapType.apple) {
      return StrRes.appleMap;
    } else if (map.mapType == ml.MapType.baidu) {
      return StrRes.baiduMap;
    } else if (map.mapType == ml.MapType.amap) {
      return StrRes.amapMap;
    } else if (map.mapType == ml.MapType.tencent) {
      return StrRes.tencentMap;
    }
    return map.mapName;
  }

  _launcherMap(ml.AvailableMap map) async {
    await ml.MapLauncher.showMarker(
      mapType: map.mapType,
      coords: ml.Coords(latitude, longitude),
      title: address1,
      description: address2,
    );
  }
}
