import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sudoku2/Styles.dart';

import 'difficulty_level_page.dart';

class NoSavedGamesPage extends StatelessWidget {
  const NoSavedGamesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning_amber_rounded, size: MediaQuery.of(context).size.width/2, color: Styles.themeColor,),
              TextButton(
                  onPressed: (){},
                  child: Text("No saved games found", style: TextStyle(color: Styles.themeColor, fontSize: 30),)
              ),
            ],
          ),
        ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 50, right: 50, bottom: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(60, 60),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        backgroundColor: Styles.buttonsColor,
                      ),
                    ),
                    // ElevatedButton(
                    //     onPressed: (){
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(builder: (context)=> const DifficultyLevelSelector())
                    //       );
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //       minimumSize: Size(60, 60),
                    //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    //       backgroundColor: Styles.buttonsColor,
                    //     ),
                    //     child: Container(
                    //       child: Row(
                    //         children: [
                    //           Text("New Game"),
                    //           Icon(Icons.arrow_forward)
                    //         ],
                    //       ),
                    //     )
                    // )
                  ],
                ),
              ),
            ],
          )
        ]
      ),
    );
  }
}
