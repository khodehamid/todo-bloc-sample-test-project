part of './todo_bloc.dart';

abstract class TodoEvents extends Equatable {
  const TodoEvents();
}

class InitializeApplication extends TodoEvents {
  final String dbPath;
  const InitializeApplication({required this.dbPath});
  @override
  List<Object?> get props => [dbPath];
}

class CreateTodoPressed extends TodoEvents {
  final String title;
  final String? description;
  final bool isComplete;
  final DateTime createdAt;

  const CreateTodoPressed({
    required this.title,
    this.description,
    this.isComplete = false,
    required this.createdAt,
  });
  @override
  List<Object?> get props => [
        title,
        description,
        isComplete,
        createdAt,
      ];
}

class DeleteTodoPressed extends TodoEvents {
  final String todoId;
  const DeleteTodoPressed({required this.todoId});
  @override
  List<Object?> get props => [todoId];
}

class SortTodoPressed extends TodoEvents {
  final FilterTodosBase filterBase;
  const SortTodoPressed({required this.filterBase});
  @override
  List<Object?> get props => [filterBase];
}

class EditTodoPressed extends TodoEvents {
  final TodoModel editedTodoModel;
  const EditTodoPressed({required this.editedTodoModel});
  @override
  List<Object?> get props => [editedTodoModel];
}

class GetAllTodosPressed extends TodoEvents {
  final List<TodoModel> todos;
  final BaseExceptions? exception;
  final bool isLoading;

  const GetAllTodosPressed({
    this.todos = const [],
    this.exception,
    this.isLoading = false,
  });
  @override
  List<Object?> get props => [
        todos,
        exception,
        isLoading,
      ];
}