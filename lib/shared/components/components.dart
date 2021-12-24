import 'package:flutter/material.dart';
import 'package:new_todo_app/layouts/cubit/cubit.dart';
import 'package:new_todo_app/models/todo_model.dart';
import 'package:new_todo_app/modules/all_todos/widgets/widgets.dart';

class TodoCard extends StatelessWidget {
  final Widget child;
  const TodoCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        height: 80,
        width: double.infinity,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 4),
                blurRadius: 5,
                spreadRadius: 2),
          ],
          color: Colors.white70,
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: child);
  }
}

class DefaultTextForm extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  final bool? showCursor;
  final bool readOnly;
  const DefaultTextForm({
    Key? key,
    required this.labelText,
    required this.controller,
    required this.validator,
    this.onTap,
    this.showCursor,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      controller: controller,
      showCursor: showCursor,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(6),
          ),
        ),
      ),
    );
  }
}

class TodosList extends StatelessWidget {
  const TodosList({
    Key? key,
    required this.todos,
    required this.todoCubit,
    this.canAccessCategory = true
  }) : super(key: key);

  final List<TodoModel> todos;
  final TodoAppCubit todoCubit;
  final bool canAccessCategory;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, i) {
        return Column(
          children: [
            Dismissible(
                key: ValueKey(i),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    todoCubit.editTodoSate(todos[i]);
                  } else {
                    showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                              title: const Text('Are You Sure!'),
                              content: const Text(
                                  'You\'re about to delete this Todo'),
                              actions: [
                                TextButton(
                                  child: const Text(
                                    'No',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  onPressed: () =>
                                      Navigator.of(context).pop(),
                                ),
                                TextButton(
                                    child: const Text(
                                      'Yes',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();

                                      todoCubit.deleteTodo(todos[i]);
                                    })
                              ],
                            ));
                  }
                },
                secondaryBackground: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerRight,
                  color: todos[i].state ? Colors.grey : Colors.green,
                  child: Icon(
                    todos[i].state ? Icons.archive_outlined : Icons.done,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                background: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerRight,
                  color: Colors.red,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.delete,
                        size: 60,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                child: PopMenu(
                  canAccessCategory: canAccessCategory,
                  todo: todos[i],
                  todoCubit: todoCubit,
                  child: TodoCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                todos[i].text,
                              ),
                              Text(
                                todos[i].date,
                                style: const TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                        todoCubit.isAddingCategory
                            ? IconButton(
                                icon: Icon(todoCubit.todosInCategory
                                        .contains(todos[i])
                                    ? Icons.minimize
                                    : Icons.add),
                                onPressed: () {
                                  if (todoCubit.todosInCategory
                                      .contains(todos[i])) {
                                    todoCubit
                                        .removeFromCategoryList(todos[i]);
                                  } else {
                                    todoCubit.addToCategoryList(todos[i]);
                                  }
                                })
                            : Icon(
                                Icons.brightness_1_rounded,
                                color: todos[i].state
                                    ? Colors.green
                                    : Colors.grey,
                              )
                      ],
                    ),
                  ),
                )),
            if (todos.length == i + 1)
              const SizedBox(
                height: 50.0,
              )
          ],
        );
      },
    );
  }
}
