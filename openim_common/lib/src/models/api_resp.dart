import 'dart:convert';

class ApiResp {
  int errCode;
  String errMsg;
  String errDlt;
  dynamic data;

  ApiResp.fromJson(Map<String, dynamic> map)
      : errCode = map["errCode"] ?? -1,
        errMsg = map["errMsg"] ?? '',
        errDlt = map["errDlt"] ?? '',
        data = map["data"];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['errCode'] = errCode;
    data['errMsg'] = errMsg;
    data['errDlt'] = errDlt;
    data['data'] = data;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}

class ApiError {
  static String getMsg(int errorCode) {
    return _errorZH['$errorCode'] ?? '';
  }

  static const _errorZH = {
    '10001': '请求参数错误',
    '10002': '数据库错误',
    '10003': '服务器错误',
    '10006': '记录不存在',
    '20001': '账号已注册',
    '20002': '重复发送验证码',
    '20003': '邀请码错误',
    '20004': '注册IP受限',
    '30001': '验证码错误',
    '30002': '验证码已过期',
    '30003': '邀请码被使用',
    '30004': '邀请码不存在',
    '40001': '账号未注册',
    '40002': '密码错误',
    '40003': '登录受ip限制',
    '40004': 'ip禁止注册登录',
    '50001': '过期',
    '50002': '格式错误',
    '50003': '未生效',
    '50004': '未知错误',
    '50005': '创建错误',
  };
  static const _errorEN = {};
}
