import 'dart:ui';

// Ex. 0xFF8D6E63, FF8D6E63, 8D6E63
colorToHexString(Color? color) {
  if (color != null) {
    String str = color.value.toRadixString(16);
    str = str.replaceAll('0x', '');
    if (str.length == 6) {
      return 'FF' + str;
    }
    return '#' + str;
  } else {
    return null;
  }
  //return '#FF${color.value.toRadixString(16).substring(2, 8)}';
}

// Ex. #FF8D6E63
hexStringToColor(String? hexColor) {
  if (hexColor != null) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    hexColor = '0x' + hexColor;
    return Color(int.parse(hexColor));
  } else {
    return null;
  }
}

//String hexCode = colorToHexString(Colors.green);
//Color bgColor = hexStringToColor(hexCode);
//print("$hexCode = $bgColor");