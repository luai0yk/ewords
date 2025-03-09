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

  static List<String> levelDescription = [
    'Learn and recognize basic words for everyday situations.',
    'Acquire vocabulary for simple tasks and routine matters.',
    'Expand word knowledge to handle familiar topics effectively.',
    'Broaden vocabulary to comprehend complex texts and engage fluently.',
    'Master a wide range of words for flexible use in various contexts.',
    'Attain an extensive vocabulary to express ideas effortlessly.',
  ];

  static List<String> levelNames = [
    'Beginner',
    'Elementary',
    'Intermediate',
    'Upper-Intermediate',
    'Advanced',
    'Proficient'
  ];

  static List<String> levelCodes = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
}
