import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:lms_flutter_app/Controller/lesson_controller.dart';
import 'package:lms_flutter_app/Model/Course/Lesson.dart';
import 'package:lms_flutter_app/utils/widgets/connectivity_checker_widget.dart';
import 'package:pod_player/pod_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart' as YTBP;

class VideoPlayerPage extends StatefulWidget {
  final String? videoID;
  final Lesson? lesson;
  final String? source;
  final String? idUser;

  VideoPlayerPage(this.source, {this.videoID, this.lesson,this.idUser=""});

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  PodPlayerController? _podPlayerController;
   late YoutubePlayerController _controller;
   late YTBP.YoutubePlayerController _controllerYTBP;

   String idCode='';
  Timer? timer;

  double top=0;
  double btm=0;
  double right=0;
  double lft=0;
  final LessonController lessonController = Get.put(LessonController());

  String? video;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft
    ]);




// print( 'YTID'+ widget.videoID.toString());
    //  _controller = YoutubePlayerController.fromVideoId(
    //   videoId: '${YoutubePlayerController.convertUrlToId(widget.videoID.toString())}',
    //   autoPlay: true,
    //   params: const YoutubePlayerParams(      showControls: true,
    //     showFullscreenButton: true,    ),
    //
    // );
    _controllerYTBP = YTBP.YoutubePlayerController(
      initialVideoId: YoutubePlayerController.convertUrlToId(widget.videoID.toString()).toString(),
      flags: YTBP.YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

   if(      widget.source != "Youtube"){ytbPlayer();}
   loadCode();
    super.initState();
  }
  loadCode()async{  SharedPreferences preferences = await SharedPreferences.getInstance();

  idCode= (await preferences.getString("loda"))??'';
  timer = Timer.periodic(Duration(seconds: 15), (Timer t) => checkForNewSharedLists());

  // print('loda'+idCode);
  }
  checkForNewSharedLists(){
     top=Random(). nextInt(500)+.5;
     btm=Random(). nextInt(500)+.5;
     right=Random(). nextInt(500) +.5;
     lft=Random(). nextInt(500) +.5;
     setState(() {

     });
  }
void ytbPlayer() {
  _podPlayerController =
  PodPlayerController(

    playVideoFrom: PlayVideoFrom.network(
      '${widget.videoID}',
    ),
  )
    ..initialise()
    ..addListener(() async {
      if (_podPlayerController!.isInitialised) {
        if (_podPlayerController?.videoPlayerValue?.position ==
            _podPlayerController?.totalVideoLength) {
          if (widget.lesson != null) {
            await lessonController.updateLessonProgress(
                widget.lesson?.id, widget.lesson?.courseId, 1);
            Get.back();
          }
        }
      }
    });

  }
  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _podPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConnectionCheckerWidget(
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () async => false,
          child: SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      color: Colors.black,
                      child: Align(
                        alignment: Alignment.center,
                        child:
                   widget.source == "Youtube"
                      ?    YTBP.YoutubePlayer(
                     controller: _controllerYTBP,
                     showVideoProgressIndicator: true,
                     progressIndicatorColor: Colors.amber,
                     progressColors: YTBP.ProgressBarColors(
                       playedColor: Colors.amber,
                       handleColor: Colors.amberAccent,
                     ),
                     onReady: () {
                       // _controllerYTBP.addListener(listener);
                   },

                   ):
                   // YoutubePlayer(
                   //        controller: _controller,
                   //        aspectRatio: 16 / 9
                   //      ):
                        PodVideoPlayer(controller: _podPlayerController!),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    left: 5,
                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.cancel, color: Colors.white),
                    ),
                  ),
                  Positioned(child: Text(idCode,style: TextStyle(fontSize: 18,color: Colors.white),),   top: top,
                    left: lft,right: right,bottom: btm,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
    // return ConnectionCheckerWidget(
    //   child: SafeArea(
    //     child: WillPopScope(
    //       onWillPop: () async => false,
    //       child: YoutubePlayerBuilder(
    //         onExitFullScreen: () {
    //           SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    //         },
    //         onEnterFullScreen: () {
    //           SystemChrome.setPreferredOrientations(
    //               [DeviceOrientation.landscapeLeft]);
    //         },
    //         player: YoutubePlayer(
    //           controller: _controller,
    //           showVideoProgressIndicator: false,
    //           progressIndicatorColor: Colors.blueAccent,
    //           onReady: () {
    //             setState(() {
    //               _isPlayerReady = true;
    //             });
    //           },
    //           onEnded: (data) async {
    //             if (widget.lesson != null) {
    //               await lessonController
    //                   .updateLessonProgress(
    //                       widget.lesson.id, widget.lesson.courseId, 1)
    //                   .then((value) {
    //                 Get.back();
    //               });
    //             }
    //           },
    //         ),
    //         builder: (context, player) => SafeArea(
    //           child: Scaffold(
    //             body: Stack(
    //               children: [
    //                 Positioned.fill(
    //                   child: Container(
    //                     color: Colors.black,
    //                     child: Align(
    //                       alignment: Alignment.center,
    //                       child: FittedBox(fit: BoxFit.fill, child: player),
    //                     ),
    //                   ),
    //                 ),
    //                 Positioned(
    //                   top: 30,
    //                   left: 5,
    //                   child: IconButton(
    //                     onPressed: () => Get.back(),
    //                     icon: Icon(Icons.cancel, color: Colors.white),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
