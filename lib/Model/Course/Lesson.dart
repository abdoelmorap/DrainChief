import '../Quiz/Quiz.dart';

class Lesson {
  Lesson({
    this.id,
    this.courseId,
    this.chapterId,
    this.quizId,
    this.name,
    this.description,
    this.videoUrl,
    this.host,
    this.duration,
    this.isLock,
    this.isQuiz,
    this.quiz,
  });

  dynamic id;
  dynamic courseId;
  dynamic chapterId;
  dynamic quizId;
  String? name;
  String? description;
  String? videoUrl;
  String? host;
  String? duration;
  dynamic isLock;
  dynamic isQuiz;
  List<Quiz>? quiz;

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
        id: json["id"],
        courseId: json["course_id"],
        chapterId: json["chapter_id"],
        quizId: json["quiz_id"],
        name: json["name"],
        description: json["description"],
        videoUrl: json["video_url"],
        host: json["host"],
        duration: json["duration"],
        isLock: int.parse(json["is_lock"].toString()),
        isQuiz: int.parse(json["is_quiz"].toString()),
        quiz: json["quiz"] == null
            ? null
            : List<Quiz>.from(json["quiz"].map((x) => Quiz.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_id": courseId,
        "chapter_id": chapterId,
        "quiz_id": quizId,
        "name": name,
        "description": description,
        "video_url": videoUrl,
        "host": host,
        "duration": duration,
        "is_lock": isLock,
        "is_quiz": isQuiz,
        "quiz": List<dynamic>.from(quiz?.map((x) => x.toJson()) ?? []),
      };
}