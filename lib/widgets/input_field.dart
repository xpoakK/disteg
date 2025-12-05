import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final String label;
  final bool obscure;
  final TextEditingController controller;

  const InputField({
    required this.label,
    required this.controller,
    this.obscure = false,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      controller: widget.controller,
      obscureText: widget.obscure,
      decoration: InputDecoration(
        hintText: focusNode.hasFocus ? '' : widget.label,
        hintStyle: TextStyle(color: Colors.grey.shade600),
        filled: true,
        fillColor: const Color(0xFFE6E6E6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}