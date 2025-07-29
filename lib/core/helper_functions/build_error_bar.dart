import 'package:flutter/material.dart';

void buildErrorBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(child: Text(message)),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    ),
  );
}
