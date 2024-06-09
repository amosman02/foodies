import 'package:flutter/material.dart';

import 'package:foodies/constants/colors.dart' as constants;

class CustomTextField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final bool obsecureText;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  const CustomTextField({
    super.key,
    required this.title,
    required this.hint,
    this.controller,
    this.obsecureText = false,
    this.padding,
    this.margin,
    this.validator,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: MediaQuery.of(context).size.width,
            height: 50,
            decoration: BoxDecoration(
                color: constants.lightGrey,
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              controller: controller,
              style: const TextStyle(fontSize: 14),
              cursorColor: constants.primaryColor,
              obscureText: obsecureText,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
                contentPadding: const EdgeInsets.only(left: 16),
                border: InputBorder.none,
                errorStyle: const TextStyle(height: 2),
              ),
              validator: validator,
              onSaved: onSaved,
            ),
          ),
        ],
      ),
    );
  }
}
