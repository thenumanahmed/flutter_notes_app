import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/models/notes_model.dart';

import 'boxes/boxes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();
  final desController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showMyDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Notes'),
            content: SingleChildScrollView(
                child: Column(
              children: [
                //  title input field
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                //  description input field
                TextFormField(
                  controller: desController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Description',
                    border: OutlineInputBorder(),
                  ),
                )
              ],
            )),
            actions: [
              TextButton(
                onPressed: () {
                  //do nothing
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  //store the data
                  final data = NotesModel(
                    description: desController.text,
                    title: titleController.text,
                  );
                  final box = Boxes.getData();
                  box.add(data);
                  //saved in the storage (by hiveObject)
                  data.save();
                  //clear the controllers
                  titleController.clear();
                  desController.clear();
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              )
            ],
          );
        });
  }
}
