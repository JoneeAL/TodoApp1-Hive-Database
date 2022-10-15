import 'package:flutter/material.dart';
import 'package:todoapp1/task_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp1/main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String inputTask;

 late Task _task;

  late Box<Task> todoBox;

  void _addTodo(Task inputTodo) {
    todoBox.add(Task(task: inputTodo.task));
  }

  @override
  Widget build(BuildContext context) {
    // notesBox.clear();
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple TODO app using Hive'),
      ),
      body: ValueListenableBuilder(
          valueListenable: Hive.box<Task>('TODOs').listenable(),
          builder: (context, Box<Task> _notesBox, _) {
            todoBox = _notesBox;
            return ListView.builder(
                itemCount: _notesBox.values.length,
                itemBuilder: (BuildContext context, int index) {
                  final todo = todoBox.getAt(index);
                  return ListTile(
                    title: Text(todo!.task),
                    onLongPress: () => todoBox.deleteAt(index),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _simpleDialog(),
        tooltip: 'AddNewTODOTask',
        child: Icon(Icons.add),
      ),
    );
  }

  _simpleDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('New TODO Task'),
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'TODO Task',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) => inputTask = value,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                            ),
                            onPressed: () {
                              _task = Task(task: inputTask);
                              _addTodo(_task);
                              Navigator.pop(context);
                            },
                            child: Text('Add'),
                          ),
                          TextButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // remove the deleted index holes/slots from database
    // to free up the space
    todoBox.compact();

    todoBox.close();
    super.dispose();
  }
}