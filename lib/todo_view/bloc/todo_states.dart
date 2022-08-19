part of 'todo_bloc.dart';

class TodoState extends Equatable {
  final bool isLoading;
  final BaseExceptions? error;
  final FilterTodosBase filterTodosBase;
  final List<TodoModel>? listOfTodos;
  const TodoState(
      {this.isLoading = true,
      this.error,
      this.listOfTodos,
      this.filterTodosBase = FilterTodosBase.all});
  const TodoState.loading(
      {this.isLoading = true,
      this.error,
      this.listOfTodos = const [],
      this.filterTodosBase = FilterTodosBase.all});
  const TodoState.error(
      {this.isLoading = false,
      required this.error,
      this.filterTodosBase = FilterTodosBase.all,
      this.listOfTodos = const []});
  const TodoState.success({
    this.isLoading = false,
    this.error,
    this.listOfTodos = const [],
    this.filterTodosBase = FilterTodosBase.all,
  });
  @override
  List<Object?> get props => [isLoading, error, filterTodosBase];
}
