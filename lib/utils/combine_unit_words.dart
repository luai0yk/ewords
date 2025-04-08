import 'package:ewords/models/word_model.dart';

class CombineUnitWords {
  static Future<String> getCombinedWords(List<WordModel> words) async {
    /*wordToSpeak is the variable which will hold all words, definitions, and
                        * examples of the unit*/
    String combinedWords = '';
    /*Combine all the unit words in one string in order to speak them*/
    for (var element in words) {
      combinedWords +=
          "${element.word.substring(0, 1).toUpperCase() + element.word.substring(1)}\n${element.definition}\nExample: ${element.example}\n\n";
    }

    return combinedWords;
  }
}
