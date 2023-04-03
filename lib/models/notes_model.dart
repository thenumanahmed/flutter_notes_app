import 'package:hive/hive.dart';

//it will be created by builder_runner
// command
// flutter packages pub run build_runner build
part 'notes_model.g.dart';

//typeid is id for the model
@HiveType(typeId: 0)
//extended with hive object for auto storing keys etc
class NotesModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  NotesModel({
    required this.description,
    required this.title,
  });
}
