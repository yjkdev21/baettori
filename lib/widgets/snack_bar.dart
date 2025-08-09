import 'package:baettori/utils/style.dart';
import 'package:flutter/material.dart';

const _duration = Duration(milliseconds: 800);

void snackBarNormal(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: _duration,
    ),
  );
}

void snackBarColor(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: _duration,
      backgroundColor: mainBlue,
    ),
  );
}

void snackBaError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: _duration,
      backgroundColor: errColor,
    ),
  );
}
