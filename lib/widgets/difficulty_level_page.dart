import 'dart:math';

import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sudoku2/difficulty_level.dart';
import 'package:sudoku2/widgets/game_page.dart';

import '../Styles.dart';

class DifficultyLevelSelector extends StatefulWidget {
  const DifficultyLevelSelector({Key? key}) : super(key: key);

  @override
  State<DifficultyLevelSelector> createState() => _DifficultyLevelSelectorState();
}

class _DifficultyLevelSelectorState extends State<DifficultyLevelSelector> {

  int? selectionIndex;

  _DifficultyLevelSelectorState(){
    selectionIndex = DifficultyLevel.setDifficultyIndex;
  }

  void updateSelectionIndex(int newSelectionIndex){
    setState(() {
      selectionIndex = newSelectionIndex;
    });
  }

  BorderSide getBorderSideForSelection(int indexOfButton){
    if(indexOfButton == selectionIndex){
      return BorderSide(color: Colors.black, width: 3);
    }else{
      return BorderSide(color: Styles.buttonsColor);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.settings),
              color: Colors.white,
              onPressed: (){
                print("Settings activated");
              },
            ),
          )
        ],
        backgroundColor: Styles.themeColor,
        title: Text("SuDoKu"),
        centerTitle: true,
      ),
    body: Center(
      child: Container(
        width: MediaQuery.of(context).size.width*0.9,
        height: MediaQuery.of(context).size.height*0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50))
        ),
        child: Column(//Easy difficulty
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: (){
                  DifficultyLevel.setTheDifficidultyEasy();
                  updateSelectionIndex(0);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Styles.buttonsColor,
                  minimumSize: Size.fromHeight(60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  side: getBorderSideForSelection(0)
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.2,0,0,0),
                  child: Row(
                    children: const [
                      Icon(Icons.signal_cellular_alt_1_bar, color: Colors.green, size: 30,),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10,0,0,0),
                        child: Text("Easy", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),),
                      ),
                    ],
                  ),
                )),
            ElevatedButton(
                onPressed: (){
                  DifficultyLevel.setTheDifficultyMedium();
                  updateSelectionIndex(1);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Styles.buttonsColor,
                    minimumSize: Size.fromHeight(60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    side: getBorderSideForSelection(1)
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.2,0,0,0),
                  child: Row(
                    children: const [
                      Icon(Icons.signal_cellular_alt_2_bar, color: Colors.yellow, size: 30,),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15,0,0,0),
                        child: Text("Medium", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),),
                      ),
                    ],
                  ),
                )),
            ElevatedButton(
                onPressed: (){
                  DifficultyLevel.setTheDifficultyHard();
                  updateSelectionIndex(2);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Styles.buttonsColor,
                    minimumSize: Size.fromHeight(60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    side: getBorderSideForSelection(2)
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.2,0,0,0),
                  child: Row(
                    children: const [
                      Icon(Icons.signal_cellular_alt_sharp, color: Colors.red, size: 30,),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20,0,0,0),
                        child: Text("Hard", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),),
                      ),
                    ],
                  ),
                )),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Styles.buttonsColor,
                      minimumSize: const Size(60, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Transform.rotate(angle: pi, child: const Icon(Icons.keyboard_arrow_right,),)
                ),
                ElevatedButton(
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> const GamePage())
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Styles.buttonsColor,
                      minimumSize: const Size(150, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Start Game"),
                        Padding(
                          padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                          child: Icon(FluentSystemIcons.ic_fluent_arrow_forward_filled),
                        )
                      ],
                    )
                )
              ],
            ),//Go back or proceed to new game
          ],
        ),
      ),
    ),
    );
  }
}
