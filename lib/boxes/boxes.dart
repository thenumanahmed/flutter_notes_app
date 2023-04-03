import 'package:hive/hive.dart';
import 'package:notes_app/models/notes_model.dart';

//to get all the boxes we have created
class Boxes {
  static Box<NotesModel> getData() => Hive.box<NotesModel>('notes');
}
