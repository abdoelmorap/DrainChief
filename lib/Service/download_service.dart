import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DownloadFile {
  /// Used to record the url being downloaded to avoid duplicate downloads
  static var downloadingUrls = Map<String, CancelToken>();

  /// Breakpoint downloading of large files
  static Future<void> download({
    @required String? url,
    @required String? savePath,
    ProgressCallback? onReceiveProgress,
    void Function()? done,
    void Function(DioError)? failed,
  }) async {
    int downloadStart = 0;
    bool fileExists = false;
    File f = File(savePath ?? '');
    if (await f.exists()) {
      downloadStart = f.lengthSync();
      fileExists = true;
    }
    if (fileExists && downloadingUrls.containsKey(url)) {
      return;
    }
    var dio = Dio();
    CancelToken cancelToken = CancelToken();
    downloadingUrls[url!] = cancelToken;
    try {
      var response = await dio.get<ResponseBody>(
        url,
        options: Options(
          /// Receive response data as a stream
          responseType: ResponseType.stream,
          followRedirects: false,
          headers: {
            /// Downloading key locations in segments
            "range": "bytes=$downloadStart-",
          },
        ),
      );
      File file = File(savePath ?? '');
      RandomAccessFile raf = file.openSync(mode: FileMode.append);
      int received = downloadStart;
      int total = await _getContentLength(response);
      Stream<Uint8List> stream = response.data!.stream;
      StreamSubscription<Uint8List> subscription;
      subscription = stream.listen(
        (data) {
          /// Write files must be synchronized
          raf.writeFromSync(data);
          received += data.length;
          onReceiveProgress?.call(received, total);
        },
        onDone: () async {
          downloadingUrls.remove(url);
          await raf.close();
          done?.call();
        },
        onError: (e) async {
          await raf.close();
          downloadingUrls.remove(url);
          failed?.call(e as DioError);
        },
        cancelOnError: true,
      );
      cancelToken.whenCancel.then((_) async {
        await subscription.cancel();
        await raf.close();
      });
    } on DioError catch (error) {
      /// The request has been sent and the server responds with a status code that it is not in the range of 200
      if (CancelToken.isCancel(error)) {
        print("Download cancelled");
      } else {
        failed?.call(error);
      }
      downloadingUrls.remove(url);
    }
  }

  /// Get the size of the downloaded file
  static Future<int> _getContentLength(Response<ResponseBody> response) async {
    try {
      var headerContent =
          response.headers.value(HttpHeaders.contentRangeHeader);
      print("download files: $headerContent");
      if (headerContent != null) {
        return int.parse(headerContent.split('/').last);
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  /// Cancel Mission
  static void cancelDownload(String url) {
    downloadingUrls[url]?.cancel();
    downloadingUrls.remove(url);
  }
}
