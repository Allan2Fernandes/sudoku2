import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sudoku2/database_classes/database_conversions.dart';


class DataBaseHandler{

  Future<Database> initializedDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'Sudoku.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE savedGames("
              "savedGameID INTEGER PRIMARY KEY AUTOINCREMENT, "
              "gameElementStates TEXT NOT NULL,"
              "solutionElementStates TEXT NOT NULL,"
              "originalValues TEXT NOT NULL,"
              "correctValuesIndices TEXT NOT NULL,"
              "secondsCounter TEXT NOT NULL,"
              "difficultyLevel TEXT NOT NULL,"
              "numberMistakes INT NOT NULL"
              ")"
        );
      },
    );
  }

  Future<void> saveTheGame(
      int savedGameID,
      List<List<String>>? gameElementStates,
      List<List<String>>? solutionElementStates,
      List<List<bool>>? originalValues,
      List<List<bool>>? isCorrectValueAtIndex,
      String durationString,
      String difficultyLevel,
      int numberMistakes
      ) async {
    final database = await initializedDB();
    var queryMap = await database.rawQuery("SELECT count(savedGameID) FROM savedGames WHERE savedGameID = ${savedGameID}");
    if(queryMap[0]['count(savedGameID)'].toString() == "0"){
      print("Game does not exist, saving a new game");
      await createSavedGame(gameElementStates, solutionElementStates, originalValues, isCorrectValueAtIndex, durationString, difficultyLevel, numberMistakes);
    }else{
      print("Saved game exists. Over writing");
      await updateSavedGame(savedGameID, gameElementStates, solutionElementStates, originalValues, isCorrectValueAtIndex, durationString, difficultyLevel, numberMistakes);
    }

  }

  Future<void> createSavedGame(
      List<List<String>>? gameElementStates,
      List<List<String>>? solutionElementStates,
      List<List<bool>>? originalValues,
      List<List<bool>>? isCorrectValueAtIndex,
      String durationString,
      String difficultyLevel,
      int numberMistakes) async{
    String gameElementStatesConverted = DatabaseConversion.convertStringListToString(gameElementStates);
    String solutionElementStatesConverted = DatabaseConversion.convertStringListToString(solutionElementStates);
    String originalValuesConverted = DatabaseConversion.convertBoolListToString(originalValues);
    String isCorrectValuesAtIndex = DatabaseConversion.convertBoolListToString(isCorrectValueAtIndex);
    final database = await initializedDB();

    //Insert if the game hasn't been saved before
    //Update if the game has been saved before

    //Insert new Data
    await database.rawQuery("INSERT INTO savedGames(gameElementStates, solutionElementStates, originalValues, correctValuesIndices, secondsCounter, difficultyLevel, numberMistakes)"
        "VALUES('${gameElementStatesConverted}', '${solutionElementStatesConverted}', '${originalValuesConverted}', '${isCorrectValuesAtIndex}', '${durationString}', '${difficultyLevel}', ${numberMistakes})");
  }

  Future<void> updateSavedGame(
      int savedGameID,
      List<List<String>>? gameElementStates,
      List<List<String>>? solutionElementStates,
      List<List<bool>>? originalValues,
      List<List<bool>>? isCorrectValueAtIndex,
      String durationString,
      String difficultyLevel,
      int numberMistakes
      ) async {
    String gameElementStatesConverted = DatabaseConversion.convertStringListToString(gameElementStates);
    String solutionElementStatesConverted = DatabaseConversion.convertStringListToString(solutionElementStates);
    String originalValuesConverted = DatabaseConversion.convertBoolListToString(originalValues);
    String isCorrectValuesAtIndex = DatabaseConversion.convertBoolListToString(isCorrectValueAtIndex);
    final database = await initializedDB();
    String queryString = "UPDATE savedGames "
        "SET gameElementStates = '${gameElementStatesConverted}', "
        "solutionElementStates = '${solutionElementStatesConverted}', "
        "originalValues = '${originalValuesConverted}', "
        "correctValuesIndices = '${isCorrectValuesAtIndex}', "
        "secondsCounter = '${durationString}', "
        "difficultyLevel = '${difficultyLevel}', "
        "numberMistakes = ${numberMistakes}, "
        "WHERE savedGameID = $savedGameID";
    print(queryString);
    await database.rawQuery(queryString);
  }
  
  Future<int> getNewGameID() async {
    int newID = 0;
    final database = await initializedDB();
    var newGameID = await database.rawQuery("SELECT MAX(savedGameID) FROM savedGames");
    String newGameIDAsString = newGameID[0]['MAX(savedGameID)'].toString();
    if(newGameIDAsString != 'null'){
      newID = int.parse(newGameIDAsString);
    }
    newID = newID + 1;
    return newID;
  }

  Future<void> checkIfGameIDExists() async{

  }
}