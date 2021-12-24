import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_todo_app/layouts/cubit/states.dart';
import 'package:new_todo_app/models/todo_cat_model.dart';
import 'package:new_todo_app/models/todo_model.dart';
import 'package:new_todo_app/modules/all_todos/all_todos_screen.dart';
import 'package:new_todo_app/modules/categories/categories_screen.dart';
import 'package:new_todo_app/shared/network/local/boxes.dart';

class TodoAppCubit extends Cubit<TodoAppStates> {
  TodoAppCubit() : super(TodoAppInitialState());

  static TodoAppCubit get(context) => BlocProvider.of(context);

  void addTodo(String text, String date) {
    final todo = TodoModel()
      ..text = text
      ..date = date
      ..state = false
      ..key = DateTime.now().toString();
    try {
      final box = Boxes.getTodos();
      box.add(todo);
      emit(TodoAppAddTodosSuccessState());
    } catch (error) {
      emit(TodoAppAddTodosFailureState(
          error: "There is a problem to add this Todo"));
    }

  }

  void editTodoSate(TodoModel todo) {
    try {
      todo.state = !todo.state;
      todo.save();
      emit(TodoAppEditTodoSuccessState());
    } catch (error) {
      emit(TodoAppEditTodoFailureState(
          error: "There is a problem to edit this Todo"));
    }
  }

  void makeCategory(){
    for(int i = 0; i < todosInCategory.length; i++){
      todosInCategory[i].delete();
    }
    final todos = TodoCatModel()..todos={categoryName: todosInCategory};
        try {
      final box = Boxes.getCategories();
      box.add(todos);
      restetCategoryList();
      emit(TodoAppAddTodosToCategorySuccessState());
    } catch (error) {
      emit(TodoAppAddTodosToCategoryFailureState(
          error: "There is a problem to make this category"));
    }
  }

  void removeCategory(TodoCatModel category){
        try {
      category.delete();
      emit(TodoAppDeleteCategorySuccessState());
    } catch (error) {
      emit(TodoAppDeleteCategoryFailureState(
          error: "There is a problem to delete this Category"));
    }
   
  }


  void addToExistingCategory(TodoCatModel category , TodoModel newTodo) {
    try {
      category.todos.values.single.add(newTodo);
      category.save();
      newTodo.delete();
      emit(TodoAppEditTodoSuccessState());
    } catch (error) {
      emit(TodoAppEditTodoFailureState(
          error: "There is a problem to edit this Todo"));
    }
  }

  void deleteTodo(TodoModel todo) {
    try {
      todo.delete();
      emit(TodoAppDeleteTodoSuccessState());
    } catch (error) {
      emit(TodoAppDeleteTodoFailureState(
          error: "There is a problem to delete this Todo"));
    }
  }

    List<TodoModel> todosInCategory = [];

    void addToCategoryList(TodoModel todo){
      todosInCategory.add(todo);
      emit(TodoAppAddToCategoeySuccessState());

    }

    void removeFromCategoryList(TodoModel todo){
      todosInCategory.removeWhere((element) => element.key == todo.key);
      emit(TodoAppDeleteFromCategoryState());
    }

    void restetCategoryList(){
    todosInCategory = [];
    changeIsAddingCategoryState();
    }


  bool isAddingCategory = false;

  void changeIsAddingCategoryState() {
    isAddingCategory = !isAddingCategory;
    emit(TodoAppIsAddingCategoryState());
  }

  late String categoryName;
  void putCategoryName(String name , TodoModel todoAskedForCategory){
    categoryName = name;
    todosInCategory.add(todoAskedForCategory);
    changeIsAddingCategoryState();
  }

  bool isBottomSheetShown = false;

  void changeBottomSheetState({
    required bool isShow,
  }) {
    isBottomSheetShown = isShow;
    emit(TodoAppChangeBottomSheetState());
  }

  List<Widget> bottomNavBarWidgets = const [
    AllTodosScreen(),
    CategoriesScreen(),
  ];
  int currentNavIndex = 0;

  void changeNavScreen(int index) {
    currentNavIndex = index;
    emit(TodoAppBottomNavChangeState());
  }
}
