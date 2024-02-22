import 'package:flutter/material.dart';

class RoudedRectangle extends StatelessWidget {
  const RoudedRectangle({
    super.key,
    required this.textEditingController,
    required this.textInputType,
    required this.labelText,
    required this.hintText,
    this.obscureText = false,
  });

  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final String labelText;
  final String hintText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 330,
      decoration: const BoxDecoration(
        color: Color(0xffe1d4d4),
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: TextField(
        controller: textEditingController,
        obscureText: obscureText,
        keyboardType: textInputType,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelText: labelText,
          labelStyle: const TextStyle(
            fontSize: 16,
            color: Color(0xff222222),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 14,
            color: Color(0xff414141),
          ),
        ),
      ),
    );
  }
}
