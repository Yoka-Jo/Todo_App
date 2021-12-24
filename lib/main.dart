import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:new_todo_app/layouts/cubit/cubit.dart';
import 'package:new_todo_app/layouts/home_page.dart';
import 'package:new_todo_app/shared/bloc_observer.dart';

import 'models/todo_cat_model.dart';
import 'models/todo_model.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoModelAdapter());
  Hive.registerAdapter(TodoCatModelAdapter());
  await Hive.openBox<TodoModel>("todos");
  await Hive.openBox<TodoCatModel>("categories");
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoAppCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Manage Your Day',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}
