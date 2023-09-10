import 'package:flutter/material.dart';

import 'ButtonShare.dart';
import 'HeaderMyFolderFile.dart';

class MyFilesCore extends StatelessWidget {
  final List<Widget> widgets;
  final List<String> lastPaths;
  final ScrollController scrollController;
  final bool isDelete;
  final Function onClick;

  const MyFilesCore({
    Key? key,
    required this.widgets,
    required this.lastPaths,
    required this.scrollController,
    this.isDelete = false,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // buildHeader(),
        buildBodyList(),
        if (isDelete) ButtonShare(onClick: onClick),
      ],
    );
  }

  Expanded buildBodyList() {
    return Expanded(
      child: widgets.isNotEmpty
          ? ListView(
              physics: BouncingScrollPhysics(),
              children: widgets,
            )
          : Container(
              child: Center(
                  child: Icon(
                Icons.folder_open,
                size: 100,
                color: Colors.grey.shade400,
              )),
            ),
    );
  }

  _scrollToEnd() async {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  Widget buildHeader() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
    return HeaderMyFolderFile(
        scrollController: scrollController, lastPaths: lastPaths);
  }
}
