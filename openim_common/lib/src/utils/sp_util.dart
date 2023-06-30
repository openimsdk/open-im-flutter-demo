import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SpUtil {
  SharedPreferences? prefs;

  SpUtil._();

  static final SpUtil _singleton = SpUtil._();

  factory SpUtil() => _singleton;

  Future init() async {
    prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  /// put object.
  Future<bool>? putObject(String key, Object value) {
    return prefs?.setString(key, json.encode(value));
  }

  /// get obj.
  T? getObj<T>(String key, T Function(Map v) f, {T? defValue}) {
    final map = getObject(key);
    return map == null ? defValue : f(map);
  }

  /// get object.
  Map? getObject(String key) {
    final data = prefs?.getString(key);
    return (data == null || data.isEmpty) ? null : json.decode(data);
  }

  /// put object list.
  Future<bool>? putObjectList(String key, List<Object> list) {
    final dataList = list.map((value) => json.encode(value)).toList();
    return prefs?.setStringList(key, dataList);
  }

  /// get obj list.
  List<T>? getObjList<T>(
    String key,
    T Function(Map v) f, {
    List<T>? defValue = const [],
  }) {
    List<Map>? dataList = getObjectList(key);
    List<T>? list = dataList?.map((value) => f(value)).toList();
    return list ?? defValue;
  }

  /// get object list.
  List<Map>? getObjectList(String key) {
    List<String>? dataLis = prefs?.getStringList(key);
    return dataLis?.map((value) {
      Map dataMap = json.decode(value);
      return dataMap;
    }).toList();
  }

  /// get string.
  String? getString(String key, {String? defValue = ''}) {
    return prefs?.getString(key) ?? defValue;
  }

  /// put string.
  Future<bool>? putString(String key, String value) {
    return prefs?.setString(key, value);
  }

  /// get bool.
  bool? getBool(String key, {bool? defValue = false}) {
    return prefs?.getBool(key) ?? defValue;
  }

  /// put bool.
  Future<bool>? putBool(String key, bool value) {
    return prefs?.setBool(key, value);
  }

  /// get int.
  int? getInt(String key, {int? defValue = 0}) {
    return prefs?.getInt(key) ?? defValue;
  }

  /// put int.
  Future<bool>? putInt(String key, int value) {
    return prefs?.setInt(key, value);
  }

  /// get double.
  double? getDouble(String key, {double? defValue = 0.0}) {
    return prefs?.getDouble(key) ?? defValue;
  }

  /// put double.
  Future<bool>? putDouble(String key, double value) {
    return prefs?.setDouble(key, value);
  }

  /// get string list.
  List<String>? getStringList(String key, {List<String>? defValue = const []}) {
    return prefs?.getStringList(key) ?? defValue;
  }

  /// put string list.
  Future<bool>? putStringList(String key, List<String> value) {
    return prefs?.setStringList(key, value);
  }

  /// get dynamic.
  dynamic getDynamic(String key, {Object? defValue}) {
    return prefs?.get(key) ?? defValue;
  }

  /// have key.
  bool? haveKey(String key) {
    return prefs?.getKeys().contains(key);
  }

  /// contains Key.
  bool? containsKey(String key) {
    return prefs?.containsKey(key);
  }

  /// get keys.
  Set<String>? getKeys() {
    return prefs?.getKeys();
  }

  /// remove.
  Future<bool>? remove(String key) {
    return prefs?.remove(key);
  }

  /// clear.
  Future<bool>? clear() {
    return prefs?.clear();
  }

  /// Fetches the latest values from the host platform.
  Future<void>? reload() {
    return prefs?.reload();
  }

  ///Sp is initialized.
  bool isInitialized() {
    return null != prefs;
  }

  /// get Sp.
  SharedPreferences? getSp() {
    return prefs;
  }
}
