import 'package:flutter/material.dart';
import 'package:linkjo/core/routes.dart';
import 'package:linkjo/service/api_service.dart';
import 'package:linkjo/service/hive_service.dart';
import 'package:linkjo/utils/helper.dart';
import 'package:linkjo/utils/hive_key.dart';
import 'package:linkjo/utils/log.dart';
import 'package:linkjo/widget/app_button.dart';
import 'package:linkjo/widget/app_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final _api = ApiService();

  void _showLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  void _loginTenant() async {
    final Map<String, dynamic> data = {
      'email': _emailController.text,
      'password': _passwordController.text,
    };
    _showLoading(true);
    final response = await _api.post('/auth/login', data);
    _showLoading(false);
    Log.d(response.data);
    if (response.success) {
      Helper.showSnackBar(context, 'Login success!');
      HiveService.putData(HiveKey.token, response.data);
      Navigator.pushReplacementNamed(
        context,
        Routes.dashboard,
      );
    } else {
      Helper.showSnackBar(context, response.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Hero(
                tag: 'logo',
                child: Image.asset(
                  'assets/logo.png',
                ),
              ),
            ),
            Text(
              'Login',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            AppTextfield(
              readOnly: _isLoading,
              controller: _emailController,
              prefix: const Icon(Icons.email),
              hintText: 'Email',
            ),
            const SizedBox(height: 16),
            AppTextfield(
              readOnly: _isLoading,
              controller: _passwordController,
              prefix: const Icon(Icons.lock),
              hintText: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 16),
            AppButton(
              onPressed: _loginTenant,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                      'Login',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Colors.white,
                          ),
                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don\'t have an account?'),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      Routes.register,
                    );
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
