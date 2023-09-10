// Dart imports:
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// Package imports:

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/download_controller.dart';
import 'package:lms_flutter_app/Controller/lesson_controller.dart';
import 'package:lms_flutter_app/Controller/myCourse_controller.dart';
import 'package:lms_flutter_app/Controller/my_course_details_tab_controller.dart';
import 'package:lms_flutter_app/Controller/quiz_controller.dart';
import 'package:lms_flutter_app/Model/Course/FileElement.dart';
import 'package:lms_flutter_app/Model/Course/Lesson.dart';
import 'package:lms_flutter_app/Service/permission_service.dart';
import 'package:lms_flutter_app/Views/Downloads/DownloadsFolder.dart';
import 'package:lms_flutter_app/Views/MyCourseClassQuiz/MyQuiz/start_quiz_page.dart';
import 'package:lms_flutter_app/Views/VideoView/PDFViewPage.dart';
import 'package:lms_flutter_app/Views/VideoView/VideoChipherPage.dart';
import 'package:lms_flutter_app/Views/VideoView/VideoPlayerPage.dart';
import 'package:lms_flutter_app/Views/VideoView/VimeoPlayerPage.dart';
import 'package:lms_flutter_app/utils/CustomExpansionTileCard.dart';
import 'package:lms_flutter_app/utils/CustomSnackBar.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';
import 'package:lms_flutter_app/utils/MediaUtils.dart';
import 'package:lms_flutter_app/utils/SliverAppBarTitleWidget.dart';
import 'package:lms_flutter_app/utils/styles.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:octo_image/octo_image.dart';
import 'package:open_document/open_document.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';

import '../../../utils/widgets/course_details_flexible_space_bar.dart';

// ignore: must_be_immutable
class MyCourseDetailsView extends StatefulWidget {
  @override
  _MyCourseDetailsViewState createState() => _MyCourseDetailsViewState();
}

class _MyCourseDetailsViewState extends State<MyCourseDetailsView> {
  final MyCourseController controller = Get.put(MyCourseController());
  GetStorage userToken = GetStorage();

  String tokenKey = "token";

  double width = 0;

  double percentageWidth = 0;

  double height = 0;

  double percentageHeight = 0;

  bool playing = false;

  String youtubeID = "";

  var progress = "${stctrl.lang["Download"]}";

  var received;

  math.Random random = math.Random();

  void initCheckPermission() async {
    final _handler = PermissionsService();
    await _handler.requestPermission(
      Permission.storage,
      onPermissionDenied: () => setState(
        () => debugPrint("Error: "),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initCheckPermission();
  }

  @override
  void dispose() {
    controller.commentController.text = "";
    controller.selectedLessonID.value = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MyCourseDetailsTabController _tabx =
        Get.put(MyCourseDetailsTabController());

    final double statusBarHeight = MediaQuery.of(context).padding.top;
    // ignore: unused_local_variable
    var pinnedHeaderHeight = statusBarHeight + kToolbarHeight;

    width = MediaQuery.of(context).size.width;
    percentageWidth = width / 100;
    height = MediaQuery.of(context).size.height;
    percentageHeight = height / 100;

    return Scaffold(
      body: LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
          child: SpinKitPulse(
            color: Get.theme.primaryColor,
            size: 30.0,
          ),
        ),
        child: Obx(() {
          if (controller.isMyCourseLoading.value)
            return Center(
              child: CupertinoActivityIndicator(),
            );
          return NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 280.0,
                  automaticallyImplyLeading: false,
                  titleSpacing: 20,
                  title: SliverAppBarTitleWidget(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Icon(
                            Icons.arrow_back_outlined,
                            color: Get.textTheme.titleMedium?.color,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${controller.myCourseDetails.value.title?['${stctrl.code.value}'] ?? controller.myCourseDetails.value.title?['en']}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Get.textTheme.titleMedium?.copyWith(
                              color: Get.textTheme.titleMedium?.color,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      background: CourseDetailsFlexilbleSpaceBar(
                          controller.myCourseDetails.value)),
                ),
              ];
            },
            // pinnedHeaderSliverHeightBuilder: () {
            //   return pinnedHeaderHeight;
            // },
            body: Column(
              children: <Widget>[
                TabBar(
                  labelColor: Colors.white,
                  tabs: _tabx.myTabs,
                  unselectedLabelColor: AppStyles.unSelectedTabTextColor,
                  controller: _tabx.controller,
                  indicator: Get.theme.tabBarTheme.indicator,
                  automaticIndicatorColorAdjustment: true,
                  isScrollable: false,
                  labelStyle: Get.textTheme.titleSmall,
                  unselectedLabelStyle: Get.textTheme.titleSmall,
                  padding: EdgeInsets.zero,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabx.controller,
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      curriculumWidget(controller),
                      filesWidget(controller),
                      questionsAnswerWidget(controller),
                    ],
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget curriculumWidget(
    MyCourseController controller,
  ) {
    void _scrollToSelectedContent(GlobalKey myKey) {
      final keyContext = myKey.currentContext;

      if (keyContext != null) {
        Future.delayed(Duration(milliseconds: 200)).then((value) {
          Scrollable.ensureVisible(keyContext,
              duration: Duration(milliseconds: 200));
        });
      }
    }

    return ExtendedVisibilityDetector(
      uniqueKey: const Key('curriculumWidget'),
      child: ListView.separated(
        itemCount: controller.myCourseDetails.value.chapters?.length ?? 0,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 4,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          var lessons = controller.myCourseDetails.value.lessons
              ?.where((element) =>
                  int.parse(element.chapterId.toString()) ==
                  int.parse(controller.myCourseDetails.value.chapters?[index].id
                      .toString() ?? ''))
              .toList();
          var total = 0;
          lessons?.forEach((element) {
            if (element.duration != null && element.duration != "") {
              if (!element.duration!.contains("H")) {
                total += double.parse(element.duration ?? '').toInt();
              }
            }
          });
          final GlobalKey expansionTileKey = GlobalKey();

          return CustomExpansionTileCard(
            key: expansionTileKey,
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            onExpansionChanged: (isExpanded) {
              if (isExpanded) _scrollToSelectedContent(expansionTileKey);
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 5,
                ),
                Text(
                  (index + 1).toString() + ". ",
                ),
                SizedBox(
                  width: 0,
                ),
                Expanded(
                  child: Text(
                    controller.myCourseDetails.value.chapters?[index].name ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                total > 0
                    ? Text(
                        getTimeString(total).toString() +
                            " ${stctrl.lang["Hour(s)"]}",
                      )
                    : SizedBox.shrink()
              ],
            ),
            children: <Widget>[
              ListView.builder(
                  itemCount: lessons?.length ?? 0,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  itemBuilder: (BuildContext context, int index) {
                    return Obx(() {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: controller.selectedLessonID.value ==
                                    lessons?[index].id
                                ? Get.theme.primaryColor
                                : Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: lessons?[index].isQuiz == 1
                            ? InkWell(
                                onTap: () async {
                                  controller.selectedLessonID.value =
                                      lessons?[index].id;
                                  context.loaderOverlay.show();
                                  final QuizController quizController =
                                      Get.put(QuizController());

                                  quizController.lessonQuizId.value =
                                      lessons?[index].quizId;
                                  quizController.courseID.value =
                                      controller.courseID.value;

                                  await quizController
                                      .getLessonQuizDetails()
                                      .then((value) {
                                    context.loaderOverlay.hide();
                                    Get.defaultDialog(
                                      title: "${stctrl.lang["Start Quiz"]}",
                                      backgroundColor: Get.theme.cardColor,
                                      titleStyle: Get.textTheme.titleMedium,
                                      barrierDismissible: true,
                                      content: Column(
                                        children: [
                                          courseStructure(
                                            "${stctrl.lang["Do you want to start the quiz?"]}",
                                          ),
                                          quizController.myQuizDetails.value
                                                      .quiz?.questionTimeType ==
                                                  0
                                              ? courseStructure(
                                                  "${stctrl.lang["Quiz Time"]}" +
                                                      ": " +
                                                      (quizController
                                                          .myQuizDetails
                                                          .value
                                                          .quiz
                                                          ?.questionTime
                                                          .toString() ?? '') +
                                                      " "
                                                          "${stctrl.lang["minute(s) per question"]}",
                                                )
                                              : courseStructure(
                                                  "${stctrl.lang["Quiz Time"]}" +
                                                      ": " +
                                                      (quizController
                                                          .myQuizDetails
                                                          .value
                                                          .quiz
                                                          ?.questionTime
                                                          .toString() ?? '') +
                                                      "${stctrl.lang["minute(s)"]}",
                                                ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Get.back();
                                                },
                                                child: Container(
                                                  width: 100,
                                                  height: percentageHeight * 5,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    shape: BoxShape.rectangle,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Text(
                                                    "${stctrl.lang["Cancel"]}",
                                                    style:
                                                        Get.textTheme.titleMedium,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              Obx(() {
                                                return quizController
                                                        .isQuizStarting.value
                                                    ? Container(
                                                        width: 100,
                                                        height:
                                                            percentageHeight *
                                                                5,
                                                        alignment:
                                                            Alignment.center,
                                                        child:
                                                            CupertinoActivityIndicator())
                                                    : ElevatedButton(
                                                        onPressed: () async {
                                                          await quizController
                                                              .startQuizFromLesson()
                                                              .then((value) {
                                                            if (value) {
                                                              Get.back();
                                                              Get.to(() => StartQuizPage(
                                                                  getQuizDetails:
                                                                      quizController
                                                                          .myQuizDetails
                                                                          .value));
                                                            } else {
                                                              Get.snackbar(
                                                                "${stctrl.lang["Error"]}",
                                                                "${stctrl.lang["Error Starting Quiz"]}",
                                                                snackPosition:
                                                                    SnackPosition
                                                                        .BOTTOM,
                                                                backgroundColor:
                                                                    Colors.red,
                                                                colorText:
                                                                    Colors
                                                                        .black,
                                                                borderRadius: 5,
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            3),
                                                              );
                                                            }
                                                          });
                                                        },
                                                        child: Text(
                                                          "${stctrl.lang["Start"]}",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Color(
                                                                  0xffffffff),
                                                              height: 1.3,
                                                              fontFamily:
                                                                  'AvenirNext'),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      );
                                              })
                                            ],
                                          ),
                                        ],
                                      ),
                                      radius: 5,
                                    );
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.questionCircle,
                                        color: Get.theme.primaryColor,
                                        size: 16,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2.0),
                                          child: Text(
                                              lessons?[index].quiz?[0].title?[
                                                      stctrl.code.value] ??
                                                  "${lessons?[index].quiz?[0].title?['en']}",
                                              style: Get.textTheme.titleSmall),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () async {
                                  context.loaderOverlay.show();
                                  final isVisible =
                                      context.loaderOverlay.visible;
                                  print(isVisible);

                                  controller.selectedLessonID.value =
                                      lessons?[index].id;

                                  if (lessons?[index].host == "Vimeo") {
                                    var vimeoID = lessons?[index]
                                        .videoUrl
                                        ?.replaceAll("/videos/", "");

                                    Get.bottomSheet(
                                      VimeoPlayerPage(
                                        lesson: lessons?[index] ?? Lesson(),
                                        videoTitle: "${lessons?[index].name}",
                                        videoId:
                                            '$rootUrl/vimeo/video/$vimeoID',
                                      ),
                                      backgroundColor: Colors.black,
                                      isScrollControlled: true,
                                    );
                                    context.loaderOverlay.hide();
                                  } else if (lessons?[index].host == "Youtube") {
                                    Get.bottomSheet(
                                      VideoPlayerPage(
                                        "Youtube",
                                        lesson: lessons?[index] ?? Lesson(),
                                        videoID: lessons?[index].videoUrl ?? '',
                                      ),
                                      backgroundColor: Colors.black,
                                      isScrollControlled: true,
                                    );
                                    context.loaderOverlay.hide();
                                  } else if (lessons?[index].host == "SCORM") {
                                    var videoUrl =
                                        "$rootUrl/scorm/video/${lessons?[index].id}";

                                    final LessonController lessonController =
                                        Get.put(LessonController());

                                    await lessonController
                                        .updateLessonProgress(lessons?[index].id,
                                            lessons?[index].courseId, 1)
                                        .then((value) async {
                                      log("$rootUrl/scorm/video/${lessons?[index].id}");
                                      Get.bottomSheet(
                                        VimeoPlayerPage(
                                          lesson: lessons?[index] ?? Lesson(),
                                          videoTitle: lessons?[index].name ?? '',
                                          videoId: videoUrl,
                                        ),
                                        backgroundColor: Colors.black,
                                        isScrollControlled: true,
                                      );
                                      context.loaderOverlay.hide();
                                    });
                                  } else if (lessons?[index].host ==
                                      "VdoCipher") {
                                    await generateVdoCipherOtp(
                                            lessons?[index].videoUrl)
                                        .then((value) {
                                      if (value['otp'] != null) {
                                        final EmbedInfo embedInfo =
                                            EmbedInfo.streaming(
                                          otp: value['otp'],
                                          playbackInfo: value['playbackInfo'],
                                          embedInfoOptions: EmbedInfoOptions(
                                            autoplay: true,
                                          ),
                                        );

                                        Get.bottomSheet(
                                          VdoCipherPage(
                                            embedInfo: embedInfo,
                                            lesson: lessons?[index] ?? Lesson(),
                                          ),
                                          backgroundColor: Colors.black,
                                          isScrollControlled: true,
                                        );
                                        context.loaderOverlay.hide();
                                      } else {
                                        context.loaderOverlay.hide();
                                        CustomSnackBar()
                                            .snackBarWarning(value['message']);
                                      }
                                    });
                                  } else {
                                    var videoUrl;
                                    if (lessons?[index].host == "Self") {
                                      videoUrl = rootUrl +
                                          "/" +
                                          '${lessons?[index].videoUrl}';
                                      Get.bottomSheet(
                                        VideoPlayerPage(
                                          "network",
                                          lesson: lessons?[index] ?? Lesson(),
                                          videoID: videoUrl,
                                        ),
                                        backgroundColor: Colors.black,
                                        isScrollControlled: true,
                                      );
                                      context.loaderOverlay.hide();
                                    } else if (lessons?[index].host == "URL" ||
                                        lessons?[index].host == "Iframe") {
                                      videoUrl = lessons?[index].videoUrl;
                                      Get.bottomSheet(
                                        VideoPlayerPage(
                                          "network",
                                          lesson: lessons?[index] ?? Lesson(),
                                          videoID: videoUrl,
                                        ),
                                        backgroundColor: Colors.black,
                                        isScrollControlled: true,
                                      );
                                      context.loaderOverlay.hide();
                                    } else if (lessons?[index].host == "PDF") {
                                      videoUrl = '$rootUrl/${lessons?[index].videoUrl}';
                                      Get.to(() => PDFViewPage(
                                            pdfLink: videoUrl,
                                          ));
                                      context.loaderOverlay.hide();
                                    } else {
                                      videoUrl = lessons?[index].videoUrl;

                                      String filePath;

                                      final extension = p.extension(videoUrl);

                                      Directory applicationSupportDir =
                                          await getApplicationSupportDirectory();
                                      String folderPath =
                                          applicationSupportDir.path;

                                      filePath =
                                          "$folderPath/${companyName}_${lessons?[index].name}$extension";

                                      final isCheck =
                                          await OpenDocument.checkDocument(
                                              filePath: filePath);

                                      debugPrint("Exist: $isCheck");

                                      if (isCheck) {
                                        context.loaderOverlay.hide();
                                        if (extension.contains('.zip')) {
                                          Get.to(() => DownloadsFolder(
                                                filePath: folderPath,
                                                title: "My Downloads",
                                              ));
                                        } else {
                                          await OpenDocument.openDocument(
                                            filePath: filePath,
                                          );
                                        }
                                      } else {
                                        final LessonController
                                            lessonController =
                                            Get.put(LessonController());

                                        // ignore: deprecated_member_use
                                        if (await canLaunch(
                                            rootUrl + '/' + videoUrl)) {
                                          await lessonController
                                              .updateLessonProgress(
                                                  lessons?[index].id,
                                                  lessons?[index].courseId,
                                                  1)
                                              .then((value) async {
                                            context.loaderOverlay.hide();
                                            final DownloadController
                                                downloadController =
                                                Get.put(DownloadController());
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return showDownloadAlertDialog(
                                                    context,
                                                    lessons?[index].name ?? "",
                                                    videoUrl,
                                                    downloadController,
                                                  );
                                                });
                                          });
                                        } else {
                                          context.loaderOverlay.hide();
                                          CustomSnackBar().snackBarError(
                                              "${stctrl.lang["Unable to open"]}" +
                                                  " ${lessons?[index].name}");
                                          // throw 'Unable to open url : ${rootUrl + '/' + videoUrl}';
                                        }
                                      }
                                    }
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      !MediaUtils.isFile(lessons?[index].host ?? '')
                                          ? Icon(
                                              FontAwesomeIcons.solidPlayCircle,
                                              color: Get.theme.primaryColor,
                                              size: 16,
                                            )
                                          : Icon(
                                              FontAwesomeIcons.file,
                                              color: Get.theme.primaryColor,
                                              size: 16,
                                            ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2.0),
                                          child: Text(lessons?[index].name ?? "",
                                              style: Get.textTheme.titleSmall),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      );
                    });
                  }),
            ],
          );
        },
      ),
    );
  }

  Widget filesWidget(MyCourseController controller) {
    final DownloadController downloadController = Get.put(DownloadController());

    return ExtendedVisibilityDetector(
      uniqueKey: const Key('Tab2'),
      child: ListView.builder(
        itemCount: controller.myCourseDetails.value.files?.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return fileDetailsWidget(
              context,
              controller.myCourseDetails.value.files?[index] ?? FileElement(),
              downloadController);
        },
      ),
    );
  }

  Widget fileDetailsWidget(BuildContext context, FileElement file,
      DownloadController downloadController) {
    return InkWell(
      onTap: () async {
        context.loaderOverlay.show();
        String filePath;

        final extension = p.extension(file.file ?? '');

        Directory applicationSupportDir =
            await getApplicationSupportDirectory();
        String folderPath = applicationSupportDir.path;

        filePath = "$folderPath/${companyName}_${file.fileName}$extension";

        final isCheck = await OpenDocument.checkDocument(filePath: filePath);

        debugPrint("Exist: $isCheck");

        if (isCheck) {
          context.loaderOverlay.hide();
          if (extension.contains('.zip')) {
            Get.to(() => DownloadsFolder(
                  filePath: folderPath,
                  title: "${stctrl.lang["My Downloads"]}",
                ));
          } else {
            await OpenDocument.openDocument(
              filePath: filePath,
            );
          }
        } else {
          final DownloadController downloadController =
              Get.put(DownloadController());
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return showDownloadAlertDialog(
                  context,
                  file.fileName ?? "",
                  file.file ?? '',
                  downloadController,
                );
              });
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                file.fileName != null
                    ? Container(
                        child: Icon(
                          FontAwesomeIcons.fileDownload,
                          color: Get.theme.primaryColor,
                          size: 16,
                        ),
                      )
                    : Container(),
                SizedBox(
                  width: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    file.fileName.toString(),
                    style: Get.textTheme.titleMedium,
                  ),
                ),
                Expanded(child: Container()),
              ],
            ),
            Divider(),
          ],
        ),
      ),
    );
  }

  Widget questionsAnswerWidget(MyCourseController controller) {
    return ExtendedVisibilityDetector(
      uniqueKey: const Key('Tab3'),
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.myCourseDetails.value.comments?.length ?? 0,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipOval(
                              child: OctoImage(
                                fit: BoxFit.cover,
                                height: 40,
                                width: 40,
                                image: controller.myCourseDetails.value.comments![index].user!.image!.contains('public/')
                                    ? NetworkImage(
                                        '$rootUrl/${controller.myCourseDetails.value.comments?[index].user?.image}')
                                    : NetworkImage(controller.myCourseDetails.value.comments?[index].user?.image ?? ''),
                                placeholderBuilder: OctoPlaceholder.blurHash(
                                  'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          controller.myCourseDetails.value
                                              .comments?[index].user?.name
                                              .toString() ?? '',
                                          style: Get.textTheme.titleMedium,
                                        ),
                                        Expanded(child: Container()),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            controller.myCourseDetails.value
                                                .comments?[index].commentDate
                                                .toString() ?? '',
                                            style: Get.textTheme.titleSmall,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      controller.myCourseDetails.value
                                          .comments?[index].comment
                                          .toString() ?? '',
                                      style: Get.textTheme.titleSmall,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          decoration: BoxDecoration(
            color: Get.theme.cardColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: 40,
                child: ClipOval(
                  child: OctoImage(
                    fit: BoxFit.cover,
                    height: 40,
                    width: 40,
                    image: controller.dashboardController.profileData.image!.contains('public')
                        ? NetworkImage(
                            '$rootUrl/${controller.dashboardController.profileData.image ?? ""}')
                        : NetworkImage(
                            '$rootUrl/${controller.dashboardController.profileData.image ?? ""}'),
                    placeholderBuilder: OctoPlaceholder.blurHash(
                      'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  width: percentageWidth * 50,
                  constraints: BoxConstraints(maxHeight: percentageWidth * 15),
                  decoration: BoxDecoration(
                    color: Color(0xffF2F6FF),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.zero,
                  child: TextField(
                    controller: controller.commentController,
                    maxLines: 10,
                    minLines: 1,
                    autofocus: false,
                    showCursor: true,
                    scrollPhysics: AlwaysScrollableScrollPhysics(),
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        filled: true,
                        fillColor: Get.theme.canvasColor,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(142, 153, 183, 0.4),
                              width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(142, 153, 183, 0.4),
                              width: 1.0),
                        ),
                        hintText: "${stctrl.lang["Add Comment"]}",
                        hintStyle: Get.textTheme.titleMedium),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  controller.submitComment(controller.myCourseDetails.value.id,
                      controller.commentController.value.text);
                },
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                      color: Get.theme.primaryColor, shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 2.0),
                    child: Transform.rotate(
                      angle: math.pi / 4,
                      child: Icon(
                        FontAwesomeIcons.locationArrow,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  showDownloadAlertDialog(BuildContext context, String title, String fileUrl,
      DownloadController downloadController) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "${stctrl.lang["No"]}",
      ),
      onPressed: () {
        context.loaderOverlay.hide();
        Navigator.of(context).pop();
      },
    );
    Widget yesButton = TextButton(
      child: Text(
        "${stctrl.lang["Download"]}",
      ),
      onPressed: () async {
        context.loaderOverlay.hide();
        Navigator.of(Get.overlayContext!).pop();
        downloadController.downloadFile(fileUrl, title, context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "$title",
        style: Get.textTheme.titleMedium,
      ),
      content: Text("${stctrl.lang["Would you like to download this file?"]}"),
      actions: [
        cancelButton,
        yesButton,
      ],
    );

    // show the dialog
    return alert;
  }

  Future<void> checkPermissions(BuildContext context) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    if (statuses[Permission.storage] != statuses[PermissionStatus.granted]) {
      try {
        statuses = await [
          Permission.storage,
        ].request();
      } on Exception {
        debugPrint("Error");
      }

      if (statuses[Permission.storage] == statuses[PermissionStatus.granted])
        print("write  permission ok");
      else
        permissionsDenied(context);
    } else {
      print("write permission ok");
    }
  }

  void permissionsDenied(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext _context) {
          return SimpleDialog(
            title: Text("${stctrl.lang["Permission denied"]}"),
            children: <Widget>[
              Container(
                padding:
                    EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
                child: Text(
                  "${stctrl.lang["You must grant all permission to use this application"]}",
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              )
            ],
          );
        });
  }

  Future generateVdoCipherOtp(url) async {
    Uri apiUrl = Uri.parse('https://dev.vdocipher.com/api/videos/$url/otp');

    var response = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Apisecret $vdoCipherApiKey'
      },
    );

    var decoded = jsonDecode(response.body);
    return decoded;
  }

  String getExtention(String url) {
    var parts = url.split("/");
    return parts[parts.length - 1];
  }
}
