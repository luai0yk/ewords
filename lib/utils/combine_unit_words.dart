import 'package:ewords/args/passage_args.dart';
import 'package:ewords/db/words_helper.dart';

import '../models/word_model.dart';

class CombineUnitWords {
  static Future<String> getCombinedWords(PassageArgs passageArgs) async {
    /*Enquire for the unit words*/
    List<WordModel> list = await WordsHelper.instance.getWords(
      bookId: passageArgs.bookId,
      unitId: passageArgs.unitId,
    );
    /*wordToSpeak is the variable which will hold all words, definitions, and
                        * examples of the unit*/
    String combinedWords = '';
    /*Combine all the unit words in one string in order to speak them*/
    for (var element in list) {
      combinedWords +=
          "${element.word}\n${element.definition}\nExample: ${element.example}\n\n";
    }

    return combinedWords;
  }
}
