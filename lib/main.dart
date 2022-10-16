import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:todoapp1/my_homepage.dart';
import 'package:todoapp1/task_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final applicationDocumentDir = 
  await path_provider.getApplicationDocumentsDirectory();
Hive.init(applicationDocumentDir.path);
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('TODOs');
runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
@override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'simple todo app Hive Database',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
       brightness: Brightness.dark,
    primaryColor: Color.fromARGB(255, 8, 74, 112),
      ),
      home: MyHomePage(),
    );
  }
}
