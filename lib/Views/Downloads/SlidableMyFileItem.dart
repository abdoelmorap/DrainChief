import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/utils/CustomSnackBar.dart';
import 'package:open_document/my_files/model/extract_zip.dart';
import 'package:open_document/open_document.dart';

import 'MyFilesDialog.dart';
import 'MyFilesItems.dart';

class SlidableMyFileItem extends StatelessWidget {
  final Function onDelete;
  final Function pushScreen;
  final bool isDelete;
  final FileSystemEntity file;
  final DateTime date;
  final String lastPath;
  final Function updateFilesList;

  const SlidableMyFileItem({
    Key? key,
    required this.onDelete,
    required this.pushScreen,
    required this.isDelete,
    required this.file,
    required this.date,
    required this.lastPath,
    required this.updateFilesList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(file.path),
      startActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: check,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: MyFilesItems(
        item: file,
        date: date,
        isDelete: isDelete,
        onPushScreen: (String path) => pushScreen(path),
        onUnzipFile: onUnzipFile,
        onOpenDocument: (String path) => openDocument(path),
        onDelete: (file) => onDelete(file),
      ),
    );
  }

  void check(BuildContext context) {
    bool isDirectory = file.statSync().type.toString() == 'directory';
    checkDeletingFiles(context, file.path, isDirectory);
  }

  onUnzipFile(String path) => extractZip(
      path: path, lastPath: lastPath, updateFilesList: () => onStateRemove());

  onStateRemove() {
    updateFilesList();
  }

  openDocument(String path) async {
    return OpenDocument.openDocument(filePath: path);
  }

  checkDeletingFiles(BuildContext context, String path, bool isDirectory) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MyFilesDialog(
          path: path,
          isDirectory: isDirectory,
          onPressed: () => onPressed(context, path, isDirectory),
        );
      },
    );
  }

  void onPressed(
    BuildContext context,
    String path,
    bool isDirectory,
  ) {
    onDeleteFile(context, path, isDirectory);
    Navigator.of(context).pop();
  }

  void onDeleteFile(BuildContext context, String path, bool isDirectory) async {
    var document = isDirectory ? Directory(path) : File(path);
    await document
        .delete(recursive: true)
        .then((value) => CustomSnackBar()
            .snackBarSuccess("${stctrl.lang["Deleted successfully"]}"))
        .catchError((error) => CustomSnackBar().snackBarSuccess(
              "${stctrl.lang["Error Deleting file"]}",
            ))
        .whenComplete(() => updateFilesList());
  }

  createSnackBar(BuildContext context,
      {@required String? message, required Color backgroundColor}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? ''),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: 5),
      ),
    );
  }
}
