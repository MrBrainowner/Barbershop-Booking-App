import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String labelText;
  final bool obscureText;
  final Widget? icon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardtype;
  final int? maxLines;

  const MyTextField({
    super.key,
    required this.labelText,
    required this.obscureText,
    required this.icon,
    this.controller,
    this.validator,
    this.keyboardtype,
    this.maxLines = 1,
    this.suffixIcon,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardtype,
      validator: widget.validator,
      controller: widget.controller,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        suffixIcon: widget.suffixIcon,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        labelText: widget.labelText,
        errorStyle: TextStyle(color: Colors.red.shade500),
        prefixIcon: widget.icon,
        prefixIconColor: Theme.of(context).primaryColor,
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade500)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor)),
        border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: Theme.of(context).primaryColor)),
      ),
    );
  }
}
