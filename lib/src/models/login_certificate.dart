class LoginCertificate {
  String userID;
  String token;

  LoginCertificate.fromJson(Map<String, dynamic> map)
      : userID = map["userID"],
        token = map["token"];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userID'] = userID;
    data['token'] = token;
    return data;
  }
}
