import 'package:hive/hive.dart';

part 'emoji_info.g.dart';

@HiveType(typeId: 1)
class EmojiInfo {
  @HiveField(1)
  String? url;
  @HiveField(2)
  int? width;
  @HiveField(3)
  int? height;

  EmojiInfo({this.url, this.width, this.height});
}
