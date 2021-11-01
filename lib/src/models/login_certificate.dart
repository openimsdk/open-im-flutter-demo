class LoginCertificate {
  String uid;
  String token;

  LoginCertificate.fromJson(Map<String, dynamic> map)
      : uid = map["uid"],
        token = map["token"];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uid'] = uid;
    data['token'] = token;
    return data;
  }
}
