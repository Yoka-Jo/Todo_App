import 'package:hive/hive.dart';
part 'todo_model.g.dart';

@HiveType(typeId: 0)

class TodoModel extends HiveObject{
  @HiveField(0)
  late String text;
  @HiveField(1)
  late bool state;
  @HiveField(2)
  late String date;
  @override
  @HiveField(3)
  late String key;
}