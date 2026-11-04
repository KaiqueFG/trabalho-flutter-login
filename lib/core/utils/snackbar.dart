import 'package:flutter/material.dart';

extension SnackBarX on BuildContext {
  void showSnack(String message, {bool isError = false}) {
    final scheme = Theme.of(this).colorScheme;
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: isError ? TextStyle(color: scheme.onError) : null,
          ),
          backgroundColor: isError ? scheme.error : null,
        ),
      );
  }
}
