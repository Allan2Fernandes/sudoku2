
class DifficultyLevel{
  static List<String> possibleDifficulties = <String>[
    "Easy",
    "Medium",
    "Hard"
  ];
  static int setDifficultyIndex = 0;
  static String setDifficulty = possibleDifficulties[setDifficultyIndex];

  static void setTheDifficidultyEasy(){
    setDifficultyIndex = 0;
    updateSetDifficulty();
  }
  static void setTheDifficultyMedium(){
    setDifficultyIndex = 1;
    updateSetDifficulty();
  }
  static void setTheDifficultyHard(){
    setDifficultyIndex = 2;
    updateSetDifficulty();
  }

  static updateSetDifficulty(){
    setDifficulty = possibleDifficulties[setDifficultyIndex];
  }
}