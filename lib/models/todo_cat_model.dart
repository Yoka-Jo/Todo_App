import 'package:new_todo_app/models/todo_model.dart';
import 'package:hive/hive.dart';
part 'todo_cat_model.g.dart';

@HiveType(typeId: 1)
class TodoCatModel extends HiveObject{
  @HiveField(2)
  late Map<String , List<TodoModel>> todos;
}