import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  const ImageButton({
    Key? key,
    required this.imgStrRes,
    this.imgHeight,
    this.imgWidth,
    this.onTap,
    this.alignment = Alignment.center,
    this.padding = EdgeInsets.zero,
    this.isInk = true,
    this.width,
    this.height,
    this.package,
  }) : super(key: key);
  final Function()? onTap;
  final double? imgWidth;
  final double? imgHeight;
  final String imgStrRes;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry padding;
  final bool isInk;
  final double? width;
  final double? height;
  final String? package;

  @override
  Widget build(BuildContext context) {
    return isInk
        ? Material(
            type: MaterialType.transparency,
            child: Ink(
              width: width,
              height: height,
              child: InkWell(
                onTap: onTap,
                child: Container(
                  margin: padding,
                  width: imgWidth,
                  height: imgHeight,
                  child: Ink.image(
                    alignment: alignment,
                    image: AssetImage(imgStrRes, package: package),
                  ),
                ),
              ),
            ),
          )
        : GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onTap,
            child: Container(
              margin: padding,
              child: Image.asset(
                imgStrRes,
                width: imgWidth,
                height: imgHeight,
                alignment: alignment,
                package: package,
              ),
            ),
          );
  }
}
