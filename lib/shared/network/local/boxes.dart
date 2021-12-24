

import 'package:hive_flutter/hive_flutter.dart';
import 'package:new_todo_app/models/todo_cat_model.dart';
import 'package:new_todo_app/models/todo_model.dart';

class Boxes {
  static Box<TodoModel> getTodos() => 
  Hive.box<TodoModel>("todos");

  static Box<TodoCatModel> getCategories() => 
  Hive.box<TodoCatModel>("categories");
}