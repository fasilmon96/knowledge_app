import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final questionProvider = FutureProvider.autoDispose((ref) async {
  final response = await http.get(
    Uri.parse("http://192.168.141.150:5000/allQuestion"),
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Failed to Load question");
  }
});

class QuestionIndexNotifier extends StateNotifier<int> {
  QuestionIndexNotifier() : super(0);

  void showNextQuestion(int totalQuestion) {
    if (state < totalQuestion - 1) {
      state++;
    }
  }
  void resetData(){
    state =0;
  }
}

class ChangeColor extends ChangeNotifier {
  int index = -1;
  void optionChange(int selectedIndex) {
    index = selectedIndex;
    notifyListeners(); // Always notify, even if already answered
  }
  void reset() {
    index = -1;
    notifyListeners();
  }
}



final questionIndexNotifierProvider =
    StateNotifierProvider<QuestionIndexNotifier, int>(
      (ref) => QuestionIndexNotifier(),
    );



final changeColorProvider  = ChangeNotifierProvider( (ref) {
  return ChangeColor();
},);