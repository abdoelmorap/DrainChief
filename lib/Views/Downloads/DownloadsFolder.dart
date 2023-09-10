import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:open_document/my_files/init.dart';
import 'MyFilesCore.dart' as MyFilesCore;
import 'SlidableMyFileItem.dart';

class DownloadsFolder extends StatefulWidget {
  final String? filePath;
  final List<String>? lastPath;
  final Widget? loading;
  final Widget? error;
  final String? title;

  const DownloadsFolder(
      {Key? key,
      @required this.filePath,
      this.lastPath,
      this.loading,
      this.error,
      this.title})
      : super(key: key);

  @override
  _DownloadsFolderState createState() => _DownloadsFolderState();
}

class _DownloadsFolderState extends State<DownloadsFolder>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  List<FileSystemEntity>? _list;
  List<FileSystemEntity>? _listNew;
  List<String>? lastPaths;
  String pathFix = "";
  ScrollController? _scrollController;
  Future<List<FileSystemEntity>>? future;

  bool isDelete = false;

  @override
  void initState() {
    pathFix = widget.filePath ?? '';
    _scaffoldKey = new GlobalKey<ScaffoldState>();
    _list = [];
    _listNew = [];
    lastPaths = widget.lastPath ?? [];
    _scrollController = ScrollController();
    future = getDocumentPath();

    super.initState();
  }

  @override
  void dispose() {
    lastPaths?.removeLast();
    isDelete = false;
    CustomFileSystemEntity().clearValues();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            color: Get.theme.primaryColor,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget.title ?? '',
                    style:
                        Get.textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Expanded(
            child: body(context),
          ),
        ],
      ),
    );
  }

  buildAppBar() {
    return AppBar(
      backgroundColor: Get.theme.appBarTheme.backgroundColor,
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
        Container(),
      ],
      flexibleSpace: Container(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios_sharp),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  alignment: Alignment.centerLeft,
                  width: 80,
                  height: 30,
                  child: Image.asset(
                    'images/$appLogo',
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                FutureBuilder<List<FileSystemEntity>>(
                    future: future,
                    // ignore: missing_return
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.active:
                        case ConnectionState.waiting:
                          return loading();
                        case ConnectionState.done:
                          if (!snapshot.hasData) {
                            return SizedBox.shrink();
                          } else {
                            if ((snapshot.data?.length ?? 0) > 0) {
                              return InkWell(
                                onTap: () async {
                                  openSelection();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  width: 70,
                                  child: Text(
                                    !isDelete
                                        ? "${stctrl.lang["Delete"]}"
                                        : "${stctrl.lang["Complete"]}",
                                    style: Get.textTheme.titleSmall,
                                  ),
                                ),
                              );
                            }
                          }
                          return Container();
                      }
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget body(BuildContext context) {
    return FutureBuilder<List<FileSystemEntity>>(
      future: future,
      // ignore: missing_return
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return loading();
          case ConnectionState.done:
            if (!snapshot.hasData)
              return widgetError(snapshot);
            else
              return myFilesCore(snapshot.data ?? []);
        }
      },
    );
  }

  Widget loading() =>
      widget.loading ?? Center(child: CircularProgressIndicator());

  Widget widgetError(AsyncSnapshot<List<FileSystemEntity>> snapshot) =>
      widget.error ??
      Center(
        child: Text("${snapshot.error}"),
      );

  MyFilesCore.MyFilesCore myFilesCore(List<FileSystemEntity> list) {
    _list = list;
    _listNew = _list;
    return MyFilesCore.MyFilesCore(
      widgets: createList(_listNew ?? []),
      lastPaths: lastPaths ?? [],
      scrollController: _scrollController ?? ScrollController(),
      isDelete: isDelete,
      onClick: (key) => onClick(key),
    );
  }

  List<Widget> createList(List<FileSystemEntity> data) {
    List<Widget> widgets = [];
    for (FileSystemEntity file in data) {
      var date = file.statSync().modified;
      widgets.add(
        SlidableMyFileItem(
          onDelete: onDelete,
          pushScreen: pushScreen,
          isDelete: isDelete,
          file: file,
          date: date,
          lastPath: lastPaths?.last ?? '',
          updateFilesList: updateFilesList,
        ),
      );
    }
    return widgets;
  }

  Future<List<FileSystemEntity>> getDocumentPath() async {
    var files = <FileSystemEntity>[];
    var completer = new Completer<List<FileSystemEntity>>();
    // String path = '';
    // String nameApp = await OpenDocument.getNameFolder(
    //     widowsFolder: StyleMyFile.nameFolderDocumentWindows);
    // if (widget.filePath != nameApp) {
    //   path = widget.filePath;
    // } else {
    //   path = await OpenDocument.getPathDocument(folderName: widget.filePath);
    // }

    String path = widget.filePath ?? '';

    Directory dir = new Directory(path);
    var lister = dir.list(recursive: false);
    lister.listen(
      (file) {
        files.add(file);
        CustomFileSystemEntity().map[file] = false;
      },
      onDone: () {
        lastPaths?.add(path);
        // ** Auto generated files check
        files.removeWhere((element) =>
            element.path.contains('.lock') ||
            element.path.contains('PersistedInstallation'));
        files.sort(
            (a, b) => b.statSync().modified.compareTo(a.statSync().modified));
        completer.complete(files);
      },
    );
    setState(() {});

    return completer.future;
  }

  openSelection() async {
    setState(() {
      isDelete = !isDelete;
      CustomFileSystemEntity().clearValues();
    });
  }

  pushScreen(String path) {
    return Get.to(
      () => DownloadsFolder(
        filePath: path,
        lastPath: lastPaths,
        title: "${path.split('/').last.toString()}",
      ),
      preventDuplicates: false,
    );
  }

  updateFilesList() {
    setState(() {
      // lastPaths.removeLast();
      future = getDocumentPath();
    });
  }

  onDelete(FileSystemEntity file) {
    CustomFileSystemEntity().map[file] = !CustomFileSystemEntity().map[file]!;
    setState(() {});
  }

  onClick(key) {
    if (key == 1) {
      deleteFiles();
    } else if (key == 2) {
      setState(() {
        isDelete = !isDelete;
      });
    } else {
      deleteAllFiles();
    }
  }

  void deleteAllFiles() async {
    Get.dialog(
      AlertDialog(
        title: Text(
          "${stctrl.lang["Do you want to delete all files/folders in this directory?"]}",
          style: Get.textTheme.titleMedium,
        ),
        actions: <Widget>[
          TextButton(
            child: Text("${stctrl.lang["Cancel"]}"),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            child: Text(
              "${stctrl.lang["Delete"]}",
            ),
            onPressed: () async {
              try {
                context.loaderOverlay.show();
                String path = widget.filePath ?? '';
                var document = Directory(path);
                await document.delete(recursive: true).whenComplete(() {
                  context.loaderOverlay.hide();
                  updateFilesList();
                  setState(() {
                    isDelete = !isDelete;
                  });
                });
              } on PlatformException catch (e) {
                debugPrint("${e.message}");
              }
              Get.back();
            },
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void deleteFiles() async {
    List<String> selectedFiles = [];
    CustomFileSystemEntity().map.forEach((key, value) {
      if (value) selectedFiles.add(key.path);
    });
    Get.dialog(
      AlertDialog(
        title: Text(
          "${stctrl.lang["Do you want to delete?"]}",
          style: Get.textTheme.titleMedium,
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: List.generate(
              selectedFiles.length,
              (index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: selectedFiles.length > 1
                    ? Text(
                        "${index + 1}. ${selectedFiles[index].split('/').last.toString()}",
                        style: Get.textTheme.titleSmall,
                      )
                    : Text(
                        "${selectedFiles[index].split('/').last.toString()}",
                        style: Get.textTheme.titleSmall,
                      ),
              ),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("${stctrl.lang["Cancel"]}",),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            child: Text("${stctrl.lang["Delete"]}",),
            onPressed: () {
              try {
                selectedFiles.forEach((element) async {
                  var document = File(element);
                  await document
                      .delete(recursive: true)
                      .whenComplete(() => updateFilesList());
                });
                setState(() {
                  isDelete = !isDelete;
                });
              } on PlatformException catch (e) {
                debugPrint("${e.message}");
              }
              Get.back();
            },
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
