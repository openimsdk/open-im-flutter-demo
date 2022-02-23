import 'dart:convert';

class DeepCopy {
  ///
  static List<T> copy<T>(List<T> list, T f(Map v)) {
    List data = json.decode(json.encode(list));
    return data.map((e) => f(e)).toList();
  }
}
