// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Project imports:
import 'package:lms_flutter_app/Controller/quiz_controller.dart';
import 'package:lms_flutter_app/Model/Quiz/Assign.dart';
import 'package:lms_flutter_app/Model/Quiz/QuestionResultModel.dart';
import 'package:lms_flutter_app/Service/RemoteService.dart';
import 'package:lms_flutter_app/Views/MyCourseClassQuiz/MyQuiz/my_quiz_result_summary.dart';

import '../Model/Quiz/Quiz.dart';

class QuestionController extends GetxController
    with GetTickerProviderStateMixin {
  final QuizController quizController = Get.put(QuizController());

  AnimationController? _animationController;
  Animation? _animation;

  Animation? get animation => this._animation;

  PageController? _pageController;

  PageController? get pageController => this._pageController;

  var questions = <Assign>[].obs;

  var quiz = Quiz().obs;

  bool _isAnswered = false;

  bool get isAnswered => this._isAnswered;

  CheckboxModal? _correctAns;

  CheckboxModal? get correctAns => this._correctAns;

  CheckboxModal? _selectedAns;

  CheckboxModal? get selectedAns => this._selectedAns;

  RxInt _questionNumber = 1.obs;

  RxInt get questionNumber => this._questionNumber;

  int _numOfCorrectAns = 0;

  int get numOfCorrectAns => this._numOfCorrectAns;

  var questionTime = 1.obs;

  var currentQuestion = Assign().obs;

  var isSelected = false.obs;

  GetStorage userToken = GetStorage();

  var tokenKey = "token";

  var submitSingleAnswer = false.obs;

  var questionResult = QuizResultModel().obs;

  var quizResultLoading = false.obs;

  RxList<bool> answered = <bool>[].obs;

  var types = [].obs;

  @override
  void onInit() {
    _animationController = AnimationController(
        duration: Duration(seconds: questionTime.value * 60), vsync: this);
    super.onInit();
  }

  void startController(quizParam) {
    questionNumber.value = 1;
    answered.clear();
    types.clear();
    quiz.value = quizParam;
    questionTime.value = quiz.value.questionTime ?? 0;
    if (quiz.value.randomQuestion == 1) {
      // Randomize Question
      questions.value = (quiz.value.assign?..shuffle())!;
    } else {
      questions.value = quiz.value.assign ?? [];
    }
    questions.forEach((element) {
      answered.add(false);
      types.add(element.questionBank?.type);
    });
    currentQuestion.value = quiz.value.assign!.first;
    _animationController = AnimationController(
        duration: Duration(seconds: questionTime.value * 60), vsync: this);
    _animation = StepTween(begin: questionTime.value * 60, end: 0)
        .animate(_animationController as Animation<double>)
      ..addListener(() {
        update();
      });
    if (quiz.value.questionTimeType == 0) {
      _animationController?.forward().whenComplete(() {
        skipPress(0);
      });
    } else {
      _animationController?.forward().whenComplete(finalSubmit);
    }

    if (_questionNumber.value == quiz.value.assign?.length) {
      lastQuestion.value = true;
    } else {
      lastQuestion.value = false;
    }

    _pageController = PageController();
  }

  @override
  void onClose() {
    super.onClose();
    _animationController?.dispose();
    _pageController?.dispose();
  }

  Future finalSubmit() async {
    _animationController?.stop();
    await questionResultPreview(quizController.quizStart.value.data?.id, true)
        .then((value) {
      _animationController?.stop();
      // Get.back();
      // Get.to(() => QuizResultScreen());
      Get.to(() => MyQuizResultSummary());
    });
  }

  var checkSelectedIndex = 0.obs;
  var lastQuestion = false.obs;

  var color = Colors.white.obs;

  void questionSelect(index) {
    currentQuestion.value = quiz.value.assign![index];

    _pageController?.animateToPage(index,
        curve: Curves.easeInOut, duration: Duration(milliseconds: 200));
    if (quiz.value.questionTimeType == 0) {
      // print("ZERO Q TYPE => ${quiz.value.questionTimeType}");
      _animationController?.reset();
      _animationController?.forward().whenComplete(() {
        skipPress(index);
      });
    } else {
      // print("ONE Q TYPE => ${quiz.value.questionTimeType}");
    }
  }

  bool checkSelected(index) {
    return currentQuestion.value == quiz.value.assign?[index] ? true : false;
  }

  Future skipPress(index) async {
    if (_questionNumber.value != quiz.value.assign?.length) {
      currentQuestion.value = quiz.value.assign?[index + 1] ?? Assign();
      if (quiz.value.showResultEachSubmit == 1) {
        Future.delayed(Duration(seconds: 3), () {
          _pageController?.nextPage(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
          if (quiz.value.questionTimeType == 0) {
            _animationController?.reset();
            _animationController?.forward().whenComplete(() {
              skipPress(index);
            });
          }
        });
      } else {
        _pageController?.nextPage(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
        if (quiz.value.questionTimeType == 0) {
          _animationController?.reset();
          _animationController?.forward().whenComplete(() {
            skipPress(index);
          });
        }
      }
    } else {
      await questionResultPreview(quizController.quizStart.value.data?.id, true)
          .then((value) {
        _animationController?.stop();
        // Get.back();
        // Get.to(() => QuizResultScreen());
        Get.to(() => MyQuizResultSummary());
      });
    }
  }

  void singleDone() {
    questionTime.value = quiz.value.questionTime ?? 0;
    currentQuestion.value = quiz.value.assign?[questionNumber.value] ?? Assign();
    _pageController?.nextPage(
        duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  void continuePress() {}

  void submitPress() {}

  void updateTheQnNum(int index) {
    currentQuestion.value = quiz.value.assign?[index] ?? Assign();
    checkSelected(index);
    _questionNumber.value = index + 1;
    if (_questionNumber.value == quiz.value.assign?.length) {
      lastQuestion.value = true;
    } else {
      lastQuestion.value = false;
    }
  }

  Future<bool> singleSubmit(Map data, int index) async {
    try {
      var returnValue = false;
      String token = await userToken.read(tokenKey);
      submitSingleAnswer(true);
      await RemoteServices.singleAnswerSubmit(token: token, data: data)
          .then((value) async {
        if (value) {
          answered[index] = true;
          submitSingleAnswer(false);
          returnValue = true;
          return returnValue;
        } else {
          answered[index] = false;
          submitSingleAnswer(false);
          returnValue = false;
          return returnValue;
        }
      });
      return returnValue;
    } finally {
      submitSingleAnswer(false);
    }
  }

  Future questionResultPreview(int quizStartId, bool isPreview) async {
    quizResultLoading(true);
    await finalQuizSubmit(quizStartId).then((value) async {
      try {
        String token = await userToken.read(tokenKey);

        await RemoteServices.questionResult(
                token: token, quizResultId: quizStartId)
            .then((value) async {
          questionResult.value = value ?? QuizResultModel();
          if (isPreview) {
            await quizController.getMyQuizDetails();
          }
        });

        return questionResult.value;
      } finally {
        quizResultLoading(false);
      }
    });
  }

  Future getQuizResultPreview(int quizStartId) async {
    try {
      String token = await userToken.read(tokenKey);
      quizResultLoading(true);
      await RemoteServices.questionResult(
              token: token, quizResultId: quizStartId)
          .then((value) async {
        questionResult.value = value ?? QuizResultModel();
      });
      return questionResult.value;
    } finally {
      quizResultLoading(false);
    }
  }

  Future<bool> finalQuizSubmit(int quizStartId) async {
    try {
      Map data = {
        "quiz_test_id": quizStartId,
        "type": types,
      };
      String token = await userToken.read(tokenKey);
      await RemoteServices.finalQuizSubmit(
          token: token, quizStartId: quizStartId, data: data);
      return true;
    } finally {}
  }

  String getTimeStringFromDouble(double value) {
    if (value < 0) return 'Invalid Value';
    int flooredValue = value.floor();
    double decimalValue = value - flooredValue;
    String hourValue = getHourString(flooredValue);
    String minuteString = getMinuteString(decimalValue);

    return '$hourValue:$minuteString';
  }

  String getMinuteString(double decimalValue) {
    return '${(decimalValue * 60).toInt()}'.padLeft(2, '0');
  }

  String getHourString(int flooredValue) {
    return '${flooredValue % 24}'.padLeft(2, '0');
  }
}

class CheckboxModal {
  String? title;
  bool? value;
  int? id;
  int? status;

  CheckboxModal({this.title, this.value, this.id, this.status});
}
