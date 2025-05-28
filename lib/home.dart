import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
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
  void resetData(){
    ref.read(changeColorProvider).reset();
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(questionIndexNotifierProvider);
    final changeIndex = ref.watch(questionIndexNotifierProvider.notifier);
    final questionAsync = ref.watch(questionProvider);
    final changeColor = ref.watch(changeColorProvider).index;
    return questionAsync.when(
      data: (data) {
        final List allData = data["questions"];
        final question = allData[currentIndex]["question"];
        final List option = allData[currentIndex]["option"];
        final answer = allData[currentIndex]["answer"];
        return Scaffold(
          body: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
            ).copyWith(top: MediaQuery.of(context).size.width / 1.6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Pallete.message, Pallete.message6],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
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
                        if (option[index] == answer) {
                          await Future.delayed(Duration(seconds: 1));
                          if (currentIndex < 4 - 1) {
                            resetData();
                            changeIndex.showNextQuestion(4); //
                      // move to next question
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('All questions completed!')),
                            );
                            changeIndex.resetData();
                            resetData();
                          }

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
                Spacer(),
              ],
            ),
          ),
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text("Error: $err")),
    );
  }
}
