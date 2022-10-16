import 'package:flutter/material.dart';
import 'package:todoapp1/task_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
        title: Text(' AttGöra Lista Hive Databas'),
        backgroundColor: Color.fromARGB(255, 25, 70, 148),
      ),
      body: 
      ValueListenableBuilder(
          valueListenable: Hive.box<Task>('TODOs').listenable(),
          // ignore: no_leading_underscores_for_local_identifiers
          builder: (context, Box<Task> _notesBox, _) {
            todoBox = _notesBox;
            color: Theme.of(context).primaryColor;
            return SizedBox(
              width: 400,
            height: 400,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  itemCount: _notesBox.values.length,
                  itemBuilder: (BuildContext context, int index) {
                    final todo = todoBox.getAt(index);
                    return Card(
                      child: ListTile(
                        tileColor: Color.fromARGB(255, 9, 64, 106),
                        title: Text(
                          todo!.task,
                          style: TextStyle(color: Color.fromARGB(255, 229, 232, 236), fontSize: 20.0),
                          ),
                        onLongPress: () => todoBox.deleteAt(index),
                        
                      ),
                    );
                  }
                  ),
            )
            )
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _simpleDialog(),
        tooltip: 'Lägg till en ny Antekning',
        child: Icon(Icons.add),
      ),
    );
  }

  _simpleDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Ny Anteckning'),
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Color.fromARGB(255, 17, 115, 227),
          ),
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Lägg till Anteckning',
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
                              foregroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 176, 74, 15)),
                              
                            ),
                            onPressed: () {
                              _task = Task(task: inputTask);
                              _addTodo(_task);
                              Navigator.pop(context);
                            },
                            child: Text('Lägg till'),
                          ),
                          TextButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Text('Stäng'),
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