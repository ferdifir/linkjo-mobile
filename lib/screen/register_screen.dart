import 'package:flutter/material.dart';
import 'package:linkjo/core/routes.dart';
import 'package:linkjo/service/api_service.dart';
import 'package:linkjo/service/location_service.dart';
import 'package:linkjo/utils/helper.dart';
import 'package:linkjo/utils/log.dart';
import 'package:linkjo/widget/app_button.dart';
import 'package:linkjo/widget/app_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _outletController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ApiService _api = ApiService();
  double _latitude = -6.2088;
  double _longitude = 106.8456;
  String _city = '';
  bool _isLoading = false;

  void _showLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  void _registerTenant() async {
    final Map<String, dynamic> data = {
      'owner_name': _nameController.text,
      'outlet_name': _outletController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
      'phone': _phoneController.text,
      'address': _addressController.text,
      'city': _city,
      'latitude': _latitude,
      'longitude': _longitude,
      'is_active': true,
    };
    _showLoading(true);
    final response = await _api.post('/auth/register', data);
    _showLoading(false);
    if (response.success) {
      Helper.showSnackBar(context, 'Register success!');
      Navigator.pop(context);
    } else {
      Helper.showSnackBar(context, response.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150, // Beri batasan tinggi agar tidak terlalu besar
                    child: Hero(
                      tag: 'logo',
                      child: Image.asset(
                        'assets/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Register',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 16),
                  AppTextfield(
                    readOnly: _isLoading,
                    controller: _nameController,
                    prefix: const Icon(Icons.person),
                    hintText: 'Name',
                  ),
                  const SizedBox(height: 16),
                  AppTextfield(
                    readOnly: _isLoading,
                    controller: _outletController,
                    prefix: const Icon(Icons.store),
                    hintText: 'Outlet',
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
                    controller: _phoneController,
                    prefix: const Icon(Icons.phone),
                    hintText: 'Phone',
                  ),
                  const SizedBox(height: 16),
                  AppTextfield(
                    controller: _addressController,
                    prefix: const Icon(Icons.location_on),
                    readOnly: true,
                    hintText: 'Address',
                    suffix: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.map),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              Routes.locationPicker,
                            ).then((value) {
                              if (value != null) {
                                var data = value as Map<String, dynamic>;
                                _latitude = data['latitude'];
                                _longitude = data['longitude'];
                                _city = data['city'];
                                _addressController.text = data['address'];
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.my_location),
                          onPressed: () async {
                            _addressController.text = 'Mendapatkan Lokasi';
                            var position =
                                await LocationService.getCurrentLocation();
                            var address =
                                await LocationService.getAddressFromLocation(
                              position.latitude,
                              position.longitude,
                            );
                            Log.d(address);
                            if (address != null) {
                              setState(() {
                                _latitude = position.latitude;
                                _longitude = position.longitude;
                                _city = address['address']['county'];
                                _addressController.text =
                                    address['display_name'];
                              });
                            } else {
                              _addressController.text = '';
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppTextfield(
                    readOnly: _isLoading,
                    controller: _passwordController,
                    prefix: const Icon(Icons.lock),
                    obscureText: true,
                    hintText: 'Password',
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _registerTenant();
                      }
                    },
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                            'Register',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  color: Colors.white,
                                ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
