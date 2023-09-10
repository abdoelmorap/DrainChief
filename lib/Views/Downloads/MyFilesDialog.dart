import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_document/my_files/model/style_my_file.dart';

class MyFilesDialog extends StatelessWidget {
  final String path;
  final bool isDirectory;
  final Function onPressed;

  const MyFilesDialog({
    Key? key,
    required this.path,
    required this.isDirectory,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertCustomizedForDecisions(
      alertContent: getAlertContent(context),
      actions: buildActions(context),
    );
  }

  Widget getAlertContent(context) {
    return isDirectory
        ? StyleMyFile.myFileDialogAlertFolder
        : StyleMyFile.myFileDialogAlertFile;
  }

  List<Widget> buildActions(context) {
    List<Widget> actions = [];
    actions.add(createActionButton(context, StyleMyFile.textActionCancel));
    actions.add(createActionButton(
      context,
      StyleMyFile.textActionDelete,
      onDeleteFile: () => onPressed(),
    ));
    return actions;
  }

  Widget createActionButton(context, String buttonText,
      {Function? onDeleteFile}) {
    return TextButton(
      child: Text(buttonText),
      onPressed: () =>
          onDeleteFile != null ? onDeleteFile() : Navigator.of(context).pop(),
    );
  }
}

class AlertCustomizedForDecisions extends StatelessWidget {
  final Widget alertContent;
  final List<Widget> actions;

  const AlertCustomizedForDecisions({
    Key? key,
    required this.alertContent,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (Theme.of(context).platform == TargetPlatform.iOS)
        ? createIosAlertDialog()
        : createAndroidAlertDialog();
  }

  CupertinoAlertDialog createIosAlertDialog() {
    return CupertinoAlertDialog(
      content: alertContent,
      actions: actions,
    );
  }

  AlertDialog createAndroidAlertDialog() {
    return AlertDialog(
      content: alertContent,
      actions: actions,
    );
  }
}
