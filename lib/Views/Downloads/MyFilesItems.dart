import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:open_document/my_files/model/custom_file_system_entity.dart';
import 'package:open_document/my_files/model/style_my_file.dart';
import 'package:intl/intl.dart';

class MyFilesItems extends StatelessWidget {
  final FileSystemEntity item;
  final DateTime date;
  final bool isDelete;
  final Function onPushScreen;
  final Function onUnzipFile;
  final Function onOpenDocument;
  final Function onDelete;

  const MyFilesItems({
    Key? key,
    required this.item,
    required this.date,
    this.isDelete = false,
    required this.onPushScreen,
    required this.onUnzipFile,
    required this.onOpenDocument,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = item.path.split("/").last;
    bool isDirectory = item.statSync().type.toString() == 'directory';
    bool isZipFile = title.split('.').last == 'zip';
    return InkWell(
      onTap: () => actionDecision(isDirectory, isZipFile),
      child: Container(
        decoration: buildBoxDecorationLine(),
        child: Row(
          children: [
            if (isDelete) buildContainerRadius(),
            buildIcon(isDirectory, isZipFile),
            buildItemTitleAndSubtitle(title),
            if (isDirectory)
              Padding(
                padding: EdgeInsets.only(right: 14),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }

  BoxDecoration buildBoxDecorationLine() {
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.black12, width: 1),
      ),
    );
  }

  actionDecision(bool isDirectory, bool isZipFile) {
    if (isDelete)
      return onDelete(item);
    else if (isDirectory)
      return onPushScreen(item.path);
    else if (isZipFile)
      return onUnzipFile(item.path);
    else
      return onOpenDocument(item.path);
  }

  Widget buildItemTitleAndSubtitle(String title) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(
          left: 10,
          top: 16,
          bottom: 16,
          right: 10,
        ),
        child: RichText(
          overflow: TextOverflow.visible,
          text: TextSpan(
            children: [
              TextSpan(
                  text: "$title \n",
                  style: Get.textTheme.titleMedium?.copyWith(fontSize: 14)),
              TextSpan(
                text: convertDaTeyMdAddJMS(date),
                style: Get.textTheme.titleSmall?.copyWith(fontSize: 8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildIcon(bool isDirectory, bool isZipFile) {
    if (isDirectory)
      return Padding(
        padding: EdgeInsets.only(left: 14),
        child: Icon(
          Icons.folder,
          size: 24,
        ),
      );
    else if (isZipFile)
      return Padding(
        padding: EdgeInsets.only(left: 14),
        child: Icon(
          Icons.attach_file_rounded,
          size: 24,
        ),
      );
    else
      return Padding(
        padding: EdgeInsets.only(left: 14),
        child: Icon(
          Icons.description,
          size: 24,
        ),
      );
  }

  Widget buildContainerRadius() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      width: isDelete ? 20 : 0,
      height: isDelete ? 20 : 0,
      alignment: Alignment.center,
      margin: EdgeInsets.only(
        right: 10,
        left: 14,
      ),
      decoration: buildBoxDecorationChecked(),
      child: buildCheckIcon(
          isChecked: CustomFileSystemEntity().map[item] ?? false),
    );
  }

  BoxDecoration buildBoxDecorationChecked() {
    return BoxDecoration(
      border: Border.all(color: Get.textTheme.titleMedium?.color ?? Color(0xFFFFFFFF), width: 0.5),
      color: StyleMyFile.textColorHeader,
    );
  }

  Center buildCheckIcon({bool isChecked = false}) {
    return Center(
      child: Icon(
        Icons.check,
        size: 18,
        color: isChecked ? Get.theme.primaryColor : StyleMyFile.textColorHeader,
      ),
    );
  }
}

String convertDaTeyMdAddJMS(DateTime date) {
  return DateFormat.yMd().add_jms().format(date);
}
