import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sudoku2/database_classes/database.dart';
import 'package:sudoku2/database_classes/database_conversions.dart';
import 'package:glassmorphism/glassmorphism.dart';

import '../Styles.dart';
import 'game_page.dart';

class SavedGameSrcollSingleView extends StatefulWidget {
  Map<String, dynamic> savedGameInfo;
  Function(int savedGameID)? onDelete;

  SavedGameSrcollSingleView({Key? key, required this.savedGameInfo, required this.onDelete}) : super(key: key);

  @override
  State<SavedGameSrcollSingleView> createState() => _SavedGameSrcollSingleViewState(savedGameInfo);
}

class _SavedGameSrcollSingleViewState extends State<SavedGameSrcollSingleView> {
  //Class variables
  Map<String, dynamic>? savedGameInfo;
  List<List<String>>? gameElementStates;
  List<List<bool>>? originalValues;
  List<List<bool>>? isCorrectValueAtIndex;
  List<List<String>>? solutionElementStates;
  String? durationString;
  String? difficultyLevel;
  int? numberMistakes;
  int? savedGameID;
  String? saveTimeString;
  DateTime? saveTime;
  double cardScaleFactor = 0.8;

  //Constructor
  _SavedGameSrcollSingleViewState(Map<String, dynamic> savedGameInfo){
    this.savedGameInfo = savedGameInfo;
    savedGameID = int.parse(this.savedGameInfo!['savedGameID'].toString());
    gameElementStates = DatabaseConversion.convertStringToStringList(this.savedGameInfo!['gameElementStates']);
    originalValues = DatabaseConversion.convertStringToBoolList(this.savedGameInfo!['originalValues']);
    isCorrectValueAtIndex = DatabaseConversion.convertStringToBoolList(this.savedGameInfo!['correctValuesIndices']);
    solutionElementStates = DatabaseConversion.convertStringToStringList(this.savedGameInfo!['solutionElementStates']);
    durationString = this.savedGameInfo!['durationString'].toString();
    difficultyLevel = this.savedGameInfo!['difficultyLevel'].toString();
    numberMistakes = int.parse(this.savedGameInfo!['numberMistakes'].toString());
    saveTimeString = this.savedGameInfo!['saveTime'].toString();
    saveTime = DateTime.parse(saveTimeString!);
  }

  String getElementStatesIfPausedOrGivenUp(int rowIndex, int columnIndex){
    return gameElementStates![rowIndex][columnIndex];
  }

  TextStyle getBoardTextStyle(int rowIndex, int columnIndex){
    double fontSize = 20;

    //If not paused, find the right background
    if(originalValues![rowIndex][columnIndex] == true){ //Color the original values black
      return TextStyle(color: Colors.black, fontSize: fontSize);
    }else{
      if(isCorrectValueAtIndex![rowIndex][columnIndex] == true){ //Color the correct values green
        return TextStyle(color: Colors.green, fontSize: fontSize);
      }else{                                                    //Color the wrongly inputted values red
        return TextStyle(color: Colors.red, fontSize: fontSize);
      }
    }
  }

  Color getTabletColorOnDifficulty(){
    if(difficultyLevel == 'Hard'){
      return Color(0xFFA65151);
    }else if(difficultyLevel == 'Medium'){
      return Color(0xFFCFC833);
    }else if(difficultyLevel == 'Easy'){
      return Color(0xFF6bab65);
    }
    return Color(0xFF000000);
  }

  Color getButtonColorOnDifficulty(){
    return Color(0xFF6bab65);
    // if(difficultyLevel == 'Hard'){
    //   return Color(0xFFA65151);
    // }else if(difficultyLevel == 'Medium'){
    //   return Color(0xFFCFC833);
    // }else if(difficultyLevel == 'Easy'){
    //   return Color(0xFF6bab65);
    // }
    // return Color(0xFF000000);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 17),
      height: MediaQuery.of(context).size.height*cardScaleFactor,
      width: MediaQuery.of(context).size.width,
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.all(Radius.circular(50)),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.grey,
      //         offset: Offset(0.0, 10.0), //(x,y)
      //         blurRadius: 6.0,
      //       )
      //     ]
      // ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container( //Board container
              height: MediaQuery.of(context).size.width.floorToDouble()*cardScaleFactor,
              width: MediaQuery.of(context).size.width.floorToDouble()*cardScaleFactor,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  border: Border.all(width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(0.0, 10.0), //(x,y)
                      blurRadius: 20.0,
                    )
                  ]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(9, (columnIndex) =>
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(9, (rowIndex) => Container(
                        // decoration: BoxDecoration(
                        //     border: Border.all(width: 1, color: Colors.grey)
                        // ),
                        height: (MediaQuery.of(context).size.width*cardScaleFactor)/9-1,
                        width: (MediaQuery.of(context).size.width*cardScaleFactor)/9-1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          border: Border.all(width: 0.5),
                          color: Colors.white
                        ),
                        child: Center(
                          child: Text(getElementStatesIfPausedOrGivenUp(rowIndex, columnIndex), style: getBoardTextStyle(rowIndex, columnIndex).copyWith(fontSize: 18),),
                        )
                      )
                      ),
                    )
                ),
              ),
          ),
          GlassmorphicContainer(
            width: MediaQuery.of(context).size.width*cardScaleFactor,
            height: MediaQuery.of(context).size.width*cardScaleFactor*0.85,
            borderRadius: 25,
            linearGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Styles.themeColor.withAlpha(50),
                getTabletColorOnDifficulty().withAlpha(100)
              ],
              stops: [
              0.3,
              1,
              ]),
            border: 0,
            blur: 7,
            borderGradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: [
                  Color(0xFF4579C5).withAlpha(100),
                  Color(0xFFFFFFF).withAlpha(55),
                  Color(0xFFF75035).withAlpha(10),
                ],
                stops: [
                  0.06,
                  0.95,
                  1
                ]),
            child: Container(
              // margin: EdgeInsets.only(top: 50),
              // width: MediaQuery.of(context).size.width*cardScaleFactor,
              // height: MediaQuery.of(context).size.width*cardScaleFactor*0.8,

              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.blueGrey,
                  //     offset: Offset(0.0, 10.0), //(x,y)
                  //     blurRadius: 5.0,
                  //   )
                  // ]
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 30, top: 15),
                        child: Row(
                          children: [
                            Icon(Icons.tag),
                            Text(" ${this.savedGameID}", style: Styles.savedGamesTextStyle,),
                          ],
                        )
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 30, top: 15, right: 30),
                        child: Text("Difficulty: $difficultyLevel", style: Styles.savedGamesTextStyle,),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 30, top: 15),
                        child: Row(
                          children: [
                            Icon(Icons.close_rounded, color: Colors.red),
                            Text(" ${this.numberMistakes}", style: Styles.savedGamesTextStyle,)
                          ],
                        ),
                      ),

                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 30, top: 15),
                        child: Row(
                          children: [
                            Icon(Icons.hourglass_top_rounded, color: Color(0xFF262626),),
                            Text(" ${durationString}", style: Styles.savedGamesTextStyle,)
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 30, top: 15),
                        child: Row(
                          children: [
                            Icon(Icons.save, color: Color(0xFF262626),),
                            Text(" ${saveTime?.day}/${saveTime?.month}/${saveTime?.year} at ${saveTime!.hour>=10?saveTime!.hour:"0${saveTime!.hour}"}:${saveTime!.minute>=10?saveTime!.minute:"0${saveTime!.minute}"}", style: Styles.savedGamesTextStyle,)
                          ],
                        ),
                      )
                    ],
                  ),
                  Container( //Both buttons container --------------------
                    margin: EdgeInsets.only(left: 15, right: 15, top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(50, 50),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                backgroundColor: Styles.buttonsColor,
                              ),
                              onPressed: () {
                                print("Deleting at index $savedGameID");
                                widget.onDelete!(savedGameID!);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.delete_forever, size: 18,),
                                ],
                              ),
                            )
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 30),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(155, 50),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                backgroundColor: getButtonColorOnDifficulty(),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context)=>
                                        GamePage(
                                          isLoadedGame: true,
                                          gameID: savedGameID,
                                          gameElementStates: gameElementStates,
                                          isCorrectValueAtIndex: isCorrectValueAtIndex,
                                          originalValues: originalValues,
                                          solutionElementStates: solutionElementStates,
                                          durationString: durationString,
                                          numMistakes: numberMistakes,
                                          difficultyLevel: difficultyLevel,
                                        )
                                    )
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(padding: EdgeInsets.only(right: 15), child: Text("Continue game"),),
                                  Icon(Icons.arrow_forward_rounded),
                                ],
                              ),
                            )
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );;
  }
}





