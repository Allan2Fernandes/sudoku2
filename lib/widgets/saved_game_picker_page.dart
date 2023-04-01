import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sudoku2/Styles.dart';
import 'package:sudoku2/database_classes/database.dart';
import 'package:sudoku2/database_classes/saved_game_entry.dart';
import 'package:sudoku2/widgets/no_saved_games_page.dart';
import 'package:sudoku2/widgets/saved_game_scroll_single_view.dart';

class SavedGamePicker extends StatefulWidget {
  const SavedGamePicker({Key? key}) : super(key: key);

  @override
  State<SavedGamePicker> createState() => _SavedGamePickerState();
}

class _SavedGamePickerState extends State<SavedGamePicker> {

  List<Map<String, dynamic>> listOfSavedGames = [];
  bool isLoading = true;



  void refreshListOfSavedGames() async {
    final data = await DataBaseHandler().getAllSavedGames(); //Consider using a THEN here if there are problems
    setState(() {
      listOfSavedGames = data;
      isLoading = false;
    });
  }

  @override
  void initState(){
    super.initState();
    //Get all saved games here. Set state here
    refreshListOfSavedGames();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("Going back");
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('SuDoKu'),
          centerTitle: true,
          backgroundColor: Styles.themeColor,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: Icon(Icons.settings),
                color: Colors.white,
                onPressed: (){
                },
              ),
            )
          ],
        ),
        body: isLoading? Center(child: CircularProgressIndicator()):listOfSavedGames.isNotEmpty?SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: this.listOfSavedGames.map((singleSavedGame) => SavedGameSrcollSingleView(key: Key(singleSavedGame['savedGameID'].toString()), savedGameInfo: singleSavedGame, onDelete: (int savedGameID) async {
                    setState(() {
                      isLoading = true;
                    });
                    await DataBaseHandler.deleteSavedGame(savedGameID);
                    refreshListOfSavedGames();
                  },
                  )).toList(),
                ),
              ],
            )
        )
            :NoSavedGamesPage(),
      ),
    );
  }
}
