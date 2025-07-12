import 'package:flutter/material.dart';



class PressUnpress extends StatefulWidget {
  final double height;
  final double width;
  final Widget child;
  final String image;
  final Function onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  PressUnpress(
      {required this.height,
      required this.width,
      required this.child,
      required this.image,
      required this.onTap,
      this.margin,
      this.padding, });

  @override
  State<PressUnpress> createState() => _PressUnpressState();
}

class _PressUnpressState extends State<PressUnpress> {
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
                image: AssetImage(widget.image),
              )),
          child: widget.child,
        ),
      ),
    );
  }
}

class PressUnpressSetting extends StatefulWidget {
  final double height;
  final double width;
  final Widget child;
  final String image;
  final Function onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;


  PressUnpressSetting(
      {required this.height,
        required this.width,
        required this.child,
        required this.image,
        required this.onTap,
        this.margin,
        this.padding,});

  @override
  State<PressUnpressSetting> createState() => _PressUnpressSettingState();
}

class _PressUnpressSettingState extends State<PressUnpressSetting> {
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
                image: AssetImage(widget.image),
              )),
          child: widget.child,
        ),
      ),
    );
  }
}
