import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hint;
  final String iconPath;
  final bool isPassword;
  final TextInputType? keyboardType;           // ← added
  final TextInputAction? textInputAction;      // optional but very useful
  final FocusNode? focusNode;                  // optional – you can keep internal one

  const CustomTextField({
    super.key,
    this.controller,
    required this.hint,
    required this.iconPath,
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      keyboardType: widget.keyboardType,             // ← now passed through
      textInputAction: widget.textInputAction ??     // nice default
          (widget.isPassword ? TextInputAction.done : TextInputAction.next),
      obscureText: widget.isPassword,
      cursorColor: const Color(0xFF22C55E),

      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(14),
          child: SvgPicture.asset(
            widget.iconPath,
            width: 25,
            colorFilter: const ColorFilter.mode(
              Color(0xFF22C55E),
              BlendMode.srcIn,
            ),
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: const BorderSide(
            color: Color(0xFF22C55E),
            width: 2,
          ),
        ),
      ),
    );
  }
}