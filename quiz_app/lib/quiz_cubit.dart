// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/model/quiz_model.dart';
import 'package:quiz_app/quiz_repo.dart';
import 'package:quiz_app/quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit() : super(Init());

  QuizApi repo = QuizApi();

  quiz() async {
    try {
      emit(Loading());
      var response = await repo.quizRepo();
      if (response != null) {
        print("response is coming");

        List<QuizModel> list = response.data.map<QuizModel>((json) {
          return QuizModel.fromJson(json);
        }).toList();

        emit(Loaded(list));
      } else {
        print("response is null");
      }

      // print(response);
    } catch (e) {
      DioException error = e as DioException;

      if (error.type == DioExceptionType.unknown) {
        emit(Failed(msg: "Connection Failed"));
      } else {
        emit(Failed(msg: "${error.message}"));
      }
    }
  }
}
