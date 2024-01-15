import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;

  final String? Function(String?)? validator;
  final bool isPassword;
  final Function(String)? onChanged;
  final TextEditingController controller;

  const CustomTextField({
    Key? key,
    required this.label,
    this.isPassword = false,
    required this.validator,
    required this.onChanged,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        
        controller: controller,
        onChanged: onChanged,
        obscureText: isPassword,
        validator: validator,
        decoration: InputDecoration(

          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
