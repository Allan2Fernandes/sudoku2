import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sudoku2/database_classes/database.dart';
import 'package:sudoku2/database_classes/database_conversions.dart';

import '../Styles.dart';

class SavedGameSrcollSingleView extends StatefulWidget {
  Map<String, dynamic> savedGameInfo;

  SavedGameSrcollSingleView({Key? key, required this.savedGameInfo}) : super(key: key);

  @override
  State<SavedGameSrcollSingleView> createState() => _SavedGameSrcollSingleViewState(this.savedGameInfo);
}

class _SavedGameSrcollSingleViewState extends State<SavedGameSrcollSingleView> {
  //Class variables
  Map<String, dynamic>? savedGameInfo;
  List<List<String>>? gameElementStates;
  List<List<bool>>? originalValues;
  List<List<bool>>? isCorrectValueAtIndex;
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          Container(
            margin: EdgeInsets.only(top: 50),
            width: MediaQuery.of(context).size.width*cardScaleFactor,
            height: MediaQuery.of(context).size.width*cardScaleFactor*0.8,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                color: Colors.grey
            ),
            child: Column(
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     Container(
                //       margin: EdgeInsets.only(left: 30, top: 15),
                //       child: Text("ID ${this.savedGameID}"),
                //     )
                //   ],
                // ),
                // //Time
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Container(
                //       margin: EdgeInsets.only(left: 30, top: 15),
                //       child: Text("Difficulty: $difficultyLevel"),
                //     ),
                //   ],
                // ),
                // Row(
                //   children: [
                //     Container(
                //       margin: EdgeInsets.only(left: 30, top: 15),
                //       child: Text("Mistakes: ${this.numberMistakes}"),
                //     )
                //   ],
                // ),
                // Row(
                //   children: [
                //     Container(
                //       margin: EdgeInsets.only(left: 30, top: 15),
                //       child: Text("Duration: ${durationString}"),
                //     )
                //   ],
                // ),
                // Row(
                //   children: [
                //     Container(
                //       margin: EdgeInsets.only(left: 30, top: 15),
                //       child: Text("Saved on ${saveTime?.day}/${saveTime?.month}/${saveTime?.year} at ${saveTime?.hour}:${saveTime?.minute}"),
                //     )
                //   ],
                // ),
                // Container(
                //   margin: EdgeInsets.only(left: 25, right: 50),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Container(
                //           margin: EdgeInsets.only(left: 30, top: 25),
                //           child: ElevatedButton(
                //             style: ElevatedButton.styleFrom(
                //               minimumSize: Size(50, 50),
                //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                //               backgroundColor: Styles.buttonsColor,
                //             ),
                //             onPressed: () {
                //               DataBaseHandler.deleteSavedGame(savedGameID!);
                //             },
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               children: [
                //                 Icon(Icons.delete_forever, size: 18,),
                //               ],
                //             ),
                //           )
                //       ),
                //       Container(
                //           margin: EdgeInsets.only(left: 30, top: 25),
                //           child: ElevatedButton(
                //             style: ElevatedButton.styleFrom(
                //               minimumSize: Size(150, 50),
                //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                //               backgroundColor: Styles.buttonsColor,
                //             ),
                //             onPressed: () {  },
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               children: [
                //                 Padding(padding: EdgeInsets.only(right: 15), child: Text("Continue game"),),
                //                 Icon(Icons.arrow_forward_rounded),
                //               ],
                //             ),
                //           )
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
          )
        ],
      ),
    );;
  }
}





