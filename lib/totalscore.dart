import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowledge_app/home.dart';
import 'package:knowledge_app/pallete.dart';
import 'package:knowledge_app/providers.dart';

class TotalScore extends ConsumerStatefulWidget {
   final int totalScore;
  const TotalScore({super.key,
    required this.totalScore
  });

  @override
  ConsumerState createState() => _TotalMarkState();
}

class _TotalMarkState extends ConsumerState<TotalScore> {
    void resetData(){
      ref.read(questionIndexNotifierProvider.notifier).resetData();
    }
    void resetColorData(){
      ref.read(changeColorProvider).reset();
    }
    void startCountDown(BuildContext context,int length){
      ref.read(countdownProvider.notifier).startCountdown(context, length);
    }
    void resetIncrement(){
      ref.read(scoreProvider.notifier).resetIncrement();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Container(
       padding: EdgeInsets.symmetric(horizontal: 20,vertical: 150),
       width: double.infinity,
       height: double.infinity,
       decoration: BoxDecoration(
         gradient: LinearGradient(
           colors: [Pallete.message, Pallete.message6],
           begin: Alignment.topCenter,
           end: Alignment.bottomCenter,
         ),
       ),
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Container(
            width: double.infinity,
             height: 300,
         decoration: BoxDecoration(
           gradient: LinearGradient(
             colors: [Pallete.message, Pallete.message1],
             begin: Alignment.topCenter,
             end: Alignment.bottomCenter,
           ),
           borderRadius: BorderRadius.circular(20)
         ),
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Text("Total Score",style: TextStyle(
                   color: Colors.white,
                   fontSize: 23,
                   fontWeight: FontWeight.bold
                 ),),
                 SizedBox(height: 10,),
                 Text("${widget.totalScore}/50",style: TextStyle(
                   color: Colors.white,
                   fontSize: 23,
                   fontWeight: FontWeight.bold
                 ),),
                 SizedBox(height: 50,),
                 ElevatedButton(onPressed: (){
                   resetData();
                   resetColorData();
                   resetIncrement();
                   startCountDown(context, 0);
                   Navigator.push(context, MaterialPageRoute(builder: (context) => Home(),));
                   },
                   style: ElevatedButton.styleFrom(
                     backgroundColor: Pallete.message6,
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(10),
                     )
                   ),
                   child: Text("Play",style: TextStyle(
                       color: Pallete.message3,
                       fontSize: 18,
                       fontWeight: FontWeight.bold
                   ),),
                 )
               ],
             ),
           )
         ],
       ),
     ),
    );
  }
}
