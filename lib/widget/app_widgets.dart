import 'package:bachelor_room/utils/colors.dart';
import 'package:flutter/material.dart';

class CIconButton extends StatelessWidget {
  final IconData icon;
  final Color buttonColor;
  final Color iconColor;
  final double size;
  final VoidCallback onpressed;

  const CIconButton(
    this.icon,
    this.buttonColor,
    this.iconColor,
    this.size,
    this.onpressed,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      child: Card(
        margin: const EdgeInsets.all(8),
        color: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MConstants.descBorRad),
        ),
        child: IconButton(
          color: iconColor,
          iconSize: 21,
          icon: Icon(icon),
          onPressed: onpressed,
        ),
      ),
    );
  }
}

///why i stopped using plain functions like this iconBtn,
///https://stackoverflow.com/questions/53234825/what-is-the-difference-between-functions-and-classes-to-create-reusable-widgets
/// and its not suitable for reusable widgets.
/// explaination : plain functions rebuild every time state changes like setstate, getbuilder
/// but classes like statelesswidgets only rebuild if anything changed inside ite build.

class CWideElevatedBtn extends StatelessWidget {
  final String title;
  final double width;
  final EdgeInsetsGeometry margin;
  final TextStyle textStyle;
  final Color btnColor;
  final double hPadding;
  final double vPadding;
  final VoidCallback onpressed;
  const CWideElevatedBtn(
    this.title,
    this.width,
    this.margin,
    this.textStyle,
    this.btnColor,
    this.hPadding,
    this.vPadding,
    this.onpressed,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      child: ElevatedButton(
        child: Text(
          title,
          style: textStyle,
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            btnColor,
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                MConstants.descBorRad,
              ),
            ),
          ),
          padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(
              horizontal: hPadding,
              vertical: vPadding,
            ),
          ),
        ),
        onPressed: onpressed,
      ),
    );
  }
}

class CElevatedBtn extends StatelessWidget {
  final String title;
  final double hPadding;
  final double vPadding;
  final TextStyle textStyle;
  final Color btnColor;
  final VoidCallback onpressed;
  const CElevatedBtn(
    this.title,
    this.hPadding,
    this.vPadding,
    this.textStyle,
    this.btnColor,
    this.onpressed,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        child: Text(
          title,
          style: textStyle,
        ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(
            btnColor,
          ),
          padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(
              horizontal: hPadding,
              vertical: vPadding,
            ),
          ),
        ),
        onPressed: onpressed,
      ),
    );
  }
}
