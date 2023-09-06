import 'package:flutter/material.dart';

Widget modalSearch(
    {required TextEditingController textEditingController,
    required String hintText,
    required Function onChanged}) {
  return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        fillColor: Colors.grey.shade100,
        filled: true,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        hintText: hintText,
      ),
      onChanged: (text) {
        onChanged(text);
      });
}

//Panel
Widget panelWidget(
    {required String title, required double height, required Widget child}) {
  return Positioned(
    left: 0,
    right: 0,
    bottom: 0,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: height,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
          boxShadow: height > 0
              ? const [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 10,
                    blurRadius: 20,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ]
              : null,
        ),

        //width: MediaQuery.of(context).size.width,
        //height: 60,
        alignment: Alignment.center,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    ),
  );
}
