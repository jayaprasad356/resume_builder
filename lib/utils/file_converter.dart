import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

convertFileToBase64(File? fileImage) {
  if (fileImage != null) {
    List<int> imageBytes = fileImage.readAsBytesSync();
    String imageB64 = base64Encode(imageBytes);
    return imageB64;
  } else {
    return null;
  }
}

convertBase64ToFile(String? base64Image) {
  if (base64Image != null) {
    final decodedBytes = base64Decode(base64Image);
    return Image.memory(
      decodedBytes,
      gaplessPlayback: true,
    );
    ;
  } else {
    return null;
  }
}
