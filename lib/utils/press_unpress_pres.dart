import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'my_text.dart';

class PressUnpressPres extends StatefulWidget {
  final double height;
  final double width;
  final Widget child;
  final String image;
  final Function onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const PressUnpressPres(
      {required this.height,
      required this.width,
      required this.child,
      required this.image,
      required this.onTap,
      this.margin,
      this.padding, });

  @override
  State<PressUnpressPres> createState() => _PressUnpressPresState();
}

class _PressUnpressPresState extends State<PressUnpressPres> {
  bool isPress = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapCancel: () {
        setState(() {
          isPress = false;
        });
      },
      onTapDown: (d) {
        setState(() {
          isPress = true;
        });
      },
      onTapUp: (ui) {
        setState(() {
          isPress = false;
        });
      },
      onTap: () {

          widget.onTap();

      },
      child: Opacity(
        opacity: isPress ? 0.5 : 1,
        child: Container(
          height: widget.height,
          width: widget.width,
          margin: widget.margin,
          padding: widget.padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
                image: AssetImage(widget.image), fit: BoxFit.fill),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

