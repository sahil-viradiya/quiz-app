

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/quiz_cubit.dart';
import 'package:quiz_app/quiz_state.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int correctAnswers = 0;
  int? selectedIndex;
  List opction = ['a', 'b', 'c', 'd', 'e', 'f'];

  @override
  void initState() {
    super.initState();
  }



  void _showScoreCard(state) {
    showDialog(
      context: context,
      builder: (context) {
        final totalQuestions = state.list.length;
        final wrongAnswers = totalQuestions - correctAnswers;
        final score =
            (correctAnswers / totalQuestions * 100).toStringAsFixed(2);
        final result = double.parse(score) >= 70 ? 'Pass' : 'Fail';
        return AlertDialog(
          title: const Text('Quiz Completed'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Total questions: $totalQuestions'),
              Text('Correct answers: $correctAnswers'),
              Text('Wrong answers: $wrongAnswers'),
              Text('Score: $score%'),
              Text('Result: $result'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(59, 37, 161, 1),
      appBar: AppBar(
        title: const Text('Quiz App'),
      ),
      body: BlocConsumer<QuizCubit, QuizState>(
        listener: (context, state) {
          if (state is Failed) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.msg ?? "")));
          }
        },
        builder: (context, state) {
          if (state is Init) {
            BlocProvider.of<QuizCubit>(context).quiz();
          }
          return SingleChildScrollView(
            child: Center(
              child: state is Loading
                  ? const CircularProgressIndicator()
                  : state is Loaded
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 80,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(6),
                                itemCount: state.list.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.all(6),
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color:
                                            state.list[index].rightAns == null
                                                ? Colors.white
                                                : state.list[index].rightAns!
                                                    ? Colors.white
                                                    : Colors.red,
                                      ),
                                      color: state.list[index].rightAns == null
                                          ? Colors.white
                                          : Colors.transparent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: index <= currentQuestionIndex &&
                                              state.list[index].rightAns != null
                                          ? Icon(
                                              state.list[index].rightAns!
                                                  ? Icons.done
                                                  : Icons.close,
                                              color: state.list[index].rightAns!
                                                  ? Colors.white
                                                  : Colors.red,
                                            )
                                          : Text("${index + 1}"),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Card(
                              margin: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Question ${currentQuestionIndex + 1} of ${state.list.length}',
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        color: Color.fromRGBO(59, 37, 161, 1),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      state.list[currentQuestionIndex]
                                              .question ??
                                          "",
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        color: Color.fromRGBO(59, 37, 161, 1),
                                      ),
                                    ),
                                  ),
                                  for (var i = 0;
                                      i <
                                          state.list[currentQuestionIndex]
                                              .answers.length;
                                      i++)
                                    state.list[currentQuestionIndex].answers[
                                                'answer_${opction[i]}'] ==
                                            null
                                        ? const SizedBox()
                                        : GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedIndex = i;
                                              });
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              margin: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: selectedIndex == i
                                                    ? Colors.blueAccent
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                "${state.list[currentQuestionIndex].answers['answer_${opction[i]}']}",
                                                style: const TextStyle(
                                                  color: Color.fromRGBO(
                                                      59, 37, 161, 1),
                                                ),
                                              ),
                                            ),
                                          ),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(horizontal: 44),
                              child: ElevatedButton(
                                onPressed: selectedIndex == null
                                    ? null
                                    : () {
                                        if (state.list[currentQuestionIndex]
                                                .correctAnswer ==
                                            'answer_${opction[selectedIndex!]}') {
                                          state.list[currentQuestionIndex]
                                              .rightAns = true;

                                          correctAnswers++;
                                        } else {
                                          state.list[currentQuestionIndex]
                                              .rightAns = false;
                                        }
                                        setState(() {
                                          if (currentQuestionIndex ==
                                              state.list.length - 1) {
                                            _showScoreCard(state);
                                          } else {
                                            currentQuestionIndex++;
                                          }
                                          selectedIndex = null;
                                        });
                                      },
                                child: const Text("Submit"),
                              ),
                            )
                          ],
                        )
                      : const CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
