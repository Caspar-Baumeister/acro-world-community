import 'package:flutter/material.dart';

// ignore: constant_identifier_names
const String MORTY_IMG_URL =
    "https://store.playstation.com/store/api/chihiro/00_09_000/container/AR/es/99/UP0151-CUSA09971_00-AV00000000000004/0/image?_version=00_09_000&platform=chihiro&bg_color=000000&opacity=100&w=720&h=720";

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  contentPadding: EdgeInsets.all(12.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.pink, width: 2.0),
  ),
);
