import 'dart:math';

import 'package:flutter/material.dart';
import 'package:videochatapp/utils/universal_variables.dart';

class CustomTile extends StatelessWidget {
  const CustomTile(
      {Key? key,
      required this.leading,
      required this.title,
      this.icon,
      required this.subtitle,
      this.trailing,
      this.margin = const EdgeInsets.all(0.0),
      this.mini = true,
      this.onTap,
      this.onLongPress})
      : super(key: key);
  final Widget leading;
  final Widget title;
  final Widget? icon;
  final Widget subtitle;
  final Widget? trailing;
  final EdgeInsets margin;
  final bool mini;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.only(left: mini ? 10 : 15),
        padding: EdgeInsets.symmetric(vertical: mini ? 3.0 : 20.0),
        decoration: BoxDecoration(
          border: Border(
            bottom:
                BorderSide(width: 1, color: UniversalVariables.separatorColor),
          ),
        ),
        child: Row(
          children: [
            leading,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title,
                SizedBox(height: 5),
                Row(
                  children: [
                    icon ?? Container(),
                    subtitle,
                  ],
                )
              ],
            ),
            trailing ?? Container(),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ),
    );
  }
}
