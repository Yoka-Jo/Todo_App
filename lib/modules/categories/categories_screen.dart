import 'package:flutter/material.dart';
import 'package:new_todo_app/layouts/cubit/cubit.dart';
import 'package:new_todo_app/models/todo_cat_model.dart';
import 'package:new_todo_app/modules/categories_todos/categories_todos_screen.dart';
import 'package:new_todo_app/shared/components/components.dart';
import 'package:new_todo_app/shared/network/local/boxes.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<Box<TodoCatModel>>(
          valueListenable: Boxes.getCategories().listenable(),
          builder: (context, box, _) {
            final todosCategory = box.values.toList().cast<TodoCatModel>();
            return ListView.builder(
              itemCount: todosCategory.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CategoriesTodosScreen(todos: todosCategory[i].todos)));
                  },
                  child: Dismissible(
                    key: ValueKey(i),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction)async{
                       return showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                                  title: const Text('Are You Sure!'),
                                  content: const Text(
                                      'You\'re about to delete this Category'),
                                  actions: [
                                    TextButton(
                                      child: const Text(
                                        'No',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                    ),
                                    TextButton(
                                        child: const Text(
                                          'Yes',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        })
                                  ],
                                ));
                    },
                    onDismissed: (direction){
                      TodoAppCubit.get(context).removeCategory(todosCategory[i]);
                    },
                    background: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.centerRight,
                      color: Colors.red,
                      child: const Icon(
                        Icons.delete,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    child: TodoCard(
                        child: Row(
                      children: [
                        Container(
                          height: 70.0,
                          width: 70.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            color: Colors.black,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${todosCategory[i].todos.values.first.length}",
                                style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              const Text(
                                "Todos",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 25.0,
                        ),
                        Expanded(
                          child: Text(
                              "${todosCategory[i].todos.keys.first} Todos List",
                              style: const TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold)),
                        )
                      ],
                    )),
                  ),
                );
              },
            );
          }),
    );
  }
}
