import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_todo_app/layouts/cubit/cubit.dart';
import 'package:new_todo_app/models/todo_cat_model.dart';
import 'package:new_todo_app/models/todo_model.dart';
import 'package:new_todo_app/shared/components/components.dart';
import 'package:new_todo_app/shared/network/local/boxes.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:new_todo_app/shared/styles/icon_broken.dart';

class AddingTodoFAB extends StatelessWidget {
  
  const AddingTodoFAB({
    Key? key,
    required this.todoCubit,
    required this.formKey,
    required this.todoTextController,
    required this.todoDateController,
    required this.scaffoldKey,
  }) : super(key: key);

  final TodoAppCubit todoCubit;
  final GlobalKey<FormState> formKey;
  final TextEditingController todoTextController;
  final TextEditingController todoDateController;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (todoCubit.isBottomSheetShown) {
          if (formKey.currentState!.validate()) {
            todoCubit.addTodo(todoTextController.text, todoDateController.text);
          }
        } else {
          scaffoldKey.currentState!
              .showBottomSheet((context) => Form(
                    key: formKey,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 35.0),
                      height: 260.0,
                      child: Column(
                        children: [
                          DefaultTextForm(
                            controller: todoTextController,
                            labelText: "Todo Text",
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Add Text For Your Todo";
                              }
                            },
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          DefaultTextForm(
                              showCursor: false,
                              readOnly: true,
                              controller: todoDateController,
                              labelText: "Todo Date",
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please Add Date For Your Todo";
                                }
                              },
                              onTap: () async {
                                final chosenDate = await showDatePicker(
                                    context: (context),
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 29)));
                                if (chosenDate == null) {
                                  return;
                                }
                                todoDateController.text =
                                    DateFormat.yMMMd().format(chosenDate);
                              }),
                        ],
                      ),
                    ),
                  ))
              .closed
              .then((value) => todoCubit.changeBottomSheetState(isShow: false));
          todoCubit.changeBottomSheetState(isShow: true);
        }
      },
      child:  Icon(todoCubit.isBottomSheetShown? Icons.add : IconBroken.Edit),
    );
  }
}

class TodosContainerForCategory extends StatelessWidget {
  const TodosContainerForCategory({
    Key? key,
    required this.todoCubit,
  }) : super(key: key);

  final TodoAppCubit todoCubit;

  int todosInCategoryLength() => todoCubit.todosInCategory.length;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0, left: 10.0, right: 10.0),
      child: Column(
        children: [
          Text("ADD TO ${todoCubit.categoryName}" , style: const TextStyle(fontWeight: FontWeight.bold),),
          Container(
            height: 100.0,
            margin: EdgeInsets.zero,
            color: Colors.black12,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: todosInCategoryLength(),
                itemBuilder: (context, i) => Container(
                      width: 60.0,
                      padding: const EdgeInsets.all(6.0),
                      color: Colors.black,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${i + 1}',
                              style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          Text(i > 0 ? "TODOS" : "TODO",
                              style:
                                  const TextStyle(color: Colors.white)),
                        ],
                      ),
                    )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red)),
                    child: const Text('Close'),
                    onPressed: () {
                      todoCubit.restetCategoryList();
                    }),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                    child: const Text('Done'),
                    onPressed: () {
                      if(todoCubit.todosInCategory.isNotEmpty){
                      todoCubit.makeCategory();
                      }
                    }),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class PopMenu extends StatefulWidget {
  final Widget child;
  final TodoAppCubit todoCubit;
  final TodoModel todo;
  final bool canAccessCategory;
  const PopMenu({Key? key, required this.child, required this.todoCubit , required this.todo , required this.canAccessCategory})
      : super(key: key);

  @override
  State<PopMenu> createState() => _PopMenuState();
}

class _PopMenuState extends State<PopMenu> {
  late TextEditingController categoryNameController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    categoryNameController = TextEditingController();
  }


  showCustomDialog(BuildContext context) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                const Text(
                  'Add Your Category Name',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 12),
                Form(
                  key: formKey,
                  child: DefaultTextForm(
                      labelText: "Category Name",
                      controller: categoryNameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Add a Category Name";
                        }
                      }),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red)),
                      child: const Text('Close'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 15),
                    ElevatedButton(
                        child: const Text('Done'),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            widget.todoCubit
                                .putCategoryName(categoryNameController.text , widget.todo);
                                Navigator.of(context).pop();
                          }
                        }),
                  ],
                )
              ],
            ),
          ),
        ),
      );

void showSimpleDialog(BuildContext context) => showDialog(
        context: context,
        builder:(context)=>
            ValueListenableBuilder<Box<TodoCatModel>>(
                    valueListenable: Boxes.getCategories().listenable(),
                    builder: (context, box, _) {
            final todosCategory = box.values.toList().cast<TodoCatModel>();
            return
         SimpleDialog(
          title:  Center(child: Text(todosCategory.isNotEmpty ? "Select Category" : "No Categories")),
          children: <Widget>[ ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: todosCategory.length,
              itemBuilder: (context , i) {
                return SimpleDialogOption(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  onPressed: () {
                    widget.todoCubit.addToExistingCategory(todosCategory[i], widget.todo);
                    Navigator.pop(context);
                  },
                  child: Text('${todosCategory[i].todos.keys.first} Category', style: const TextStyle(fontSize: 16 , color: Colors.blue , fontWeight: FontWeight.bold)),
                );
              }
            )
          ],
        );

}
      )
);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        offset: const Offset(10.0, 80.0),
        color: Colors.blue,
        child: widget.child,
        enabled: (!widget.todoCubit.isAddingCategory) && (widget.canAccessCategory),
        onSelected: (popupMenuItemIndex) {
          if (popupMenuItemIndex == 0) {
            showCustomDialog(context);
          } else {
            showSimpleDialog(context);
          }
        },
        itemBuilder: (context) => const [
              PopupMenuItem(
                value: 0,
                child: Text(
                  "Make A new Category",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: Text(
                  "Add to existing Category",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
              )
            ]);
  }
}
