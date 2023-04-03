import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/models/notes_model.dart';
import 'package:path_provider/path_provider.dart';

import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //initializing hive db
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  //register the hive adapter
  Hive.registerAdapter(NotesModelAdapter());

  //open the hive box to store the data
  Hive.openBox<NotesModel>('notes');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
