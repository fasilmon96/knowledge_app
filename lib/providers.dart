import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:knowledge_app/totalscore.dart';

final questionProvider = FutureProvider.autoDispose((ref) async {
  final response = await http.get(
    Uri.parse("https://otpscreen-28454-default-rtdb.firebaseio.com/.json"),
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

class CountDownNotifier extends StateNotifier<int>{
     Timer ? timer;
     static const maxCount =10;
    CountDownNotifier() : super(maxCount);

    void startCountdown(BuildContext context,int length){
      timer?.cancel();
      state =maxCount;
      timer = Timer.periodic(Duration(seconds:1), (timer){
        if(state ==0){
          timer.cancel();
          Navigator.push(context,  MaterialPageRoute(builder: (context) => TotalScore(totalScore: length),));
        }else{
          state--;
        }

      });

    }
     void cancel(){
       timer?.cancel();
       if(state==0){
         timer?.cancel();
       }
     }
      @override
  void dispose() {
      timer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }
}

 class ScoreNotifier extends StateNotifier<int>{
    ScoreNotifier() : super(0);

    void incrementScore(){
      state++;
    }
    void resetIncrement(){
       state=0;
    }
 }


final questionIndexNotifierProvider =
    StateNotifierProvider<QuestionIndexNotifier, int>(
      (ref) => QuestionIndexNotifier(),
    );



final changeColorProvider  = ChangeNotifierProvider( (ref) {
  return ChangeColor();
},);

final countdownProvider = StateNotifierProvider<CountDownNotifier,int>((ref) {
    return CountDownNotifier();
},);


final scoreProvider = StateNotifierProvider((ref) {
    return ScoreNotifier();
},);