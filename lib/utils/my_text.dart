import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final int width;
  final int maxline;
  final TextAlign? align;

  MyText(
      {required this.text,
      required this.fontSize,
        required this.fontWeight,
      required this.textColor,
      required this.width,
      required this.maxline,
      this.align});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: maxline,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
        textAlign: align,
      ),
    );
  }
}

class CustomGradientText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final double width;

  CustomGradientText({
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    required this.width
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [Color(0xFFFF4852), Color(0xFFFDD70E)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Container(
        width: width,
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: TextStyle(
            color:
            Colors.white, // fallback color in case gradient doesn't apply
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
