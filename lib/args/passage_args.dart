import '../models/passage_model.dart';

class PassageArgs extends PassageModel {
  PassageArgs({
    required super.unitId,
    required super.bookId,
    required super.passageTitle,
    required super.passage,
  }) : super(id: -1);
}
