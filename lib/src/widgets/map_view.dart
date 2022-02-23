import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_launcher/map_launcher.dart' as ml;
import 'package:map_launcher/src/models.dart';
import 'package:openim_demo/src/res/images.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';

import 'bottom_sheet_view.dart';

class MapView extends StatelessWidget {
  MapView({
    Key? key,
    required this.latitude,
    required this.longitude,
    required this.addr1,
    required this.addr2,
  }) : super(key: key);
  final double latitude;
  final double longitude;
  final String addr1;
  final String addr2;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: FlutterMap(
                options: MapOptions(
                  // crs: const Epsg4326(),
                  center: LatLng(latitude, longitude),
                  // center: LatLng(latitude, longitude),
                  zoom: 16,
                  maxZoom: 18.0,
                  // adaptiveBoundaries: true,
                  screenSize: Size(1.sw, 1.sh),
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                        // 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        // 'https://map.geoq.cn/ArcGIS/rest/services/ChinaOnlineCommunity/MapServer/tile/{z}/{y}/{x}',
                        'https://webrd01.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scale=1&style=8&x={x}&y={y}&z={z}',
                    subdomains: ['a', 'b', 'c'],
                    attributionBuilder: (_) {
                      return Text(
                        "© OpenIM",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                  MarkerLayerOptions(
                    markers: [
                      Marker(
                        point: LatLng(latitude, longitude),
                        builder: (ctx) => Icon(
                          Icons.location_on_sharp,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 18.h),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          addr1,
                          style: PageStyle.ts_333333_18sp,
                        ),
                        Text(
                          addr2,
                          style: PageStyle.ts_333333_12sp,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _openMapSheet(),
                    child: Container(
                      width: 35.w,
                      height: 35.w,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.map,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 44.h,
          left: 22.w,
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Image.asset(
                  ImageRes.ic_back,
                  color: Colors.white,
                  width: 10.w,
                  // height: 18.h,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _openMapSheet() async {
    final availableMaps = await ml.MapLauncher.installedMaps;
    print('-------availableMaps:$availableMaps');
    Get.bottomSheet(
      BottomSheetView(
        /* items: availableMaps
            .map((e) => SheetItem(
                  label: _mapLabel(e),
                  onTap: () async {
                    _launcherMap(e);
                  },
                ))
            .toList(),*/
        items: List.generate(
            availableMaps.length,
            (index) => SheetItem(
                  label: _mapLabel(availableMaps.elementAt(index)),
                  borderRadius: index == 0
                      ? BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        )
                      : null,
                  onTap: () async {
                    _launcherMap(availableMaps.elementAt(index));
                  },
                )),
      ),
    );
  }

  String _mapLabel(AvailableMap map) {
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

  _launcherMap(AvailableMap map) async {
    await ml.MapLauncher.showMarker(
      mapType: map.mapType,
      coords: ml.Coords(latitude, longitude),
      title: addr1,
      description: addr2,
    );
    // if ((await ml.MapLauncher.isMapAvailable(MapType.google)) == true) {
    //   await ml.MapLauncher.showMarker(
    //     mapType: MapType.google,
    //     coords: ml.Coords(latitude, longitude),
    //     title: addr1,
    //     description: addr2,
    //   );
    // }
  }
}
