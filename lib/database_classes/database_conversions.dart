
class DatabaseConversion{
  static String convertStringListToString(var list){
    String convertedString = "";
    for(int i = 0; i<9; i++){
      for(int j = 0; j<9; j++){
        if(list[i][j] == ""){
          convertedString = "${convertedString}0";
        }else{
          convertedString = convertedString + list[i][j];
        }
      }
    }
    return convertedString;
  }

  static List<List<String>> convertStringToStringList(String savedString){
    int pointer = 0;
    List<List<String>> reconstructedList = List.generate(9, (rowIndex) =>
      List.generate(9, (columnIndex) => "0")
    );
    for(int i= 0; i < 9; i++){
      for(int j = 0; j < 9; j++){
        String value;
        if(savedString[pointer] == "0"){
          value = "";
        }else{
          value = savedString[pointer];
        }
        reconstructedList[i][j] = value;
        pointer++;
      }
    }
    return reconstructedList;
  }

  static String convertBoolListToString(var list){
    String convertedString = "";
    for(int i = 0; i<9; i++){
      for(int j = 0; j<9; j++){
        if(list[i][j] == true){
          convertedString = "${convertedString}1";
        }else{
          convertedString = "${convertedString}0";
        }
      }
    }
    return convertedString;
  }

  static List<List<bool>> convertStringToBoolList(String savedString){
    int pointer = 0;
    List<List<bool>> reconstructedList = List.generate(9, (rowIndex) =>
        List.generate(9, (columnIndex) => false)
    );
    for(int i= 0; i < 9; i++){
      for(int j = 0; j < 9; j++){
        bool value;
        if(savedString[pointer] == "0"){
          value = false;
        }else{
          value = true;
        }
        reconstructedList[i][j] = value;
        pointer++;
      }
    }
    return reconstructedList;
  }

  static int getSecondsFromStringCounter(String counter){
    int convertedSeconds = 0;
    String numMinutes;
    String numSeconds;
    numMinutes = counter.substring(0, 2);
    numSeconds = counter.substring(3);
    convertedSeconds = int.parse(numMinutes)*60 + int.parse(numSeconds);
    return convertedSeconds;
  }
}