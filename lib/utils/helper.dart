import 'package:flutter/material.dart';
import 'package:linkjo/core/routes.dart';

class Helper {
  static String thousandSeparator(int value) {
    return value.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    SnackBar snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(
        bottom: 20,
        left: 20,
        right: 20,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      snackBar,
    );
  }

  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  static void logoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) {
            Navigator.pushReplacementNamed(
              context,
              Routes.login,
            );
          }
        },
        child: AlertDialog(
          title: const Text('Sesi Habis!'),
          content: const Text('Silahkan login kembali'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(
                context,
                Routes.login,
              ),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
