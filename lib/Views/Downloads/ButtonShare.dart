import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:open_document/my_files/model/custom_file_system_entity.dart';
import 'package:open_document/my_files/model/style_my_file.dart';

class ButtonShare extends StatelessWidget {
  final Function onClick;

  const ButtonShare({Key? key, required this.onClick}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool enable = CustomFileSystemEntity().hasSelectedFiles();
    return SafeArea(
      child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              enable
                  ? Flexible(
                      child: buildElevatedButton(
                        title: "${stctrl.lang["Delete"]}",
                        index: 1,
                        cancel: false,
                      ),
                    )
                  : Container(),
              SizedBox(width: 10),
              Flexible(
                child: buildElevatedButton(
                    title: "${stctrl.lang["Cancel"]}", index: 2, cancel: true),
              ),
              SizedBox(width: 10),
              Flexible(
                child: buildElevatedButton(
                    title:  "${stctrl.lang["Delete All"]}", index: 3, cancel: false),
              ),
            ],
          )),
    );
  }

  Widget buildElevatedButton(
      {@required String? title, required int index, bool? cancel}) {
    bool enable = CustomFileSystemEntity().hasSelectedFiles();
    return ElevatedButton(
      onPressed: () => enable || index == 3 || index == 2
          ? onClick(index)
          : debugPrint("---disable---"),
      style: shape(enable, cancel ?? false, index),
      child: Text(
        title ?? '',
        style: Get.textTheme.titleSmall?.copyWith(color: Colors.white),
      ),
    );
  }

  ButtonStyle shape(bool enable, bool cancel, int index) {
    return ElevatedButton.styleFrom(
      elevation: 0, backgroundColor: index == 3
          ? Color(0xffFF1414)
          : enable
              ? cancel
                  ? Colors.blueGrey
                  : Color(0xffFF1414)
              : Colors.blueGrey,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(5.0),
      ),
    );
  }

  TextStyle buildTextStyle(bool enable) {
    return TextStyle(
      color: enable
          ? StyleMyFile.elevatedButtonTextStyleEnable
          : StyleMyFile.elevatedButtonTextStyleDisable,
    );
  }
}
