import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Config/app_config.dart';

class CustomDialog extends StatelessWidget {
  final String? contentText;
  final String? titleText;
  final String? actionBtnText;
  final VoidCallback? actionBtn;
  CustomDialog(
      {this.contentText, this.titleText, this.actionBtnText, this.actionBtn});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        "$titleText",
        style: GoogleFonts.montserrat(
          textStyle: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
      content: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          "$contentText",
          style: GoogleFonts.montserrat(
            textStyle:
                Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: actionBtn,
          child: Text(
            "$actionBtnText",
          ),
        ),
      ],
    );
  }
}

class CustomAlertDialog extends StatelessWidget {
  final String? titleText;
  final VoidCallback? onTapYes;
  final VoidCallback? onTapNo;
  final Widget? content;
  final Color color;
  CustomAlertDialog(
      {this.titleText,
      this.onTapYes,
      this.onTapNo,
      this.content,
      this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    final _title = Text(
      "$titleText",
      style: GoogleFonts.montserrat(
        textStyle: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: color, fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
    final _children = [
      onTapYes == null
          ? SizedBox.shrink()
          : TextButton(
              onPressed: onTapNo,
              child: Text(
                "${stctrl.lang['No']}",
              ),
            ),
      onTapNo == null
          ? SizedBox.shrink()
          : TextButton(
              onPressed: onTapYes,
              child: Text(
                "${stctrl.lang['Yes']}",
              ),
            ),
    ];
    return Platform.isAndroid
        ? AlertDialog(
            title: _title,
            content: content,
            actions: _children,
          )
        : CupertinoAlertDialog(
            title: _title,
            content: content,
            actions: _children,
          );
  }
}
