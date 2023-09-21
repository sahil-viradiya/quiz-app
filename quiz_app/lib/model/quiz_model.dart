// To parse this JSON data, do
//
//     final quizModel = quizModelFromJson(jsonString);

import 'dart:convert';

List<QuizModel> quizModelFromJson(String str) =>
    List<QuizModel>.from(json.decode(str).map((x) => QuizModel.fromJson(x)));

String quizModelToJson(List<QuizModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class QuizModel {
  int? id;
  String? question;
  dynamic description;
  dynamic answers;
  String? multipleCorrectAnswers;
  CorrectAnswers? correctAnswers;
  String? correctAnswer;
  dynamic explanation;
  dynamic tip;
  List<Tag>? tags;
  Category? category;
  Difficulty? difficulty;
  bool? rightAns;

  QuizModel({
    this.id,
    this.question,
    this.description,
    this.answers,
    this.multipleCorrectAnswers,
    this.correctAnswers,
    this.correctAnswer,
    this.explanation,
    this.tip,
    this.tags,
    this.category,
    this.difficulty,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) => QuizModel(
        id: json["id"],
        question: json["question"],
        description: json["description"],
        answers: json["answers"],
        multipleCorrectAnswers: json["multiple_correct_answers"],
        correctAnswers: json["correct_answers"] == null
            ? null
            : CorrectAnswers.fromJson(json["correct_answers"]),
        correctAnswer: json["correct_answer"],
        explanation: json["explanation"],
        tip: json["tip"],
        tags: json["tags"] == null
            ? []
            : List<Tag>.from(json["tags"]!.map((x) => Tag.fromJson(x))),
        category: categoryValues.map[json["category"]]!,
        difficulty: difficultyValues.map[json["difficulty"]]!,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "description": description,
        "answers": answers?.toJson(),
        "multiple_correct_answers": multipleCorrectAnswers,
        "correct_answers": correctAnswers?.toJson(),
        "correct_answer": correctAnswer,
        "explanation": explanation,
        "tip": tip,
        "tags": tags == null
            ? []
            : List<dynamic>.from(tags!.map((x) => x.toJson())),
        "category": categoryValues.reverse[category],
        "difficulty": difficultyValues.reverse[difficulty],
      };
}

enum Category { BASH, KUBERNETES, LINUX, PHP }

final categoryValues = EnumValues({
  "BASH": Category.BASH,
  "Kubernetes": Category.KUBERNETES,
  "Linux": Category.LINUX,
  "PHP": Category.PHP
});

class CorrectAnswers {
  String? answerACorrect;
  String? answerBCorrect;
  String? answerCCorrect;
  String? answerDCorrect;
  String? answerECorrect;
  String? answerFCorrect;

  CorrectAnswers({
    this.answerACorrect,
    this.answerBCorrect,
    this.answerCCorrect,
    this.answerDCorrect,
    this.answerECorrect,
    this.answerFCorrect,
  });

  factory CorrectAnswers.fromJson(Map<String, dynamic> json) => CorrectAnswers(
        answerACorrect: json["answer_a_correct"],
        answerBCorrect: json["answer_b_correct"],
        answerCCorrect: json["answer_c_correct"],
        answerDCorrect: json["answer_d_correct"],
        answerECorrect: json["answer_e_correct"],
        answerFCorrect: json["answer_f_correct"],
      );

  Map<String, dynamic> toJson() => {
        "answer_a_correct": answerACorrect,
        "answer_b_correct": answerBCorrect,
        "answer_c_correct": answerCCorrect,
        "answer_d_correct": answerDCorrect,
        "answer_e_correct": answerECorrect,
        "answer_f_correct": answerFCorrect,
      };
}

enum Difficulty { HARD }

final difficultyValues = EnumValues({"Hard": Difficulty.HARD});

class Tag {
  Category? name;

  Tag({
    this.name,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        name: categoryValues.map[json["name"]]!,
      );

  Map<String, dynamic> toJson() => {
        "name": categoryValues.reverse[name],
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
