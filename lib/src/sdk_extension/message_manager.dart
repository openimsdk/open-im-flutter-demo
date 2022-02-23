import 'dart:convert';

import 'package:flutter_openim_widget/flutter_openim_widget.dart';

extension MessageManagerExt on MessageManager {
  /// 通话消息；语音/视频通话
  /// [ type ] video/voice
  /// [ state ] 已拒绝/对方已拒绝/已取消/对方已取消/其他
  Future<Message> createCallMessage({
    required String type,
    required String state,
    int? duration,
  }) =>
      createCustomMessage(
        data: json.encode({
          "customType": CustomMessageType.call,
          "data": {
            'duration': duration,
            'state': state,
            'type': type,
          },
        }),
        extension: '',
        description: '',
      );
}

class CustomMessageType {
  static const call = 901;
}
