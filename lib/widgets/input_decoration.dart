import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

InputDecoration buildInputDecoration({
  @required String labelText,
  @required String hintText,
}) {
  return InputDecoration(
    fillColor: Colors.white,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: Colors.blue),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: HexColor('#69639F')),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: const BorderSide(color: Colors.redAccent),
    ),
    focusedErrorBorder:  OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: const BorderSide(color: Colors.redAccent),
    ),
    labelText: labelText,
    hintText: hintText,
  );
}
