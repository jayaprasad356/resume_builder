import 'package:flutter/material.dart';

class ColorsModel {
  Color color;
  Icon icon;
  bool isActive = false;
  bool isNone = false;
  bool isPicker = false;

  ColorsModel({
    required this.color,
    required this.icon,
    this.isActive = false,
    this.isNone = false,
    this.isPicker = false,
  });
} 

// enum ColorNames {
//   none,
//   red,
//   pink,
//   purple,
//   deepPurple,
//   indigo,
//   blue,
//   lightBlue,
//   cyan,
//   teal,
//   green,
//   lightGreen,
//   lime,
//   yellow,
//   amber,
//   orange,
//   deepOrange,
//   brown,
//   grey,
//   blueGrey,
//   black,
//   white
// }

// Color getColorByName(ColorNames colorNames) {
//   switch (colorNames) {
//     case ColorNames.red:
//       return Colors.red;
//     case ColorNames.pink:
//       return Colors.pink;
//     case ColorNames.purple:
//       return Colors.purple;
//     case ColorNames.deepPurple:
//       return Colors.deepPurple;
//     case ColorNames.indigo:
//       return Colors.indigo;
//     case ColorNames.blue:
//       return Colors.blue;
//     case ColorNames.lightBlue:
//       return Colors.lightBlue;
//     case ColorNames.cyan:
//       return Colors.cyan;
//     case ColorNames.teal:
//       return Colors.teal;
//     case ColorNames.green:
//       return Colors.green;
//     case ColorNames.lightGreen:
//       return Colors.lightGreen;
//     case ColorNames.lime:
//       return Colors.lime;
//     case ColorNames.yellow:
//       return Colors.yellow;
//     case ColorNames.amber:
//       return Colors.amber;
//     case ColorNames.orange:
//       return Colors.orange;
//     case ColorNames.deepOrange:
//       return Colors.deepOrange;
//     case ColorNames.brown:
//       return Colors.brown;
//     case ColorNames.grey:
//       return Colors.grey;
//     case ColorNames.blueGrey:
//       return Colors.blueGrey;
//     case ColorNames.white:
//       return Colors.white;
//     case ColorNames.black:
//       return Colors.black;
//     default:
//       return Colors.transparent;
//   }
// }
