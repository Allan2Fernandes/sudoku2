import 'dart:async';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sudoku2/Styles.dart';
import 'package:sudoku2/database_classes/database.dart';
import 'package:sudoku2/database_classes/database_conversions.dart';
import 'package:sudoku2/database_classes/saved_game_entry.dart';
import 'package:sudoku2/difficulty_level.dart';
import 'package:sudoku2/game_generator.dart';
import 'package:tuple/tuple.dart';


class GamePage extends StatefulWidget {
  bool isLoadedGame;
  int? gameID;
  List<List<String>>? gameElementStates;
  List<List<bool>>? originalValues;
  List<List<bool>>? isCorrectValueAtIndex;
  List<List<String>>? solutionElementStates;
  String? durationString;
  int? numMistakes;
  String? difficultyLevel;

  GamePage({Key? key, required this.isLoadedGame, this.gameID, this.gameElementStates, this.originalValues, this.isCorrectValueAtIndex, this.solutionElementStates, this.durationString, this.numMistakes, this.difficultyLevel}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState(isLoadedGame, gameID, gameElementStates, originalValues, isCorrectValueAtIndex, solutionElementStates, durationString, numMistakes, difficultyLevel);
}

class _GamePageState extends State<GamePage> {
  List<List<String>>? gameElementStates; //Save
  List<List<String>>? solutionElementStates; //Save
  List<List<bool>>? originalValues; //Save
  List<List<bool>>? isCorrectValueAtIndex; //Save
  List<Tuple2<int, int>>? ListOfMoves;
  Duration durationCounter = const Duration();
  String durationString = "00:00"; //Save
  Timer? timer;
  int numMistakes = 0; //Save
  int currentlySelectedRowIndex = 0;
  int currentlySelectedColumnIndex = 0;
  String currentlySelectedNumber = "0";
  bool timerIsPaused = false;
  bool isComplete = false;
  bool isShowingSolution = false;
  GameGenerator gameGenerator= GameGenerator();
  int numVacancies = 0;
  String? difficultyLevel;

  //Incoming saved details
  bool? isLoadedGame;
  int? gameID;

  //Constructor
  _GamePageState(bool isLoadedGame, int? gameID, List<List<String>>? gameElementStates, List<List<bool>>? originalValues, List<List<bool>>? isCorrectValueAtIndex, List<List<String>>? solutionElementStates, String? durationString, int? numMistakes, String? difficultyLevel){
    this.difficultyLevel = difficultyLevel;
    this.isLoadedGame = isLoadedGame;
    if(isLoadedGame){
      this.gameID = gameID;
      this.gameElementStates = gameElementStates;
      gameGenerator.setGameBoard(this.gameElementStates!);
      this.originalValues = originalValues;
      gameGenerator.setOriginalValues(this.originalValues!);
      this.isCorrectValueAtIndex = isCorrectValueAtIndex;
      this.solutionElementStates = solutionElementStates;
      gameGenerator.setSolutionBoard(this.solutionElementStates!);
      this.durationString = durationString!;
      this.numMistakes = numMistakes!;
      //Get the amount of seconds from the duration string
      int totalSeconds = getNumSecondsFromDurationString(durationString);
      //Start the timer with those number of seconds
      startTimer(totalSeconds);
    }else{
      this.gameElementStates = gameGenerator.getGameBoard();
      this.solutionElementStates = gameGenerator.getSolutionBoard();
      this.originalValues = gameGenerator.originalValues;
      this.isCorrectValueAtIndex = List.generate(9, (rowIndex) =>
          List.generate(9, (columnIndex)=> true)
      );
      startTimer(0);
    }
  }

  int getNumSecondsFromDurationString(String durationString){
    String minutesSubString = durationString.substring(0, 2);
    String secondsSubString = durationString.substring(3);
    int numMinutes = int.parse(minutesSubString);
    int numSeconds = int.parse(secondsSubString);
    return numMinutes*60 + numSeconds;
  }

  void saveTheGame() async {
    //If the gameID is null,
    //Get the game id from the database and set gameID to the retrieved iD
    if(this.gameID == null){
      this.gameID = await DataBaseHandler.getNewGameID();
    }

    String gameElementStatesConverted = DatabaseConversion.convertStringListToString(gameElementStates);
    String solutionElementStatesConverted = DatabaseConversion.convertStringListToString(solutionElementStates);
    String originalValuesConverted = DatabaseConversion.convertBoolListToString(originalValues);
    String isCorrectValuesAtIndex = DatabaseConversion.convertBoolListToString(isCorrectValueAtIndex);
    SavedGameEntry savedGameEntry = SavedGameEntry(
        this.gameID!,
        gameElementStatesConverted,
        solutionElementStatesConverted,
        originalValuesConverted,
        isCorrectValuesAtIndex,
        durationString,
        difficultyLevel!,
        numMistakes,
        DateTime.now().toString(),
        isComplete? 1 : 0
    );
    int savedGameID = await DataBaseHandler.createSavedGame(savedGameEntry);
    setState(() {
      this.gameID = savedGameID;
    });
  }

  void startTimer(int startValue){
    timer = Timer.periodic(const Duration(seconds: 1), (timer) => { addTime()});
    durationCounter = Duration(seconds: startValue);
  }

  void addTime(){
    const addSeconds = 1;
    setState(() {
      //Logic
      if(timerIsPaused == false || isComplete){
        final seconds = durationCounter.inSeconds + addSeconds;
        durationCounter = Duration(seconds: seconds);
      }

      //Formatting the string
      int numberOfMinutes = (durationCounter.inSeconds/60).floor();
      int numberOfSeconds = durationCounter.inSeconds%60;
      String numMinutesString = "00";
      String numSecondsString = "00";
      if(numberOfMinutes<10){
        numMinutesString = "0$numberOfMinutes";
      }else{
        numMinutesString = numberOfMinutes.toString();
      }
      if(numberOfSeconds<10){
        numSecondsString = "0$numberOfSeconds";
      }else{
        numSecondsString = numberOfSeconds.toString();
      }
      durationString = "$numMinutesString:$numSecondsString";
    });
  }

  void giveUpTheGame(){
    if(isComplete){
      return;
    }
    setState(() {
      gameElementStates = solutionElementStates;
      isShowingSolution = true;
    });
    timer?.cancel();
    //Delete the game from the database
    if(gameID != null){
      DataBaseHandler.deleteSavedGame(gameID!);
    }
  }

  void countNumVacancies(){
    setState(() {
      int vacancies = 0;
      for(int i = 0; i < 9; i++){
        for(int j = 0; j < 9; j++){
          if(gameElementStates![i][j] == ""){
            vacancies++;
          }
        }
      }
      numVacancies = vacancies;
    });
  }

  void changeTimerIsPausedState(){
    if(isComplete){
      return;
    }
    setState(() {
      timerIsPaused = !timerIsPaused;
    });
  }

  void updateCurrentlySelectedIndices(int rowIndex, int columnIndex){
    setState(() {
      currentlySelectedRowIndex = rowIndex;
      currentlySelectedColumnIndex = columnIndex;
    });
  }

  Icon getPausePlayIcon(){
    if(isComplete){
      return const Icon(Icons.flag_circle_rounded, size: 20, color: Colors.greenAccent,);
    }
    if(isShowingSolution){
      return const Icon(Icons.flag_circle_rounded, size: 20, color: Styles.topRowTextColor);
    }
    if(timerIsPaused){
      return const Icon(Icons.play_arrow, size: 20, color: Styles.topRowTextColor,);
    }else{
      return const Icon(Icons.pause, size: 20, color: Styles.topRowTextColor,);
    }
  }

  TextStyle getBoardTextStyle(int rowIndex, int columnIndex){
    double fontSize = 20;


    //If not paused, find the right background
    if(originalValues![rowIndex][columnIndex] == true){ //Color the original values black
      return TextStyle(color: Colors.black, fontSize: fontSize);
    }else{
      if(isShowingSolution){
        return TextStyle(color: Colors.orange, fontSize: fontSize);
      }
      if(isCorrectValueAtIndex![rowIndex][columnIndex] == true){ //Color the correct values green
        return TextStyle(color: Colors.green, fontSize: fontSize);
      }else{                                                    //Color the wrongly inputted values red
        return TextStyle(color: Colors.red, fontSize: fontSize);
      }
    }
  }

  bool determineIfComplete(){
    if(gameElementStates.toString() == solutionElementStates.toString()){
      timer?.cancel();
      return true;
    }else{
      return false;
    }
  }

  void undoLastEntry(){

  }

  void eraseCurrentlySelectedElement(){
    setState(() {
      if(originalValues![currentlySelectedRowIndex][currentlySelectedColumnIndex] == false){
        gameElementStates![currentlySelectedRowIndex][currentlySelectedColumnIndex] = "";
      }
    });
  }


  void updateElementState(int numberSelection){
    setState(() {
      if(originalValues![currentlySelectedRowIndex][currentlySelectedColumnIndex] == false){
        gameElementStates![currentlySelectedRowIndex][currentlySelectedColumnIndex] = numberSelection.toString();

        if(!gameGenerator.columnCheckPass(numberSelection, currentlySelectedColumnIndex, currentlySelectedRowIndex) ||
        !gameGenerator.rowCheckPass(numberSelection, currentlySelectedColumnIndex, currentlySelectedRowIndex) ||
        !gameGenerator.subgridCheckPass(numberSelection, currentlySelectedColumnIndex, currentlySelectedRowIndex)
        ){
          isCorrectValueAtIndex![currentlySelectedRowIndex][currentlySelectedColumnIndex] = false;
          numMistakes++;
        }else{
          isCorrectValueAtIndex![currentlySelectedRowIndex][currentlySelectedColumnIndex] = true;
        }
      }
    });
  }

  ButtonStyle getButtonStyle(int rowIndex, int columnIndex){
    //If the button is paused, always show white
    if(timerIsPaused){
      return const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.white));
    }

    int subGridRow = (currentlySelectedRowIndex/3).floor();
    int subGridColumn = (currentlySelectedColumnIndex/3).floor();
    Color selectedCellColor = const Color(0xFFb1bab3);
    Color commonGridRowColumnColor = const Color(0xFFebf7ee);
    Color sudokuBoardBackgroundColor = Colors.white;
    Color selectedNumbersColor = const Color(0xFF376dc4);
    //Get the number in the cell
    String cellNumber = gameElementStates![rowIndex][columnIndex];
    if(cellNumber == currentlySelectedNumber && currentlySelectedNumber != ""){
      //Return a certain style
      return ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(selectedNumbersColor));
    }
    if(rowIndex == currentlySelectedRowIndex && columnIndex == currentlySelectedColumnIndex){
      return ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(selectedCellColor));
    } else if((rowIndex == currentlySelectedRowIndex && columnIndex != currentlySelectedColumnIndex) || (rowIndex != currentlySelectedRowIndex && columnIndex == currentlySelectedColumnIndex)){ //Same row or column
      return ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(commonGridRowColumnColor));
    }else if((rowIndex/3).floor() == subGridRow && (columnIndex/3).floor() == subGridColumn) { //Same subgrid
      return ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(commonGridRowColumnColor));
    }
    else{
      return ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(sudokuBoardBackgroundColor));
    }
  }

  String getElementStatesIfPausedOrGivenUp(int rowIndex, int columnIndex){
    if(timerIsPaused){
      return "";
    }else{
      return gameElementStates![rowIndex][columnIndex];
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        timer?.cancel();
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Styles.themeColor,
          title: const Text("SuDoKu"),
          centerTitle: true,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: (){
                  print("Opening settings");
                },
                icon: const Icon(Icons.settings),
              ),
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //First Row for time and pausing the game
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 10, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(difficultyLevel!, style: Styles.topRowTextStyles,),
                  Text("Mistakes: $numMistakes", style: Styles.topRowTextStyles,),
                  Row(
                    children: [
                      Text(durationString, style: Styles.topRowTextStyles,),
                      IconButton(onPressed: (){
                        if(isShowingSolution){
                          return;
                        }
                        changeTimerIsPausedState();
                      }, icon: getPausePlayIcon())
                    ],
                  ),
                ],
              ),
            ),
            //Second Row is the game board
            Container(
              height: MediaQuery.of(context).size.width.floorToDouble()-50,
              width: MediaQuery.of(context).size.width.floorToDouble()-50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 4)
              ),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(9, (columnIndex) =>
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(9, (rowIndex) => SizedBox(
                            // decoration: BoxDecoration(
                            //     border: Border.all(width: 1, color: Colors.grey)
                            // ),
                            height: (MediaQuery.of(context).size.width-50)/9-1,
                            width: (MediaQuery.of(context).size.width-50)/9-1,
                            child: TextButton(
                              onPressed: (){
                                //print("Row is ${rowIndex} and column is ${columnIndex}");
                                updateCurrentlySelectedIndices(rowIndex, columnIndex);
                                String selectedNumber = gameElementStates![rowIndex][columnIndex];
                                currentlySelectedNumber = selectedNumber;
                              },
                              style: getButtonStyle(rowIndex, columnIndex),
                              child: Text(getElementStatesIfPausedOrGivenUp(rowIndex, columnIndex), style: getBoardTextStyle(rowIndex, columnIndex),),
                            ),
                          )
                          ),
                        )
                    ),
                  ),
                ],
              )
            ),
            //Third row is buttons like erase
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      IconButton(onPressed: (){
                        if(isShowingSolution){
                          return;
                        }
                      }, icon: const Icon(FluentSystemIcons.ic_fluent_arrow_undo_filled)),
                      const Text("Undo")
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(onPressed: (){
                        if(isComplete){
                          return;
                        }
                        if(isShowingSolution){
                          return;
                        }
                        eraseCurrentlySelectedElement();
                      }, icon: const Icon(FluentSystemIcons.ic_fluent_erase_filled)),
                      const Text("Erase")
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(onPressed: (){
                        if(isShowingSolution){
                          return;
                        }
                        //Function to give up the game
                        giveUpTheGame();
                      }, icon: const Icon(Icons.outlined_flag)),
                      const Text("Give Up")
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(onPressed: (){
                        if(isShowingSolution){
                          return;
                        }
                      }, icon: const Icon(FluentSystemIcons.ic_fluent_info_regular)),
                      const Text("Rules")
                    ],
                  ),
                ],
              ),
            ),
            //Fourth row is number selection
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  children: List.generate(9, (index) => SizedBox(
                      width: MediaQuery.of(context).size.width/10,
                      child: TextButton(
                        onPressed: (){
                          if(isComplete){
                            return;
                          }
                          if(isShowingSolution){
                            return;
                          }
                          if(currentlySelectedRowIndex == -1 || currentlySelectedColumnIndex == -1){
                            return;
                          }
                          int numberSelection = index+1;
                          updateElementState(numberSelection);
                          countNumVacancies();
                          saveTheGame();
                          setState(() {
                            isComplete = determineIfComplete();
                          });
                        },
                          child: Text((index+1).toString(),
                            style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Styles.themeColor
                            )
                            ),
                          )
                      )
                  )),
                ),
              )
          ],
        ),

      ),
    );
  }
}
