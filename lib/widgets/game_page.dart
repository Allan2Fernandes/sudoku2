import 'dart:async';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:sudoku2/Styles.dart';
import 'package:sudoku2/game_generator.dart';


class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<List<String>>? gameElementStates;
  List<List<bool>>? isCorrectValueAtIndex;
  Duration durationCounter = Duration();
  Timer? timer;
  int numMistakes = 0;
  int currentlySelectedRowIndex = 0;
  int currentlySelectedColumnIndex = 0;
  String currentlySelectedNumber = "0";
  GameGenerator gameGenerator = GameGenerator();

  _GamePageState(){
    gameElementStates = gameGenerator.getGameBoard();
    isCorrectValueAtIndex = List.generate(9, (rowIndex) =>
        List.generate(9, (columnIndex)=> true)
    );
    startTimer();
  }

  void startTimer(){
    timer = Timer.periodic(Duration(seconds: 1), (timer) => { addTime()});
  }

  void addTime(){
    final addSeconds = 1;
    setState(() {
      final seconds = durationCounter.inSeconds + addSeconds;
      durationCounter = Duration(seconds: seconds);
    });
  }

  void updateCurrentlySelectedIndices(int rowIndex, int columnIndex){
    setState(() {
      currentlySelectedRowIndex = rowIndex;
      currentlySelectedColumnIndex = columnIndex;
    });
  }

  TextStyle getBoardTextStyle(int rowIndex, int columnIndex){
    double fontSize = 25;
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
    int subGridRow = (currentlySelectedRowIndex/3).floor();
    int subGridColumn = (currentlySelectedColumnIndex/3).floor();
    Color selectedCellColor = const Color(0xFFb1bab3);
    Color commonGridRowColumnColor = Color(0xFFebf7ee);
    Color sudokuBoardBackgroundColor = Colors.white;
    //Get the number in the cell
    String cellNumber = gameElementStates![rowIndex][columnIndex];
    if(cellNumber == currentlySelectedNumber){
      //Return a certain style
      return ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Color(0xFF376dc4)));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.themeColor,
        title: Text("SuDoKu"),
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: (){
                print("Opening settings");
              },
              icon: Icon(Icons.settings),
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
                Text("Easy Mode", style: Styles.topRowTextStyles,),
                Text("Mistakes: ${numMistakes}", style: Styles.topRowTextStyles,),
                Container(
                  child: Row(
                    children: [
                      Text("${(durationCounter.inSeconds).floor()}", style: Styles.topRowTextStyles,),
                      IconButton(onPressed: (){}, icon: Icon(Icons.pause, size: 20, color: Styles.topRowTextColor,))
                    ],
                  ),
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
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(9, (columnIndex) =>
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(9, (rowIndex) => Container(
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
                              child: Text(gameElementStates![rowIndex][columnIndex], style: getBoardTextStyle(rowIndex, columnIndex),),
                              style: getButtonStyle(rowIndex, columnIndex),
                            ),
                          )
                          ),
                        )
                    ),
                  ),
                ),
              ],
            )
          ),
          //Third row is buttons like erase
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    IconButton(onPressed: (){}, icon: Icon(FluentSystemIcons.ic_fluent_arrow_undo_filled)),
                    Text("Undo")
                  ],
                ),
                Column(
                  children: [
                    IconButton(onPressed: (){
                      eraseCurrentlySelectedElement();
                    }, icon: Icon(FluentSystemIcons.ic_fluent_erase_filled)),
                    Text("Erase")
                  ],
                ),
                Column(
                  children: [
                    IconButton(onPressed: (){}, icon: Icon(FluentSystemIcons.ic_fluent_notebook_sync_filled)),
                    Text("Notes")
                  ],
                ),
                Column(
                  children: [
                    IconButton(onPressed: (){}, icon: Icon(FluentSystemIcons.ic_fluent_lightbulb_circle_regular)),
                    Text("Hint")
                  ],
                ),
              ],
            ),
          ),
          //Fourth row is number selection
          Padding(
            padding: EdgeInsets.all(15),
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                children: List.generate(9, (index) => Container(
                    width: MediaQuery.of(context).size.width/10,
                    child: TextButton(onPressed: (){
                      if(currentlySelectedRowIndex == -1 || currentlySelectedColumnIndex == -1){
                        return;
                      }
                      int numberSelection = index+1;
                      updateElementState(numberSelection);
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
