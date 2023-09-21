

import 'package:quiz_app/model/quiz_model.dart';

abstract class QuizState {}

class Init extends QuizState {}

class Loading extends QuizState {}

class Loaded extends QuizState {
  List<QuizModel> list;
  Loaded(this.list);
}

class Failed extends QuizState {
  String? msg;
  Failed({this.msg});
}
