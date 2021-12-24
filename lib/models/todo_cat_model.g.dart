// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_cat_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoCatModelAdapter extends TypeAdapter<TodoCatModel> {
  @override
  final int typeId = 1;

  @override
  TodoCatModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodoCatModel()
      ..todos = (fields[2] as Map).map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as List).cast<TodoModel>()));
  }

  @override
  void write(BinaryWriter writer, TodoCatModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(2)
      ..write(obj.todos);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoCatModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
