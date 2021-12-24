import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_todo_app/layouts/cubit/cubit.dart';
import 'package:new_todo_app/layouts/cubit/states.dart';
import 'package:new_todo_app/models/todo_model.dart';
import 'package:new_todo_app/modules/all_todos/widgets/widgets.dart';
import 'package:new_todo_app/shared/components/components.dart';
import 'package:new_todo_app/shared/network/local/boxes.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AllTodosScreen extends StatefulWidget {
  const AllTodosScreen({Key? key}) : super(key: key);

  @override
  State<AllTodosScreen> createState() => _AllTodosScreenState();
}

class _AllTodosScreenState extends State<AllTodosScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final formKey = GlobalKey<FormState>();

  late TextEditingController todoTextController;

  late TextEditingController todoDateController;

  @override
  void initState() {
    super.initState();
    TodoAppCubit.get(context).changeBottomSheetState(isShow: false);
    todoTextController = TextEditingController();
    todoDateController = TextEditingController();
  }

  @override
  void dispose() {
    todoTextController.dispose();
    todoDateController.dispose();
    super.dispose();
  }

  void snackBar(String contentText) => ScaffoldMessenger.of(context)..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(contentText)));

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final todoCubit = TodoAppCubit.get(context);
      return BlocConsumer<TodoAppCubit, TodoAppStates>(
        listener: (context, state) {
          if (state is TodoAppAddTodosSuccessState) {
            todoTextController.clear();
            todoDateController.clear();
            Navigator.of(context).pop();
          }
          if (state is TodoAppGetTodosFailureState) {
            snackBar(state.error);
          } else if (state is TodoAppAddTodosFailureState) {
            snackBar(state.error);
          }
        },
        builder: (context, state) {
          return Scaffold(
              key: scaffoldKey,
              floatingActionButton: AddingTodoFAB(
                  todoCubit: todoCubit,
                  formKey: formKey,
                  todoTextController: todoTextController,
                  todoDateController: todoDateController,
                  scaffoldKey: scaffoldKey),
              body: Column(
                children: [
                  if (todoCubit.isAddingCategory)
                    TodosContainerForCategory(todoCubit: todoCubit),
                  ValueListenableBuilder<Box<TodoModel>>(
                      valueListenable: Boxes.getTodos().listenable(),
                      builder: (context, box, _) {
                        final todos = box.values.toList().cast<TodoModel>();
                        return Expanded(child: TodosList(todos: todos, todoCubit: todoCubit));
                      }),
                ],
              ));
        },
      );
    });
  }
}