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
                            Row(
                              children: [
                                Text(data[index].title.toString()),
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    _delete(data[index]);
                                  },
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                InkWell(
                                  onTap: () {
                                    _editNotesDialog(
                                      data[index],
                                      data[index].title.toString(),
                                      data[index].description.toString(),
                                    );
                                  },
                                  child: const Icon(Icons.edit),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(data[index].description.toString()),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _addNotesDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _delete(NotesModel notesModel) {
    notesModel.delete();
  }

  Future<void> _editNotesDialog(
    NotesModel notesModel,
    String title,
    String description,
  ) async {
    titleController.text = title;
    desController.text = description;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit Notes'),
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
                  notesModel.title = titleController.text.toString();
                  notesModel.description = desController.text.toString();

                  notesModel.save();

                  titleController.clear();
                  desController.clear();

                  Navigator.pop(context);
                },
                child: const Text('Edit'),
              )
            ],
          );
        });
  }

  Future<void> _addNotesDialog() async {
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
