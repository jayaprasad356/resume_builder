import 'package:flutter/material.dart';
import 'package:flutter_cvmaker/config.dart';

//Button Primary
ButtonStyle buttonPrimaryStyle = TextButton.styleFrom(
  primary: Colors.white, backgroundColor: primaryColor,
  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
);

//Button Default
ButtonStyle buttonStyle = TextButton.styleFrom(
  primary: itemColor, backgroundColor: itemColor,
  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
);

//Button Default
ButtonStyle confirmButtonStyle = TextButton.styleFrom(
  primary: Colors.white, backgroundColor: primaryColor,
  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
);

ButtonStyle buttonStyleAccent = TextButton.styleFrom(
  primary: primaryColor,
  backgroundColor: accentColor,
  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
);

ButtonStyle buttonStyleDefault = TextButton.styleFrom(
  primary: blackSecondary,
  backgroundColor: backgroundColor,
  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
);

ButtonStyle buttonStyleDefaultActive = TextButton.styleFrom(
  primary: blackSecondary,
  backgroundColor: blackActive,
  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
);

ButtonStyle buttonDisableStyle = TextButton.styleFrom(
  primary: Colors.grey.shade400, backgroundColor: Colors.grey.shade100,
  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
);

Widget buttonRow(
    {required String text,
    IconData? icon,
    double fontSize = 13,
    double iconSize = 24}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      if (icon != null)
        Icon(
          icon,
          color: Colors.black38,
          size: iconSize,
        ),
      Text(
        ' ' + text + ' ',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: fontSize),
      ),
    ],
  );
}

Widget buttonCol(
    {required String text,
    IconData? icon,
    double fontSize = 12,
    double iconSize = 24}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      if (icon != null)
        Icon(
          icon,
          color: buttonText,
          size: iconSize,
        ),
      Container(
        margin: const EdgeInsets.only(top: 5),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: fontSize, color: buttonText),
        ),
      ),
    ],
  );
}

EdgeInsetsGeometry buttonMargin =
    const EdgeInsets.only(left: 2, right: 2, top: 1, bottom: 1);

//Button Action Bar
ButtonStyle actionButtonStyle =
    TextButton.styleFrom(primary: accentColor, backgroundColor: Colors.black);
ButtonStyle actionButtonDisableStyle = TextButton.styleFrom(
    primary: Colors.white30, backgroundColor: Colors.black45);
EdgeInsetsGeometry actionButtonMargin = const EdgeInsets.all(4);

//Form
EdgeInsetsGeometry inputTextStyle =
    const EdgeInsets.symmetric(horizontal: 10, vertical: 10);

//Bottom Modal
RoundedRectangleBorder modalTopBorder = const RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
      topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
);
Color modalBgColor = Colors.white;
Color modalBarrierColorOverlay = Colors.black45;
Color modalBarrierColorNone = Colors.transparent;
