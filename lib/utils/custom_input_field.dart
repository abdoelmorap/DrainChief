import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final String? hintText;
  final bool? obscrureText;
  final Widget? suffixWidget;
  final TextInputAction? textInputAction;
  final int maxLines;
  const CustomTextField({
    Key? key,
    this.hintText,
    this.textEditingController,
    this.obscrureText,
    this.suffixWidget,
    this.textInputAction,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      autocorrect: false,
      autofocus: false,
      textInputAction: textInputAction,
      controller: textEditingController,
      obscureText: obscrureText ?? false,
      style: Theme.of(context).textTheme.titleMedium,
      decoration: InputDecoration(
        suffixIcon: suffixWidget ?? null,
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.titleMedium,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: Get.textTheme.titleMedium?.color ?? Color(0xFFFFFFFF), width: 1.0),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: Get.textTheme.titleMedium?.color ?? Color(0xFFFFFFFF), width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.lightBlue, width: 1.0),
        ),
      ),
    );
  }
}

InputDecoration inputDecoration(
    BuildContext context, String hint, Widget suffixIcon) {
  return InputDecoration(
    suffixIcon: suffixIcon,
    hintText: "$hint",
    hintStyle: Theme.of(context).textTheme.titleMedium,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.black, width: 1.0),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.black, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.grey, width: 1.0),
    ),
  );
}
