import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:sudoku2/difficulty_level.dart';
import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';

class GameGenerator{
  List<List<String>>? gameBoard;
  List<List<String>>? solutionBoard;
  List<List<bool>>? originalValues;
  String boardAsString = "";
  String boardSolutionAsString = "";
  GameGenerator(){
    gameBoard = List.generate(9, (rowIndex) =>
        List.generate(9, (columnIndex) => "0")
    );
    solutionBoard = List.generate(9, (rowIndex) =>
        List.generate(9, (columnIndex) => "0")
    );
    originalValues = List.generate(9, (rowIndex) =>
        List.generate(9, (columnIndex)=> false)
    );
    //fetchBoardFromAPI();
    createBoardFromPackage();
  }

  int getRankFromMode(){
    if(DifficultyLevel.setDifficulty == 'Easy'){
      return 25;
    }else if(DifficultyLevel.setDifficulty == 'Medium'){
      return 45;
    }else if(DifficultyLevel.setDifficulty == "Hard"){
      return 54;
    }
    return 0;
  }

  void createBoardFromPackage(){
    var sudokuGenerator = SudokuGenerator(emptySquares: getRankFromMode());
    var board = sudokuGenerator.newSudoku;
    var solutionBoard = SudokuSolver.solve(board);
    convertIntBoardToString(board);
    convertIntSolutionBoardToString(solutionBoard);
  }

  // Future<void> fetchBoardFromAPI() async {
  //   String rank = getRankFromMode();
  //   final response = await http.get(Uri.parse('http://10.0.2.2:8000/SudokuGenerator/$rank'));
  //   boardAsString = jsonDecode(response.body)['board'];
  //   boardSolutionAsString = jsonDecode(response.body)['solution'];
  //   convertStringToGameBoard();
  //   convertStringToSolutionBoard();
  // }

  void convertIntBoardToString(var board){
    for(int rowNum = 0; rowNum < 9; rowNum++){
      for(int columnNum = 0; columnNum < 9; columnNum++){
        if(board[rowNum][columnNum] == 0){
          gameBoard![rowNum][columnNum] = "";
        }else{
          originalValues![rowNum][columnNum] = true;
          gameBoard![rowNum][columnNum] = board[rowNum][columnNum].toString();
        }
      }
    }
  }

  void convertIntSolutionBoardToString(var solutionBoard){
    for(int rowNum = 0; rowNum < 9; rowNum++){
      for(int columnNum = 0; columnNum < 9; columnNum++){
        this.solutionBoard![rowNum][columnNum] = solutionBoard[rowNum][columnNum].toString();
      }
    }
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

  void convertStringToSolutionBoard(){
    int pointer = 0;
    for(int i= 0; i < 9; i++){
      for(int j = 0; j < 9; j++){
        String value = boardSolutionAsString[pointer];
        solutionBoard![i][j] = value;
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
    //Convert every element to string

    return gameBoard;
  }
  List<List<String>>? getSolutionBoard(){
    return solutionBoard;
  }

  void setGameBoard(List<List<String>> gameBoard){
    this.gameBoard = gameBoard;
  }

  void setSolutionBoard(List<List<String>> solutionGameBoard){
    this.solutionBoard = solutionGameBoard;
  }

  void setOriginalValues(List<List<bool>> originalValues){
    this.originalValues = originalValues;
  }
}