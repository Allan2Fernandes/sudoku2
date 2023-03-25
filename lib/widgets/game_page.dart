import 'dart:async';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:sudoku2/Styles.dart';
import 'package:sudoku2/difficulty_level.dart';
import 'package:sudoku2/game_generator.dart';


class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<List<String>>? gameElementStates;
  List<List<bool>>? isCorrectValueAtIndex;
  Duration durationCounter = const Duration();
  String durationString = "00:00";
  Timer? timer;
  int numMistakes = 0;
  int currentlySelectedRowIndex = 0;
  int currentlySelectedColumnIndex = 0;
  String currentlySelectedNumber = "0";
  bool timerIsPaused = false;
  GameGenerator gameGenerator= GameGenerator();
  int numVacancies = 0;
  _GamePageState(){
    gameElementStates = gameGenerator.getGameBoard();
    isCorrectValueAtIndex = List.generate(9, (rowIndex) =>
        List.generate(9, (columnIndex)=> true)
    );
    startTimer();
  }

  void startTimer(){
    timer = Timer.periodic(const Duration(seconds: 1), (timer) => { addTime()});
  }

  void addTime(){
    const addSeconds = 1;
    setState(() {
      //Logic
      if(timerIsPaused == false){
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
      print(numVacancies);
    });
  }

  void changeTimerIsPausedState(){
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
    if(timerIsPaused){
      return const Icon(Icons.play_arrow, size: 20, color: Styles.topRowTextColor,);
    }else{
      return const Icon(Icons.pause, size: 20, color: Styles.topRowTextColor,);
    }
  }

  TextStyle getBoardTextStyle(int rowIndex, int columnIndex){
    double fontSize = 25;

    //If not paused, find the right background
    if(gameGenerator.originalValues![rowIndex][columnIndex] == true){ //Color the original values black
      return TextStyle(color: Colors.black, fontSize: fontSize);
    }else{
      if(isCorrectValueAtIndex![rowIndex][columnIndex] == true){ //Color the correct values green
        return TextStyle(color: Colors.green, fontSize: fontSize);
      }else{                                                    //Color the wrongly inputted values red
        return TextStyle(color: Colors.red, fontSize: fontSize);
      }
    }
  }

  void undoLastEntry(){

  }

  void eraseCurrentlySelectedElement(){
    setState(() {
      if(gameGenerator.originalValues![currentlySelectedRowIndex][currentlySelectedColumnIndex] == false){
        gameElementStates![currentlySelectedRowIndex][currentlySelectedColumnIndex] = "";
      }
    });
  }


  void updateElementState(int numberSelection){
    setState(() {
      if(gameGenerator.originalValues![currentlySelectedRowIndex][currentlySelectedColumnIndex] == false){
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

  String getElementStatesIfPaused(int rowIndex, int columnIndex){
    if(timerIsPaused){
      return "";
    }else{
      return gameElementStates![rowIndex][columnIndex];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Text(DifficultyLevel.setDifficulty, style: Styles.topRowTextStyles,),
                Text("Mistakes: $numMistakes", style: Styles.topRowTextStyles,),
                Row(
                  children: [
                    Text(durationString, style: Styles.topRowTextStyles,),
                    IconButton(onPressed: (){
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
                            child: Text(getElementStatesIfPaused(rowIndex, columnIndex), style: getBoardTextStyle(rowIndex, columnIndex),),
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
                    IconButton(onPressed: (){}, icon: const Icon(FluentSystemIcons.ic_fluent_arrow_undo_filled)),
                    const Text("Undo")
                  ],
                ),
                Column(
                  children: [
                    IconButton(onPressed: (){
                      eraseCurrentlySelectedElement();
                    }, icon: const Icon(FluentSystemIcons.ic_fluent_erase_filled)),
                    const Text("Erase")
                  ],
                ),
                Column(
                  children: [
                    IconButton(onPressed: (){}, icon: const Icon(FluentSystemIcons.ic_fluent_flag_pride_filled)),
                    const Text("Give Up")
                  ],
                ),
                Column(
                  children: [
                    IconButton(onPressed: (){}, icon: const Icon(FluentSystemIcons.ic_fluent_lightbulb_circle_regular)),
                    const Text("Hint")
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
                    child: TextButton(onPressed: (){
                      if(currentlySelectedRowIndex == -1 || currentlySelectedColumnIndex == -1){
                        return;
                      }
                      int numberSelection = index+1;
                      updateElementState(numberSelection);
                      countNumVacancies();
                      print(numVacancies);
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

    );
  }
}
