import 'package:flutter/material.dart';
import 'package:linkjo/core/routes.dart';
import 'package:linkjo/service/hive_service.dart';
import 'package:linkjo/utils/hive_key.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      String token = HiveService.getData(HiveKey.token, defaultValue: '');
      Navigator.pushReplacementNamed(
        context,
        token.isEmpty ? Routes.login : Routes.dashboard,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: 'logo',
          child: Image.asset(
            'assets/logo.png',
          ),
        ),
      ),
    );
  }
}
