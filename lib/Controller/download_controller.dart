// Flutter imports:
import 'dart:io';

import 'package:flutter/material.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:lms_flutter_app/Views/Downloads/DownloadsFolder.dart';
import 'package:lms_flutter_app/utils/CustomSnackBar.dart';
import 'package:lms_flutter_app/utils/widgets/progress_dialog_custom.dart';
import 'package:open_document/open_document.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';

class DownloadController extends GetxController
    with GetTickerProviderStateMixin {
  var downloadUrl = "".obs;
  var isDownloading = false.obs;

  var downloadedPath = "".obs;

  var downloadingText = "${stctrl.lang["Downloading"]}".obs;

  var received = "".obs;

  Rx<double> downloadValue = 0.0.obs;

  CancelToken? token;

  Dio dio = Dio();

  var fileExists = false.obs;

  static String getExtention(String url) {
    var parts = url.split("/");
    return parts[parts.length - 1];
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> downloadFile(
      String url, String title, BuildContext dialogContext) async {
    String filePath;

    final extension = p.extension(url);

    Directory applicationSupportDir = await getApplicationSupportDirectory();
    String folderPath = applicationSupportDir.path;

    print("appSupportPath $folderPath");

    filePath = "$folderPath/${companyName}_$title$extension";

    final isCheck = await OpenDocument.checkDocument(filePath: filePath);

    debugPrint("Exist: $isCheck");

    try {
      await download(
              filePath: "$filePath", url: url, dialogContext: dialogContext)
          .then((value) async {
        print("Value $value");
        if (value != null) {
          filePath = value;

          if (extension.contains('.zip')) {
            Get.to(() => DownloadsFolder(filePath: folderPath));
          } else {
            await OpenDocument.openDocument(
              filePath: filePath,
            );
          }
        }
      });
    } catch (e) {
      debugPrint("ERROR: message_$e");
    }
  }

  Future<String?> download(
      {@required String? filePath,
      @required String? url,
      BuildContext? dialogContext}) async {
    ProgressDialog pd = ProgressDialog(context: dialogContext);
    token = CancelToken();

    var downloadingUrls = Map<String, CancelToken>();

    downloadingUrls[url ?? ''] = token!;
    isDownloading(true);
    pd.show(
      max: 100,
      msg: "${stctrl.lang["Downloading"]}",
      backgroundColor: Get.theme.cardColor,
      progressType: ProgressType.valuable,
      barrierColor: Colors.black.withOpacity(0.7),
      stopButton: () {
        token?.cancel();
        pd.close();
      },
    );

    var response = await dio.download(rootUrl + '/' + url!, filePath,
        onReceiveProgress: (receivedBytes, totalBytes) async {
      int progress = (((receivedBytes / totalBytes) * 100).toInt());
      print(progress);
      pd.update(value: progress);
      if (progress == 100) {
        update();
      }
    }, cancelToken: token).catchError((onError) {
      token?.cancel();
      pd.close();
      CustomSnackBar()
          .snackBarError("${stctrl.lang["Error downloading file"]}");
    });
    if (response.statusCode == 200) {
      return filePath;
    } else {
      return null;
    }
  }
}
