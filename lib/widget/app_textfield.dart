import 'package:flutter/material.dart';

class AppTextfield extends StatefulWidget {
  const AppTextfield({
    super.key,
    required this.controller,
    this.prefix,
    this.suffix,
    this.hintText,
    this.readOnly = false,
    this.obscureText = false,
    this.keyboardType,
  });

  final TextEditingController controller;
  final Widget? prefix;
  final Widget? suffix;
  final String? hintText;
  final bool readOnly;
  final bool obscureText;
  final TextInputType? keyboardType;

  @override
  State<AppTextfield> createState() => _AppTextfieldState();
}

class _AppTextfieldState extends State<AppTextfield> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.obscureText,
      readOnly: widget.readOnly,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        prefixIcon: widget.prefix,
        hintText: widget.hintText,
        suffixIcon: widget.suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
