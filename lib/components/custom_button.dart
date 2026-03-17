import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Future<void> Function()? onPressed;   // ← Changed: now supports async
  final bool isLoading;                       // ← Optional: nice to have

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: (onPressed == null || isLoading) ? null : () => onPressed!(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00C850),
          disabledBackgroundColor: const Color(0xFF00C850).withOpacity(0.6),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(45),
            side: const BorderSide(
              color: Color(0xFFECECEC),
              width: 1.5,
            ),
          ),
        ),
        child: isLoading
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2.5,
          ),
        )
            : Text(
          text,
          style: const TextStyle(
            color: Color(0xFFECECEC),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}