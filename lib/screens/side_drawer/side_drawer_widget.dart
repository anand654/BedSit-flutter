import 'package:bachelor_room/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CSideDrawerTile extends StatelessWidget {
  final String title;
  final Widget icon;
  final VoidCallback ontap;
  const CSideDrawerTile(
    this.title,
    this.icon,
    this.ontap,
  );

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: MTextStyle.darkTitleText,
      ),
      dense: true,
      onTap: ontap,
    );
  }
}
