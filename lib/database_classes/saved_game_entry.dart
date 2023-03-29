

class SavedGameEntry{
  late int savedGameID;
  late String gameElementStates;
  late String solutionElementStates;
  late String originalValues;
  late String correctValuesIndices;
  late String durationString;
  late String difficultyLevel;
  late int numberMistakes;
  late String saveTime;

  //Constructor
  SavedGameEntry(this.savedGameID,
      this.gameElementStates,
      this.solutionElementStates,
      this.originalValues,
      this.correctValuesIndices,
      this.durationString,
      this.difficultyLevel,
      this.numberMistakes,
      this.saveTime
      );

  Map<String, dynamic> getGameMap(){
    final gameMap = {
      'savedGameID': this.savedGameID,
      'gameElementStates': this.gameElementStates,
      'solutionElementStates': this.solutionElementStates,
      'originalValues': this.originalValues,
      'correctValuesIndices': this.correctValuesIndices,
      'durationString': this.durationString,
      'difficultyLevel': this.difficultyLevel,
      'numberMistakes': this.numberMistakes,
      'saveTime': this.saveTime
    };
    return gameMap;
  }
}