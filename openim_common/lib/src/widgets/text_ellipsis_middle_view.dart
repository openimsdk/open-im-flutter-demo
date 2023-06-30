import 'package:flutter/cupertino.dart';

class TextWithMidEllipsis extends StatelessWidget {
  final String data;
  final TextStyle style;
  final TextAlign? textAlign;
  final TextDirection textDirection;
  final int endPartLength;

  const TextWithMidEllipsis(
    this.data, {
    Key? key,
    this.textAlign,
    this.style = const TextStyle(),
    this.endPartLength = 10,
  })  : textDirection = TextDirection.ltr,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        if (constraint.maxWidth <= _textSize(data, style).width &&
            data.length > endPartLength) {
          var endPart = data.trim().substring(data.length - endPartLength);
          return Row(
            children: [
              Flexible(
                child: Text(
                  data.fixOverflowEllipsis,
                  style: style,
                  textAlign: textAlign,
                  overflow: TextOverflow.ellipsis,
                  textDirection: textDirection,
                ),
              ),
              Text(
                endPart,
                style: style,
                textDirection: textDirection,
                textAlign: textAlign,
              ),
            ],
          );
        }
        return Text(
          data,
          style: style,
          textAlign: textAlign,
          maxLines: 1,
          textDirection: textDirection,
        );
      },
    );
  }

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: style,
      ),
      maxLines: 1,
      textDirection: textDirection,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}

extension AppStringExtension on String {
  String get fixOverflowEllipsis => Characters(this)
      .replaceAll(Characters(''), Characters('\u{200B}'))
      .toString();
}
