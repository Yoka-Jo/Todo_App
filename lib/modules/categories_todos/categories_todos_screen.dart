import 'package:flutter/material.dart';
import 'package:new_todo_app/layouts/cubit/cubit.dart';
import 'package:new_todo_app/models/todo_model.dart';
import 'package:new_todo_app/shared/components/components.dart';

class CategoriesTodosScreen extends StatelessWidget {
  final Map<String, List<TodoModel>> todos;
  const CategoriesTodosScreen({ Key? key  , required this.todos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${todos.keys.first} Todo List"),
      ),
      body: TodosList(todoCubit: TodoAppCubit.get(context),todos:todos.values.first , canAccessCategory: false,),
    );
  }
}