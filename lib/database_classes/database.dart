import 'package:sqflite/sqflite.dart' as sql;
import 'package:sudoku2/database_classes/saved_game_entry.dart';

class DataBaseHandler{
  static String dbName = 'Sudoku2.db';

  static Future<void> createTables(sql.Database database) async{
    print("Creating table");
    await database.execute(
      """
      CREATE TABLE savedGames (
      savedGameID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      gameElementStates TEXT NOT NULL,
      solutionElementStates TEXT NOT NULL,
      originalValues TEXT NOT NULL,
      correctValuesIndices TEXT NOT NULL,
      durationString TEXT NOT NULL,
      difficultyLevel TEXT NOT NULL,
      numberMistakes INT NOT NULL,
      saveTime TEXT NOT NULL,
      isComplete INT NOT NULL
      )
      """
    );
  }

  static Future<sql.Database> db() async{
    return await sql.openDatabase(
        'Sudoku2.db',
        version: 1,
        onCreate: (sql.Database database, int version) async{
          await createTables(database);
        }
    );
  }

  static Future<int> createSavedGame(SavedGameEntry savedGameEntry) async {
    final db = await DataBaseHandler.db();
    final data = savedGameEntry.getGameMap();
    final savedGameID = await db.insert('savedGames', data,
    conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return savedGameID;
  }

  static Future<void> deleteSavedGame(int savedGameID) async{
    final db = await DataBaseHandler.db();
    try{
      await db.delete('savedGames', where: 'savedGameID = ?', whereArgs: [savedGameID]);
    }catch(error){
      print("Error deleting item with error: $error");
    }
  }


  static Future<int> getNewGameID() async {
    int newID = 0;
    sql.Database openedDatabase = await sql.openDatabase(dbName, version: 1, onCreate: (sql.Database database, int version) async{
      await createTables(database);
    });
    var newGameID = await openedDatabase.rawQuery("SELECT MAX(savedGameID) FROM savedGames");
    String newGameIDAsString = newGameID[0]['MAX(savedGameID)'].toString();
    if(newGameIDAsString != 'null'){
      newID = int.parse(newGameIDAsString);
    }
    newID = newID + 1;
    print(newID);
    return newID;
  }

  Future<List<Map<String, dynamic>>> getAllSavedGames() async{
    final db = await DataBaseHandler.db();
    return db.query('savedGames', where: 'isComplete = ?', whereArgs: [0], orderBy: 'savedGameID');
  }
}