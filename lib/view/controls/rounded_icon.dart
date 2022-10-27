import 'package:flutter/material.dart';

/*
  This class use for [LeftDrawer]
  Display in the left of each item.
*/
class RoundedIcon extends StatelessWidget {
  const RoundedIcon({
    super.key,
    required this.iconData,
    required this.color,
    this.iconColor = Colors.white,
  });

  ///This icon displays at the center of Circle
  final IconData iconData;

  ///Background color of circle
  final Color color;

  ///Color of icon
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 35,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 20,
      ),
    );
  }
}
