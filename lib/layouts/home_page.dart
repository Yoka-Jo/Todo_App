import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_todo_app/layouts/cubit/cubit.dart';
import 'package:new_todo_app/layouts/cubit/states.dart';
import 'package:new_todo_app/shared/styles/icon_broken.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoAppCubit, TodoAppStates>(
      builder: (context, state) {
        final todoCubit = TodoAppCubit.get(context);
        return Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: todoCubit.currentNavIndex,
              onTap: (index){
                todoCubit.changeNavScreen(index);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(IconBroken.Home) , label: "All Todos"),
                BottomNavigationBarItem(icon: Icon(IconBroken.Category) , label: "Todos Cat"),
              ],
            ),
            body: todoCubit.bottomNavBarWidgets[todoCubit.currentNavIndex],
            );
      },
    );
  }
}
