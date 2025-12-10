import 'package:flutter/material.dart';
import 'package:tailor_app/utils/colors.dart';
import 'package:tailor_app/utils/text.dart';

class Customelevatedbutton extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  const Customelevatedbutton({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  State<Customelevatedbutton> createState() => _CustomelevatedbuttonState();
}

class _CustomelevatedbuttonState extends State<Customelevatedbutton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Appcolors.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: Size(double.infinity, 50),
        elevation: 0,
      ),

      child: Text(
        widget.title,
        style: Apptext.subheading.copyWith(color: Colors.white),
      ),
    );
  }
}
