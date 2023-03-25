import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:sudoku2/difficulty_level.dart';

class GameGenerator{
  List<List<String>>? gameBoard;
  List<List<bool>>? originalValues;
  String boardAsString = "";
  GameGenerator(){
    gameBoard = List.generate(9, (rowIndex) =>
        List.generate(9, (columnIndex) => "0")
    );
    originalValues = List.generate(9, (rowIndex) =>
        List.generate(9, (columnIndex)=> false)
    );
    fetchBoardFromAPI();
  }

  String getRankFromMode(){
    if(DifficultyLevel.setDifficulty == 'Easy'){
      return "25";
    }else if(DifficultyLevel.setDifficulty == 'Medium'){
      return "75";
    }else if(DifficultyLevel.setDifficulty == "Hard"){
      return "125";
    }
    return "0";
  }


  Future<void> fetchBoardFromAPI() async {
    String rank = getRankFromMode();
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/SudokuGenerator/$rank'));
    boardAsString = jsonDecode(response.body)['board'];
    convertStringToGameBoard();
  }

  void convertStringToGameBoard(){
    int pointer = 0;
    for(int i= 0; i < 9; i++){
      for(int j = 0; j < 9; j++){
        String value;
        if(boardAsString[pointer] == "0"){
          value = "";
        }else{
          originalValues![i][j] = true;
          value = boardAsString[pointer];
        }
        gameBoard![i][j] = value;
        pointer++;
      }
    }
  }


  String getBoardElement(int row, int column){
    Random random = new Random();
    int randomNumber = random.nextInt(10 - 1) + 1;
    while(!subgridCheckPass(randomNumber, column, row) || !columnCheckPass(randomNumber, column, row) || !rowCheckPass(randomNumber, column, row)){
      randomNumber = random.nextInt(10 - 1) + 1;
    }
    return randomNumber.toString();
  }

  bool columnCheckPass(int selection, int column, int row){
    //Using the column index, check all rows
    for(int i= 0;i < 9;i++){
      if(i != row){
        if(gameBoard![i][column] == selection.toString()){
          print("Conflict with row number " + i.toString());
          return false;
        }
      }
    }
    return true;
  }

  bool rowCheckPass(int selection, int column, int row){
    for(int j= 0;j < 9;j++){
      if(j != column){
        if(gameBoard![row][j] == selection.toString()){
          print("Conflict with column number " + j.toString());
          return false;
        }
      }
    }
    return true;
  }

  bool subgridCheckPass(int selection, int column, int row){
    int subGridRow = (row/3).floor();
    int subGridColumn = (column/3).floor();
    //print("SubGrid Row = ${subGridRow} and SubGrid column = ${subGridColumn}");

    //Check the rows subGridRow +1/+2/+3
    //Check the columns subGridColumn +1/+2/+3
    for(int i=0;i<3;i++){
      for(int j=0;j<3;j++){
        if((subGridRow*3+i) ==row && (subGridColumn*3+j) == column){
          continue;
        }
        if(gameBoard![subGridRow*3+i][subGridColumn*3+j] == selection.toString()){
          //print("Conflict in subgrid at Row: ${subGridRow*3+i} and Column: ${subGridColumn*3+j}");
          return false;
        }
      }
    }
    return true;
  }

  List<List<String>>? getGameBoard(){
    return gameBoard;
  }
}