import 'package:flutter/material.dart';
import 'package:flutter_cvmaker/models/colors_model.dart';

Icon getIcon(
    {required Color color,
    bool isOutline = false,
    bool isNone = false,
    bool isPicker = false,
    double size = 36}) {
  return Icon(
      isPicker
          ? Icons.palette_outlined
          : isNone
              ? Icons.cancel_outlined
              : isOutline
                  ? Icons.circle_outlined
                  : Icons.circle,
      color: isNone
          ? Colors.black54
          : isOutline || isPicker
              ? Colors.black38
              : color,
      size: size);
}

// List<Color> colorListX = [
//   const Color(0xFFDCDCDC),
//   const Color(0xFFD3D3D3),
//   const Color(0xFFC0C0C0),
//   const Color(0xFFA9A9A9),
//   const Color(0xFF808080),
//   const Color(0xFF696969),
//   const Color(0xFF000000),
//   const Color(0xFFFFE4E1),
//   const Color(0xFFF08080),
//   const Color(0xFFFA8072),
//   const Color(0xFFBC8F8F),
//   const Color(0xFFFF6347),
//   const Color(0xFFCD5C5C),
//   const Color(0xFFFF0000),
//   const Color(0xFFB22222),
//   const Color(0xFFA52A2A),
//   const Color(0xFF8B0000),
//   const Color(0xFF800000),
//   const Color(0xFFFFF5EE),
//   const Color(0xFFFFDAB9),
//   const Color(0xFFFFA07A),
//   const Color(0xFFE9967A),
//   const Color(0xFFF4A460),
//   const Color(0xFFFF7F50),
//   const Color(0xFFCD853F),
//   const Color(0xFFFF4500),
//   const Color(0xFFD2691E),
//   const Color(0xFFA0522D),
//   const Color(0xFF8B4513),
//   const Color(0xFFFFFAFA),
//   const Color(0xFFFFFAF0),
//   const Color(0xFFFDF5E6),
//   const Color(0xFFFAF0E6),
//   const Color(0xFFFFEFD5),
//   const Color(0xFFFAEBD7),
//   const Color(0xFFFFEBCD),
//   const Color(0xFFFFE4C4),
//   const Color(0xFFFFE4B5),
//   const Color(0xFFFFDEAD),
//   const Color(0xFFF5DEB3),
//   const Color(0xFFDEB887),
//   const Color(0xFFD2B48C),
//   const Color(0xFFFF8C00),
//   const Color(0xFFFFA500),
//   const Color(0xFFDAA520),
//   const Color(0xFFB8860B),
//   const Color(0xFFFFF8DC),
//   const Color(0xFFFFFACD),
//   const Color(0xFFEEE8AA),
//   const Color(0xFFF0E68C),
//   const Color(0xFFBDB76B),
//   const Color(0xFFFFD700),
//   const Color(0xFFFFFFF0),
//   const Color(0xFFFFFFE0),
//   const Color(0xFFF5F5DC),
//   const Color(0xFFFAFAD2),
//   const Color(0xFFFFFF00),
//   const Color(0xFF808000),
//   const Color(0xFFADFF2F),
//   const Color(0xFF9ACD32),
//   const Color(0xFF6B8E23),
//   const Color(0xFF556B2F),
//   const Color(0xFF7FFF00),
//   const Color(0xFF7CFC00),
//   const Color(0xFFF0FFF0),
//   const Color(0xFF98FB98),
//   const Color(0xFF90EE90),
//   const Color(0xFF8FBC8F),
//   const Color(0xFF00FF00),
//   const Color(0xFF00FF00),
//   const Color(0xFF228B22),
//   const Color(0xFF008000),
//   const Color(0xFF006400),
//   const Color(0xFF00FF7F),
//   const Color(0xFF3CB371),
//   const Color(0xFF2E8B57),
//   const Color(0xFFF5FFFA),
//   const Color(0xFF7FFFD4),
//   const Color(0xFF66CDAA),
//   const Color(0xFF00FA9A),
//   const Color(0xFF40E0D0),
//   const Color(0xFF48D1CC),
//   const Color(0xFF20B2AA),
//   const Color(0xFFF0FFFF),
//   const Color(0xFFE0FFFF),
//   const Color(0xFFAFEEEE),
//   const Color(0xFFB0E0E6),
//   const Color(0xFFADD8E6),
//   const Color(0xFF00FFFF),
//   const Color(0xFF5F9EA0),
//   const Color(0xFF00CED1),
//   const Color(0xFF008B8B),
//   const Color(0xFF008080),
//   const Color(0xFF2F4F4F),
//   const Color(0xFFF0F8FF),
//   const Color(0xFF87CEFA),
//   const Color(0xFF87CEEB),
//   const Color(0xFF1E90FF),
//   const Color(0xFF00BFFF),
//   const Color(0xFF4682B4),
//   const Color(0xFFB0C4DE),
//   const Color(0xFF6495ED),
//   const Color(0xFF4169E1),
//   const Color(0xFF778899),
//   const Color(0xFF708090),
//   const Color(0xFFE6E6FA),
//   const Color(0xFF7B68EE),
//   const Color(0xFF6A5ACD),
//   const Color(0xFF0000FF),
//   const Color(0xFF0000CD),
//   const Color(0xFF483D8B),
//   const Color(0xFF00008B),
//   const Color(0xFF191970),
//   const Color(0xFF000080),
//   const Color(0xFF9370DB),
//   const Color(0xFFF8F8FF),
//   const Color(0xFF8A2BE2),
//   const Color(0xFF9932CC),
//   const Color(0xFF9400D3),
//   const Color(0xFF4B0082),
//   const Color(0xFFBA55D3),
//   const Color(0xFFD8BFD8),
//   const Color(0xFFDDA0DD),
//   const Color(0xFFEE82EE),
//   const Color(0xFFDA70D6),
//   const Color(0xFFFF00FF),
//   const Color(0xFF8B008B),
//   const Color(0xFF800080),
//   const Color(0xFFFF1493),
//   const Color(0xFFC71585),
//   const Color(0xFFFFC0CB),
//   const Color(0xFFFFB6C1),
//   const Color(0xFFDC143C),
//   const Color(0xFFFFF0F5),
//   const Color(0xFFFF69B4),
//   const Color(0xFFDB7093)
// ];

List<Color> colorList = [
  const Color(0xFFF5F5F5),
  const Color(0xFFD3D3D3),
  const Color(0xFFA9A9A9),
  const Color(0xFF808080),
  const Color(0xFFE53935),
  const Color(0xFFF44336),
  const Color(0xFFEF5350),
  const Color(0xFFD81B60),
  const Color(0xFFE91E63),
  const Color(0xFFEC407A),
  const Color(0xFF8E24AA),
  const Color(0xFF9C27B0),
  const Color(0xFFAB47BC),
  const Color(0xFF5E35B1),
  const Color(0xFF673AB7),
  const Color(0xFF7E57C2),
  const Color(0xFF3949AB),
  const Color(0xFF3F51B5),
  const Color(0xFF5C6BC0),
  const Color(0xFF1E88E5),
  const Color(0xFF2196F3),
  const Color(0xFF42A5F5),
  const Color(0xFF039BE5),
  const Color(0xFF03A9F4),
  const Color(0xFF29B6F6),
  const Color(0xFF00ACC1),
  const Color(0xFF00BCD4),
  const Color(0xFF26C6DA),
  const Color(0xFF00897B),
  const Color(0xFF009688),
  const Color(0xFF26A69A),
  const Color(0xFF43A047),
  const Color(0xFF4CAF50),
  const Color(0xFF66BB6A),
  const Color(0xFF7CB342),
  const Color(0xFF8BC34A),
  const Color(0xFF9CCC65),
  const Color(0xFFC0CA33),
  const Color(0xFFCDDC39),
  const Color(0xFFD4E157),
  const Color(0xFFFDD835),
  const Color(0xFFFFEB3B),
  const Color(0xFFFFEE58),
  const Color(0xFFFFB300),
  const Color(0xFFFFC107),
  const Color(0xFFFFCA28),
  const Color(0xFFFB8C00),
  const Color(0xFFFF9800),
  const Color(0xFFFFA726),
  const Color(0xFFF4511E),
  const Color(0xFFFF5722),
  const Color(0xFFFF7043),
  const Color(0xFF6D4C41),
  const Color(0xFF795548),
  const Color(0xFF8D6E63),
  const Color(0xFF757575),
  const Color(0xFF9E9E9E),
  const Color(0xFFBDBDBD),
  const Color(0xFF546E7A),
  const Color(0xFF607D8B),
  const Color(0xFF78909C),
];

List<Color> colorMainList = [
  const Color(0xFFF5F5F5),
  const Color(0xFF808080),
  const Color(0xFF000000),
  const Color(0xFFE53935),
  const Color(0xFFD81B60),
  const Color(0xFF8E24AA),
  const Color(0xFF5E35B1),
  const Color(0xFF3949AB),
  const Color(0xFF1E88E5),
  const Color(0xFF039BE5),
  const Color(0xFF00ACC1),
  const Color(0xFF00897B),
  const Color(0xFF43A047),
  const Color(0xFF7CB342),
  const Color(0xFFC0CA33),
  const Color(0xFFFDD835),
  const Color(0xFFFFB300),
  const Color(0xFFFB8C00),
  const Color(0xFFF4511E),
  const Color(0xFF6D4C41),
  const Color(0xFF757575),
  const Color(0xFF546E7A),
];

List<ColorsModel> getMaterialColors({bool isNotShowNone = false}) {
  List<ColorsModel> list = [];

  if (!isNotShowNone) {
    list.add(ColorsModel(
        color: Colors.transparent,
        icon: getIcon(
            color: Colors.transparent.withOpacity(0),
            isOutline: true,
            isNone: true),
        isNone: true));
  }

  list.add(ColorsModel(
      color: Colors.transparent,
      icon: getIcon(color: Colors.transparent, isPicker: true),
      isPicker: true));

  list.add(ColorsModel(
      color: const Color(0xFFFFFFFF),
      icon: getIcon(color: const Color(0xFFFFFFFF), isOutline: true)));

  list.add(ColorsModel(
      color: const Color(0xFF000000),
      icon: getIcon(color: const Color(0xFF000000))));

  for (var color in colorList) {
    list.add(ColorsModel(color: color, icon: getIcon(color: color)));
  }

  return list;
}

//Colors Material
// List<ColorsModel> getMaterialColors() {
//   List<ColorsModel> list = [];

//   list.add(ColorsModel(
//       name: ColorNames.none,
//       icon: const Icon(Icons.cancel_outlined, size: 24)));

//   list.add(ColorsModel(
//       name: ColorNames.red,
//       icon: const Icon(Icons.circle, color: Colors.red, size: 24)));

//   list.add(ColorsModel(
//       name: ColorNames.pink,
//       icon: const Icon(Icons.circle, color: Colors.pink, size: 24)));

//   list.add(ColorsModel(
//       name: ColorNames.purple,
//       icon: const Icon(Icons.circle, color: Colors.purple, size: 24)));

//   list.add(ColorsModel(
//       name: ColorNames.deepPurple,
//       icon: const Icon(Icons.circle, color: Colors.deepPurple, size: 24)));

//   list.add(ColorsModel(
//       name: ColorNames.indigo,
//       icon: const Icon(Icons.circle, color: Colors.indigo, size: 24)));

//   list.add(ColorsModel(
//       name: ColorNames.blue,
//       icon: const Icon(Icons.circle, color: Colors.blue, size: 24)));

//   list.add(ColorsModel(
//       name: ColorNames.lightBlue,
//       icon: const Icon(Icons.circle, color: Colors.lightBlue, size: 24)));

//   list.add(ColorsModel(
//       name: ColorNames.cyan,
//       icon: const Icon(Icons.circle, color: Colors.cyan, size: 24)));

//   list.add(ColorsModel(
//       name: ColorNames.teal,
//       icon: const Icon(Icons.circle, color: Colors.teal, size: 24)));

//   list.add(ColorsModel(
//       name: ColorNames.green,
//       icon: const Icon(Icons.circle, color: Colors.green, size: 24)));

//   list.add(ColorsModel(
//       name: ColorNames.lightGreen,
//       icon: const Icon(Icons.circle, color: Colors.lightGreen, size: 24)));

//   list.add(ColorsModel(
//       name: ColorNames.lime,
//       icon: const Icon(Icons.circle, color: Colors.lime, size: 24)));

//   list.add(ColorsModel(
//       name: ColorNames.yellow,
//       icon: const Icon(Icons.circle, color: Colors.yellow, size: 24)));

//   list.add(ColorsModel(
//       name: ColorNames.amber,
//       icon: const Icon(Icons.circle, color: Colors.amber, size: 24)));

//   list.add(ColorsModel(
//       name: ColorNames.orange,
//       icon: const Icon(Icons.circle, color: Colors.orange, size: 24)));

//   list.add(ColorsModel(
//       name: ColorNames.deepOrange,
//       icon: const Icon(Icons.circle, color: Colors.deepOrange, size: 24)));

//   list.add(ColorsModel(
//       name: ColorNames.brown,
//       icon: const Icon(Icons.circle, color: Colors.brown, size: 24)));

//   list.add(ColorsModel(
//       name: ColorNames.grey,
//       icon: const Icon(Icons.circle, color: Colors.grey, size: 24)));

//   list.add(ColorsModel(
//       name: ColorNames.blueGrey,
//       icon: const Icon(Icons.circle, color: Colors.blueGrey, size: 24)));

//   list.add(ColorsModel(
//       name: ColorNames.black,
//       icon: const Icon(Icons.circle, color: Colors.black, size: 24)));

//   list.add(ColorsModel(
//       name: ColorNames.white,
//       icon:
//           const Icon(Icons.circle_outlined, color: Colors.black12, size: 24)));
//   return list;
// }
