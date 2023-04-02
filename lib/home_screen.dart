import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: Hive.openBox('abc'),
              builder: (context, snapshot) {
                return Text(snapshot.data!.get('name').toString());
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //creating separate file
          var box = await Hive.openBox('abc');
          box.put('name', 'abc-name');
          box.put('age', 25);
          box.put('details', {'detail1': '1', 'detail2': '2'});

          print(box.get('name'));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
