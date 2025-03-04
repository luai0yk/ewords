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
    'A1 - Beginner: Understand and use basic phrases for immediate needs.',
    'A2 - Elementary: Communicate in simple tasks and routine matters.',
    'B1 - Intermediate: Handle familiar topics and situations effectively.',
    'B2 - Upper-Intermediate: Comprehend complex texts and interact fluently.',
    'C1 - Advanced: Use language flexibly in social, academic, and professional contexts.',
    'C2 - Proficient: Understand virtually everything and express ideas effortlessly.',
  ];

  static List<String> levels = [
    'A1 - Beginner',
    'A2 - Elementary',
    'B1 - Intermediate',
    'B2 - Upper-Intermediate',
    'C1 - Advanced',
    'C2 - Proficient'
  ];
}
