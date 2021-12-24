abstract class TodoAppStates {}

class TodoAppInitialState extends TodoAppStates {}

class TodoAppDeleteCategorySuccessState extends TodoAppStates {}

class TodoAppDeleteCategoryFailureState extends TodoAppStates {
  final String error;
  TodoAppDeleteCategoryFailureState({
    required this.error,
  });
}

class TodoAppDeleteTodoSuccessState extends TodoAppStates {}

class TodoAppDeleteTodoFailureState extends TodoAppStates {
  final String error;
  TodoAppDeleteTodoFailureState({
    required this.error,
  });
}

class TodoAppEditTodoSuccessState extends TodoAppStates {}

class TodoAppEditTodoFailureState extends TodoAppStates {
  final String error;
  TodoAppEditTodoFailureState({
    required this.error,
  });
}

class TodoAppAddTodosSuccessState extends TodoAppStates {}

class TodoAppAddTodosFailureState extends TodoAppStates {
  final String error;
  TodoAppAddTodosFailureState({
    required this.error,
  });
}

class TodoAppAddTodosToCategorySuccessState extends TodoAppStates {}

class TodoAppAddTodosToCategoryFailureState extends TodoAppStates {
  final String error;
  TodoAppAddTodosToCategoryFailureState({
    required this.error,
  });
}

class TodoAppGetTodosSuccessState extends TodoAppStates {}

class TodoAppGetTodosFailureState extends TodoAppStates {
  final String error;
  TodoAppGetTodosFailureState({
    required this.error,
  });
}


class TodoAppAddToCategoeySuccessState extends TodoAppStates {}

class TodoAppDeleteFromCategoryState extends TodoAppStates {}

class TodoAppChangeBottomSheetState extends TodoAppStates {}

class TodoAppIsAddingCategoryState extends TodoAppStates {}

class TodoAppBottomNavChangeState extends TodoAppStates {}