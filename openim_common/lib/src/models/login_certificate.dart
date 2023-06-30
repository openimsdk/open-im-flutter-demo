import 'dart:convert';

class LoginCertificate {
  String userID;
  String imToken; // im的
  String chatToken; // 业务服务器的

  LoginCertificate.fromJson(Map<String, dynamic> map)
      : userID = map["userID"] ?? '',
        imToken = map["imToken"] ?? '',
        chatToken = map['chatToken'] ?? '';

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userID'] = userID;
    data['imToken'] = imToken;
    data['chatToken'] = chatToken;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
