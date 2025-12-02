import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Logger
void printLog(dynamic msg, {String fun = ""}) {
  _printLog(' $fun=> ${msg.toString()}');
}

void functionLog({required dynamic msg, required dynamic fun}) {
  _printLog("${fun.toString()} ::==> ${msg.toString()}");
}

void _printLog(dynamic msg, {String name = "Riverpod"}) {
  if (kDebugMode) {
    log(msg.toString(), name: name);
  }
}

// Spacer
SizedBox yHeight(double height) {
  return SizedBox(height: height);
}

SizedBox xWidth(double width) {
  return SizedBox(width: width);
}
