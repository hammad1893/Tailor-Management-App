import 'package:flutter/material.dart';

class Customtextfied extends StatefulWidget {
  final String? label;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool? obsecureText;
  final TextEditingController? controller;
  final VoidCallback? onSuffixTap;
  const Customtextfied({
    super.key,
    this.label,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obsecureText,
    this.controller,
    this.onSuffixTap,
  });

  @override
  State<Customtextfied> createState() => _CustomtextfiedState();
}

class _CustomtextfiedState extends State<Customtextfied> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.obsecureText ?? false,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText,
        suffixIcon:
            widget.suffixIcon != null
                ? IconButton(
                  onPressed: widget.onSuffixTap,
                  icon: Icon(widget.suffixIcon),
                )
                : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
