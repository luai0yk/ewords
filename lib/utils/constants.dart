import 'package:ewords/models/unit_model.dart';

class MyConstants {
  static String ID = 'Id';
  static String UNIT_ID = 'Unit_Id';
  static String LAST_UNIT_INDEX = 'last_unit_index';
  static String BOOK_ID = 'Book_Id';
  static String WORD = 'Word';
  static String DEFINITION = 'Definition';
  static String EXAMPLE = 'Example';
  static String PASSAGE_TITLE = 'Unit_Title';
  static String PASSAGE = 'Reading';

  static List<UnitModel>? units;

  static List<String> bookDescription = [
    'Get started with the most common words',
    'Get started with the most common words',
    'Figure out the intermediate words',
    'Figure out the intermediate words',
    'Be advanced by knowing some hard words',
    'Be advanced by knowing some hard words',
  ];

  static List<String> levels = [
    'Beginner',
    'Elementary',
    'Intermediate',
    'Upper-Intermediate',
    'Advanced',
    'Proficient'
  ];
}
