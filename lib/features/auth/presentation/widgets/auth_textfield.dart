import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String hintText;
  final IconData? suffixIcon;
  final bool isPassword;

  const AuthTextField({
    super.key,
    required this.hintText,
    this.suffixIcon,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100, // Fond gris très clair comme sur ton image
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: InputBorder.none,
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, color: Colors.grey, size: 20)
              : null,
        ),
      ),
    );
  }
}
