import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:knowledge_app/totalscore.dart';
import 'package:knowledge_app/pallete.dart';
import 'package:knowledge_app/providers.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  void optionColorChange(index) {
    ref.read(changeColorProvider).optionChange(index);
  }
  void resetColorData(){
    ref.read(changeColorProvider).reset();
  }
  void startCountDown(int length){
    ref.read(countdownProvider.notifier).startCountdown(context,length);
  }//statenotier and stateprovide itinokke notifier venam vilikkan
    //chnageNotifier atu venda
  void timeCancel(){
    ref.read(countdownProvider.notifier).cancel();
  }
  void incrementScore(){
    ref.read(scoreProvider.notifier).incrementScore();
  }

  @override
  void initState() {
    startCountDown(0);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(questionIndexNotifierProvider);
    final changeIndex = ref.watch(questionIndexNotifierProvider.notifier);
    final questionAsync = ref.watch(questionProvider);
    final changeColor = ref.watch(changeColorProvider).index;
    final countDown = ref.watch(countdownProvider);
    final answerLength = ref.watch(scoreProvider);
    return questionAsync.when(
      data: (data) {
        final List allData = data["questionData"]["questions"];
        final question = allData[currentIndex]["question"];
        final List option = allData[currentIndex]["options"];
        final String answer = allData[currentIndex]["answer"];
        return Scaffold(
          body: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
            ).copyWith(top: MediaQuery.of(context).size.width /2.6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Pallete.message, Pallete.message6],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
             AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Text(
              "$countDown",
              key: ValueKey(countDown),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
                SizedBox(height: 120,),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: GradientBoxBorder(
                      gradient: LinearGradient(
                        colors: [Pallete.blueColor, Pallete.message6],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    question,
                    style: TextStyle(color: Pallete.whiteColor),
                  ),
                ),
                SizedBox(height: 40),
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 60,
                    crossAxisCount: 2,
                    childAspectRatio: 2.3,
                  ),
                  itemCount: option.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        optionColorChange(index);
                        timeCancel();
                        if (option[index] == answer) {
                          incrementScore();
                          await Future.delayed(Duration(seconds: 1));
                          if (currentIndex <allData.length-1) {
                            resetColorData();
                            startCountDown(answerLength+1);
                            changeIndex.showNextQuestion(allData.length);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('All questions completed!')),
                            );
                            await Future.delayed(Duration(seconds: 2));
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TotalScore(totalScore: allData.length,),));
                          }
                        }else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('wrong answer pls try again next')),
                          );
                          await Future.delayed(Duration(seconds: 2));
                          Navigator.push(context, MaterialPageRoute(builder: (context) => TotalScore(totalScore: answerLength),),);
                        }
                      },

                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color:
                          changeColor == index
                              ? option[index]==answer
                              ? Colors.green
                              : Colors.red
                              : Pallete.prod.withAlpha(1),
                          border: GradientBoxBorder(
                            gradient: LinearGradient(
                              colors: [Pallete.prod, Pallete.message5],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          option[index],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, stack) => Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Pallete.message, Pallete.message6],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
              child: Text("Please Use Internet",style: TextStyle(
                  color: Pallete.message,
                 fontSize: 33,
                inherit: false
              ),))
      ),
    );
  }
}
