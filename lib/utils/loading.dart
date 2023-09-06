import 'package:flutter/material.dart';
import 'package:flutter_cvmaker/config.dart';

Widget showLoading({String text = 'Loading..'}) {
  return Container(
      color: Colors.black54,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
              strokeWidth: 2.0,
              backgroundColor: primaryColor,
              color: accentColor),
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ));
}
