import 'package:flutter/material.dart';

// Gradient background
Widget buildGradientBackground({required Widget child}) {
  return Container(
    width: double.infinity,
    height: double.infinity,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xff3E8EFB), Color(0xff6A4DF5)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: child,
  );
}

// Frosted glass card
Widget buildGlassCard({required Widget child}) {
  return Container(
    padding: const EdgeInsets.all(20),
    margin: const EdgeInsets.symmetric(horizontal: 25),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
    ),
    child: child,
  );
}

// Input field
Widget buildInputField({
  required String label,
  required TextEditingController ctrl,
  required IconData icon,
  bool isPassword = false,
  bool obscure = false,
  VoidCallback? onVisibilityTap,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: ctrl,
    obscureText: obscure,
    style: const TextStyle(color: Colors.white),
    validator: validator ?? (v) => v!.isEmpty ? "Please enter $label" : null,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      prefixIcon: Icon(icon, color: Colors.white),
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                obscure ? Icons.visibility_off : Icons.visibility,
                color: Colors.white,
              ),
              onPressed: onVisibilityTap,
            )
          : null,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
    ),
  );
}

// Gradient Button
Widget buildGradientButton({
  required String text,
  required VoidCallback? onTap,
  bool isLoading = false,
}) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 400),
    width: double.infinity,
    height: 50,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xffFBCB3E), Color(0xffF55F4D)],
      ),
      borderRadius: BorderRadius.circular(15),
    ),
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        disabledBackgroundColor: Colors.grey.withValues(alpha: 0.5),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
    ),
  );
}

