class ApiResp {
  int errCode;
  String errMsg;
  dynamic data;

  ApiResp.fromJson(Map<String, dynamic> map)
      : errCode = map["errCode"],
        errMsg = map["errMsg"],
        data = map["data"];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['errCode'] = errCode;
    data['errMsg'] = errMsg;
    data['data'] = data;
    return data;
  }
}
