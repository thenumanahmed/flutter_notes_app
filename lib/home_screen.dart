import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'models/notes_model.dart';
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
      body: ValueListenableBuilder<Box<NotesModel>>(
          //listenable is from hive for realtime changing
          valueListenable: Boxes.getData().listenable(),
          builder: (context, box, _) {
            var data = box.values.toList().cast<NotesModel>();
            return ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(data[index].title.toString()),
                              const SizedBox(height: 20),
                              Text(data[index].description.toString()),
                            ]),
                      ),
                    ),
                  );
                });
          }),
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
                  //   data.save();
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
