import 'package:dio/dio.dart';

class QuizApi {
  Future<dynamic> quizRepo() async {
    var response = await Dio().get(
      "https://quizapi.io/api/v1/questions?apiKey=F9MkiwyCJhWufKoAscZGQwTdNdB4RjzNBO2jEUQQ&category=linux&difficulty=Hard&limit=20",
    );
    return response;
  }
}
