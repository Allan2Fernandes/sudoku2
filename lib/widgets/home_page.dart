import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sudoku2/Styles.dart';
import 'package:sudoku2/difficulty_level.dart';
import 'package:sudoku2/widgets/game_page.dart';
import 'package:sudoku2/widgets/saved_game_picker_page.dart';

import 'difficulty_level_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);



  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[300],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: ElevatedButton(
                      onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=> const DifficultyLevelSelector())
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(150, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        backgroundColor: Styles.buttonsColor,
                      ),
                      child: Text("New Game")
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: ElevatedButton(
                      onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=> SavedGamePicker())
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(150, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        backgroundColor: Styles.buttonsColor,
                      ),
                      child: Text("Continue Game")
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
