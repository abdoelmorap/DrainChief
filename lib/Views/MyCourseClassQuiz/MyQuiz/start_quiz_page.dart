// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:

import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/question_controller.dart';
import 'package:lms_flutter_app/Model/Course/CourseMain.dart';
import 'package:lms_flutter_app/Model/Quiz/Assign.dart';
import 'package:lms_flutter_app/Model/Quiz/QuestionMu.dart';
import 'package:octo_image/octo_image.dart';

import '../../../utils/custom_dialog.dart';

class StartQuizPage extends StatefulWidget {
  final CourseMain? getQuizDetails;

  StartQuizPage({this.getQuizDetails});

  @override
  _StartQuizPageState createState() => _StartQuizPageState();
}

class _StartQuizPageState extends State<StartQuizPage>
    with WidgetsBindingObserver {
  QuestionController _questionController=Get.put(QuestionController());

  int appInBackground = 0;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
    // Get.delete<QuestionController>();
    // _questionController = Get.put(QuestionController());
    _questionController.startController(widget.getQuizDetails?.quiz);
    loadin();
  }

  @override
  void dispose() {
    Get.delete<QuestionController>();
    print('dispose QuestionController');

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _showQuizEndDialog(BuildContext ctx) {
    showDialog(
        context: context,
        builder: (ctx) {
          return CustomAlertDialog(
            titleText: "${stctrl.lang['Do you want to leave the Quiz?']}",
            onTapYes: () async {
              Navigator.of(ctx).pop();
              final _questionController = Get.find<QuestionController>();

              await _questionController.finalSubmit();
            },
            onTapNo: () {
              Navigator.of(ctx).pop();
            },
          );
        });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (mounted) {
      final _questionController = Get.find<QuestionController>();

      if (state == AppLifecycleState.inactive ||
          state == AppLifecycleState.detached) return;

      final isBackground = state == AppLifecycleState.paused;
      if (isBackground) {
        appInBackground++;
      }

      print(appInBackground);

      final isResumed = state == AppLifecycleState.resumed;

      final timeCounts =
          _questionController.quiz.value.losingFocusAcceptanceNumber ?? 5;

      if (isResumed) {
        if (appInBackground >= timeCounts) {
          await _questionController.finalSubmit();
        }

        showDialog(
            context: context,
            builder: (ctx) {
              Future.delayed(Duration(seconds: 2), () {
                Navigator.pop(ctx);
              });
              return CustomAlertDialog(
                titleText: "${stctrl.lang['Warning']}",
                color: Colors.red,
                content: Text(
                  "${stctrl.lang['You have been out of Quiz']} $appInBackground ${stctrl.lang['times']} ${appInBackground >= timeCounts ? ", ${stctrl.lang['Your answer has been submitted']}." : ""}",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                ),
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showQuizEndDialog(context);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(Get.width, 100),
            child: AppBar(
              backgroundColor: Color(0xff18294d),
              centerTitle: false,
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    alignment: Alignment.centerLeft,
                    width: 80,
                    height: 30,
                    child: Image.asset(
                      'images/$appLogo',
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Row(
                        children: [
                          Container(
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios_sharp,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                _showQuizEndDialog(context);
                              },
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _questionController.quiz.value
                                        .title?['${stctrl.code.value}'] ??
                                    "",
                                style: context.textTheme.titleMedium
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: loading
              ? Text('data-------->')
              : Obx(() {
                  if (_questionController.quizResultLoading.value) {
                    return Stack(
                      children: [
                        Container(
                          color: Color(0xff18294d),
                          width: Get.width,
                          height: Get.height,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(child: CircularProgressIndicator()),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "${stctrl.lang["Quiz Result Processing. Please wait"]}",
                              style: Get.textTheme.titleMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        color: Color(0xff18294d),
                        width: Get.width,
                        height: Get.height,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(
                                  () => Text.rich(
                                    TextSpan(
                                      text: "${stctrl.lang["Question"]}"
                                          " ${_questionController.questionNumber.value}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(color: Colors.white),
                                      children: [
                                        TextSpan(
                                          text:
                                              "/${_questionController.quiz.value.assign?.length}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                TimerWidget(),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.0),
                          QuestionSelectorWidget(),
                          SizedBox(height: 10.0),
                          Expanded(
                            child: PageView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              controller: _questionController.pageController,
                              onPageChanged:
                                  _questionController.updateTheQnNum,
                              itemCount: _questionController.questions.length,
                              itemBuilder: (context, index) {
                                return QuestionCard(
                                  assign:
                                      _questionController.questions[index] ??
                                          Assign(),
                                  index: index,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
        ),
      ),
    );
  }

  bool loading = true;

  void loadin() async {
    await 2000.milliseconds.delay();
    setState(() {
      loading = false;
    });
  }
}

class QuestionSelectorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuestionController>(
        // init: QuestionController(),
        builder: (qnController) {
      return Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView.separated(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final color = qnController.checkSelected(index)
                  ? Get.theme.primaryColor
                  : Colors.white;
              return GestureDetector(
                onTap: () {
                  qnController.questionSelect(index);
                },
                child: qnController.answered[index] == true
                    ? CircleAvatar(
                        backgroundColor: Get.theme.primaryColor,
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                        ))
                    : CircleAvatar(
                        backgroundColor: color,
                        child: Text(
                          "${index + 1}",
                          style: TextStyle(
                            color: qnController.checkSelected(index)
                                ? Colors.white
                                : Colors.black,
                            fontWeight: qnController.checkSelected(index)
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
              );
            },
            separatorBuilder: (context, index) {
              return Container(
                width: 5.0,
              );
            },
            itemCount: qnController.quiz.value.assign?.length ?? 0),
      );
    });
  }
}

class QuestionCard extends StatefulWidget {
  QuestionCard({this.assign, this.index});

  final Assign? assign;
  final int? index;

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController shortAnsCtrl = TextEditingController();

  final TextEditingController longAnsCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  List<CheckboxModal> checkBoxList = [];
  List<int> assignIds = [];

  onItemClicked(CheckboxModal ckbItem) {
    setState(() {
      ckbItem.value = !ckbItem.value!;
    });
    if (ckbItem.value!) {
      assignIds.add(ckbItem.id!);
    } else {
      assignIds.remove(ckbItem.id);
    }
  }

  @override
  void initState() {
    if (widget.assign?.questionBank?.type == "M") {
      widget.assign?.questionBank?.questionMu?.forEach((element) {
        checkBoxList.add(CheckboxModal(
            title: element.title,
            id: element.id,
            value: false,
            status: element.status));
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<QuestionController>(
        // init: QuestionController(),
        builder: (qnController) {
      if (widget.assign?.questionBank?.type == "M") {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          padding: EdgeInsets.all(22.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Stack(
            children: [
              ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: HtmlWidget(
                      '''${widget.assign?.questionBank?.question ?? ""}''',
                      textStyle: Get.textTheme.titleSmall
                          ?.copyWith(color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 10),
                  ...checkBoxList.map((item) {
                    return ListTile(
                      onTap: () => qnController.answered[widget.index ?? 0]
                          ? qnController.quiz.value.questionReview == 1
                              ? onItemClicked(item)
                              : null
                          : onItemClicked(item),
                      contentPadding: EdgeInsets.zero,
                      leading: Checkbox(
                        value: item.value,
                        onChanged: (value) {
                          print('---->>>>>>> ${widget.index}');
                          print('---->>>>>>> ${qnController.answered.length}');
                          print(
                              '---->>>>>>> ${qnController.answered[widget.index ?? 0]}');
                          // qnController.answered[widget.index ?? 0]
                          //     ? qnController.quiz.value.questionReview == 1
                          //         ? onItemClicked(item)
                          //         : null
                          //     : onItemClicked(item);
                          qnController.answered[widget.index ?? 0]
                              ? qnController.quiz.value.questionReview == 1
                                  ? onItemClicked(item)
                                  : null
                              : onItemClicked(item);
                        },
                        checkColor: Colors.white,
                        activeColor: Get.theme.primaryColor,
                      ),
                      trailing:
                          qnController.quiz.value.showResultEachSubmit == 1
                              ? qnController.answered[widget.index ?? 0] == true
                                  ? item.status == 1
                                      ? Icon(
                                          Icons.check_circle_outline,
                                          color: Colors.green,
                                        )
                                      : Icon(
                                          Icons.cancel_outlined,
                                          color: Colors.red,
                                        )
                                  : SizedBox(
                                      width: 1,
                                      height: 1,
                                    )
                              : SizedBox(
                                  width: 1,
                                  height: 1,
                                ),
                      title: Transform.translate(
                          offset: Offset(-16, 0),
                          child: Text(
                            item.title ?? '',
                            style: Get.textTheme.titleMedium
                                ?.copyWith(color: Colors.black),
                          )),
                    );
                  }).toList(),
                  widget.assign?.questionBank?.image != null
                      ? OctoImage(
                          fit: BoxFit.cover,
                          width: 40,
                          image: NetworkImage(
                              '$rootUrl/${widget.assign?.questionBank?.image}'),
                          placeholderBuilder: OctoPlaceholder.blurHash(
                            'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                          ),
                        )
                      : Container(),
                  SizedBox(height: 50),
                ],
              ),
              ContinueSkipSubmitBtn(
                qnController: qnController,
                index: widget.index ?? 0,
                showEachSubmit:
                    qnController.quiz.value.showResultEachSubmit == 1
                        ? true
                        : false,
                correctAnswer: widget.assign?.questionBank?.questionMu ?? [],
                type: "M",
                assign: widget.assign ?? Assign(),
                data: {
                  "type": "M",
                  "assign_id": widget.assign?.id,
                  "quiz_test_id":
                      qnController.quizController.quizStart.value.data?.id,
                  "ans": assignIds,
                },
              ),
            ],
          ),
        );
      } else if (widget.assign?.questionBank?.type == "S") {
        return Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            padding: EdgeInsets.all(22.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Stack(
              children: [
                ListView(
                  children: [
                    HtmlWidget(
                      '''
                      ${widget.assign?.questionBank?.question ?? "____"}
                      ''',
                      textStyle: Get.textTheme.titleSmall
                          ?.copyWith(color: Colors.black),
                    ),
                    SizedBox(height: 20.0 / 2),
                    TextFormField(
                      controller: shortAnsCtrl,
                      maxLines: 2,
                      cursorColor: Get.theme.primaryColor,
                      style: Get.textTheme.titleSmall
                          ?.copyWith(color: Colors.black),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Get.theme.primaryColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Get.theme.primaryColor,
                          ),
                        ),
                      ),
                      enabled: !qnController.answered[widget.index ?? 0]
                          ? true
                          : false,
                      validator: (value) {
                        if (value?.length == 0) {
                          return "${stctrl.lang["Please type something"]}";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ],
                ),
                ContinueSkipSubmitBtn(
                  qnController: qnController,
                  index: widget.index ?? 0,
                  showEachSubmit:
                      qnController.quiz.value.showResultEachSubmit == 1
                          ? true
                          : false,
                  formKey: _formKey,
                  type: "S",
                  assign: widget.assign ?? Assign(),
                  data: {
                    "type": "S",
                    "assign_id": widget.assign?.id,
                    "quiz_test_id":
                        qnController.quizController.quizStart.value.data?.id,
                    "ans": shortAnsCtrl.text,
                  },
                ),
              ],
            ),
          ),
        );
      } else if (widget.assign?.questionBank?.type == "L") {
        return Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            padding: EdgeInsets.all(22.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Stack(
              children: [
                ListView(
                  children: [
                    HtmlWidget(
                      '''
                      ${widget.assign?.questionBank?.question ?? "____"}
                      ''',
                      textStyle: Get.textTheme.titleSmall
                          ?.copyWith(color: Colors.black),
                    ),
                    SizedBox(height: 20.0 / 2),
                    TextFormField(
                      controller: longAnsCtrl,
                      maxLines: 5,
                      cursorColor: Get.theme.primaryColor,
                      style: Get.textTheme.titleSmall
                          ?.copyWith(color: Colors.black),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Get.theme.primaryColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Get.theme.primaryColor,
                          ),
                        ),
                      ),
                      enabled: !qnController.answered[widget.index ?? 0]
                          ? true
                          : false,
                      validator: (value) {
                        if (value?.length == 0) {
                          return "${stctrl.lang["Please type something"]}";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ],
                ),
                ContinueSkipSubmitBtn(
                  qnController: qnController,
                  index: widget.index ?? 0,
                  showEachSubmit:
                      qnController.quiz.value.showResultEachSubmit == 1
                          ? true
                          : false,
                  formKey: _formKey,
                  type: "L",
                  assign: widget.assign ?? Assign(),
                  data: {
                    "type": "L",
                    "assign_id": widget.assign?.id,
                    "quiz_test_id":
                        qnController.quizController.quizStart.value.data?.id,
                    "ans": longAnsCtrl.text,
                  },
                ),
              ],
            ),
          ),
        );
      }
      return Container();
    });
  }

  @override
  bool get wantKeepAlive => true;
}

class ContinueSkipSubmitBtn extends StatelessWidget {
  ContinueSkipSubmitBtn({
    this.qnController,
    this.index,
    this.data,
    this.showEachSubmit,
    this.correctAnswer,
    this.formKey,
    this.type,
    this.checkBoxList,
    this.assign,
  });

  final QuestionController? qnController;
  final int? index;
  final Map? data;
  final bool? showEachSubmit;
  final List<QuestionMu>? correctAnswer;
  final GlobalKey<FormState>? formKey;
  final String? type;
  final List<CheckboxModal>? checkBoxList;
  final Assign? assign;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      bottom: 0,
      top: 0,
      child: qnController!.submitSingleAnswer.value
          ? Align(
              alignment: Alignment.bottomCenter,
              child: CircularProgressIndicator(
                color: Get.theme.primaryColor,
              ))
          : Align(
              alignment: Alignment.bottomCenter,
              child: qnController!.lastQuestion.value
                  ? ElevatedButton(
                      onPressed: () async {
                        if ((type == 'S' || type == 'L') && formKey != null) {
                          if (formKey!.currentState!.validate()) {
                            await qnController
                                ?.singleSubmit(data ?? Map(), index ?? 0)
                                .then((value) {
                              if (value) {
                                qnController?.skipPress(index);
                              } else {
                                Get.snackbar(
                                  "${stctrl.lang["Error"]}",
                                  "${stctrl.lang["Error submitting answer"]}",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red[700],
                                  colorText: Colors.black,
                                  borderRadius: 5,
                                  duration: Duration(seconds: 3),
                                );
                              }
                            });
                          }
                        } else {
                          if (data?['ans'].length == 0) {
                            Get.snackbar(
                              "${stctrl.lang["Error"]}",
                              "${stctrl.lang["Please select an option"]}",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.amber[700],
                              colorText: Colors.black,
                              borderRadius: 5,
                              duration: Duration(seconds: 3),
                            );
                          } else {
                            await qnController
                                ?.singleSubmit(data ?? Map(), index ?? 0)
                                .then((value) {
                              if (value) {
                                qnController?.skipPress(index);
                              } else {
                                Get.snackbar(
                                  "${stctrl.lang["Error"]}",
                                  "${stctrl.lang["Error submitting answer"]}",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red[700],
                                  colorText: Colors.black,
                                  borderRadius: 5,
                                  duration: Duration(seconds: 3),
                                );
                              }
                            });
                          }
                        }
                      },
                      child: Text(
                        "${stctrl.lang["Submit"]}",
                        style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if ((type == 'S' || type == 'L') &&
                                formKey != null) {
                              if (formKey!.currentState!.validate()) {
                                await qnController
                                    ?.singleSubmit(data ?? Map(), index ?? 0)
                                    .then((value) {
                                  if (value) {
                                    qnController?.skipPress(index);
                                  } else {
                                    Get.snackbar(
                                      "${stctrl.lang["Error"]}",
                                      "${stctrl.lang["Error submitting answer"]}",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red[700],
                                      colorText: Colors.black,
                                      borderRadius: 5,
                                      duration: Duration(seconds: 3),
                                    );
                                  }
                                });
                              }
                            } else {
                              if (data?['ans'].length == 0) {
                                Get.snackbar(
                                  "${stctrl.lang["Error"]}",
                                  "${stctrl.lang["Please select an option"]}",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.amber[700],
                                  colorText: Colors.black,
                                  borderRadius: 5,
                                  duration: Duration(seconds: 3),
                                );
                              } else {
                                await qnController
                                    ?.singleSubmit(data ?? Map(), index ?? 0)
                                    .then((value) {
                                  if (value) {
                                    qnController?.skipPress(index);
                                  } else {
                                    Get.snackbar(
                                      "${stctrl.lang["Error"]}",
                                      "${stctrl.lang["Error submitting answer"]}",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red[700],
                                      colorText: Colors.black,
                                      borderRadius: 5,
                                      duration: Duration(seconds: 3),
                                    );
                                  }
                                });
                              }
                            }
                          },
                          child: Text(
                            "${stctrl.lang["Continue"]}",
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            qnController?.skipPress(index);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: Text(
                            "${stctrl.lang["Skip Question"]}",
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }
}

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 35,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF3F4768), width: 3),
        borderRadius: BorderRadius.circular(5),
      ),
      child: GetBuilder<QuestionController>(
        // init: QuestionController(),
        builder: (controller) {
          Duration clockTimer = Duration(seconds: controller.animation?.value);
          Duration clockTimer2 =
              Duration(seconds: controller.questionTime.value * 60);
          String remainingTime =
              '${clockTimer.inMinutes.remainder(60).toString().padLeft(2, '0')}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';
          String totalTime =
              '${clockTimer2.inMinutes.remainder(60).toString().padLeft(2, '0')}:${clockTimer2.inSeconds.remainder(60).toString().padLeft(2, '0')}';
          return Stack(
            fit: StackFit.loose,
            children: [
              LayoutBuilder(
                builder: (context, constraints) => Container(
                  width: controller.animation?.value.toDouble(),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF46A0AE), Color(0xFF00FFCB)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0 / 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("$remainingTime/$totalTime"),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class TimerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuestionController>(
      // init: QuestionController(),
      builder: (controller) {
        Duration clockTimer =
            Duration(seconds: controller.animation?.value ?? 1);
        String remainingTime =
            '${clockTimer.inMinutes.remainder(60).toString().padLeft(2, '0')}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("$remainingTime" + " " + "${stctrl.lang["minute(s)"]}"),
            controller.quiz.value.questionTimeType == 1
                ? Text("${stctrl.lang["Left for the quiz"]}")
                : Text("${stctrl.lang["Left for this section"]}"),
          ],
        );
      },
    );
  }
}
