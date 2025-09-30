import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  static const Color coffeeBrown = Color(0xFF6F4E37); // Dark coffee
  static const Color latte = Color(0xFFD7B899); // Light latte beige
  static const Color cream = Color(0xFFF3E5AB); // Cream
  static const Color caramel = Color(0xFFC68E17); // Caramel accent
  static const Color error = Color(0xFFD9534F); // Error red
  static const Color hint = Color(0xFFBFA6A0); // Subtle hint brown
}

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;

  const CustomTextField({
    super.key,
    this.controller,
    required this.label,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly,
      maxLines: maxLines,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText ?? label,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.coffeeBrown)
            : null,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: enabled ? AppColors.latte : AppColors.latte.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.coffeeBrown),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.coffeeBrown),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.caramel, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.coffeeBrown.withOpacity(0.4)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: enabled ? AppColors.coffeeBrown : AppColors.hint,
        ),
        hintStyle: const TextStyle(
          color: AppColors.hint,
          fontStyle: FontStyle.italic,
        ),
      ),
      style: TextStyle(
        color: enabled ? AppColors.coffeeBrown : AppColors.hint,
        fontSize: 16,
      ),
      cursorColor: AppColors.caramel,
    );
  }
}
