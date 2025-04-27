import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CommonWidgets {
  static Widget buildTextField({
    required TextEditingController controller,
    required String label,
    String? hintText,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? prefixIcon,
    Widget? suffixIcon,
    ValueChanged<String>? onChanged,
    bool autofocus = false,
    bool enabled = true,
    int maxLines = 1,
  }) {
    return Animate(
      effects: [FadeEffect(duration: 300.ms), ScaleEffect(duration: 300.ms)],
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        autofocus: autofocus,
        enabled: enabled,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  static Widget buildButton({
    required VoidCallback? onPressed,
    required String label,
    Color? backgroundColor,
    Color? foregroundColor,
    bool isFullWidth = true,
    double elevation = 2,
    Widget? icon,
    double borderRadius = 12,
  }) {
    return Animate(
      effects: [ScaleEffect(duration: 200.ms), FadeEffect(duration: 200.ms)],
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: elevation,
          minimumSize: isFullWidth ? const Size(double.infinity, 50) : null,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child:
            icon != null
                ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [icon, const SizedBox(width: 8), Text(label)],
                )
                : Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  static Widget buildIconButton({
    required VoidCallback onPressed,
    required IconData icon,
    Color? backgroundColor,
    Color? iconColor,
    double size = 48,
    double iconSize = 24,
    double borderRadius = 12,
  }) {
    return Animate(
      effects: [ScaleEffect(duration: 200.ms), FadeEffect(duration: 200.ms)],
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: iconSize, color: iconColor),
        style: IconButton.styleFrom(
          backgroundColor: backgroundColor,
          fixedSize: Size(size, size),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}
