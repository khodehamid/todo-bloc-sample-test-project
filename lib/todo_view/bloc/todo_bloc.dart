import 'dart:async';
import 'dart:developer';

import 'package:base_repository/base_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_project_test/utils/utils.dart';
import 'package:todo_api/todo_api.dart';
import 'package:todo_repository/todo_repository.dart';
import 'package:uuid/uuid.dart';

part './todo_events.dart';
part './todo_states.dart';

class TodoBloc extends Bloc<TodoEvents, TodoState> {
  StreamSubscription? _streamSubscription;
  final TodoRepository _todoRepository;
  TodoBloc({
    required TodoRepository todoRepository,
  })  : _todoRepository = todoRepository,
        super(const TodoState.loading()) {
    on<InitializeApplication>(_onInitializeApplication);
    on<CreateTodoPressed>(_onCreateTodoPressed);
    on<DeleteTodoPressed>(_onDeleteTodoPressed);
    on<SortTodoPressed>(_onSortTodoPressed);
    on<EditTodoPressed>(_onEditTodoPressed);
    on<GetAllTodosPressed>(_onGetAllTodoPressed);
    _streamSubscription = _todoRepository
        .getListOfTodoModel(
          todoModelStorageKey: DatabaseConfig.todoModelStorageKey,
        )
        .listen(
          (List<TodoModel> todos) => add(
            GetAllTodosPressed(
              todos: todos,
            ),
          ),
        )..onError(
        (e) {
          addError(const BaseExceptions(
            code: -1,
            error: 'Cannot Get List Of Datas',
          ));
        },
      );
  }
  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }

  Future<void> _onCreateTodoPressed(
      CreateTodoPressed event, Emitter<TodoState> emit) async {
    try {
      final TodoModel todoModel = TodoModel(
        id: const Uuid().v4(),
        title: event.title,
        isComplete: false,
        createdAt: DateTime.now(),
        description: event.description,
      );
      emit(
        TodoState.loading(
          filterTodosBase: state.filterTodosBase,
        ),
      );
      await _todoRepository.createTodoModel(
          todoModel: todoModel,
          todoModelStorageKey: DatabaseConfig.todoModelStorageKey);
      final List<TodoModel> prevTodos = await _todoRepository.getListOfAllTodos(
          todoModelStorageKey: DatabaseConfig.todoModelStorageKey);
      emit(
        TodoState.success(listOfTodos: prevTodos),
      );
    } on BaseExceptions catch (e) {
      emit(
        TodoState.error(
          filterTodosBase: state.filterTodosBase,
          error: e,
          listOfTodos: state.listOfTodos,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(
        TodoState.error(
          filterTodosBase: state.filterTodosBase,
          isLoading: false,
          error: BaseExceptions(
            error: 'Cannot Create TodoModel : ${e.toString()}',
            code: 11,
          ),
          listOfTodos: state.listOfTodos,
        ),
      );
    }
  }

  Future<void> _onDeleteTodoPressed(
      DeleteTodoPressed event, Emitter<TodoState> emit) async {
    try {
      emit(TodoState.loading(
        listOfTodos: state.listOfTodos,
        isLoading: true,
        filterTodosBase: state.filterTodosBase,
      ));
      await _todoRepository.removeTodoModel(
          id: event.todoId,
          todoModelStorageKey: DatabaseConfig.todoModelStorageKey);
      emit(
        TodoState.success(
          filterTodosBase: state.filterTodosBase,
        ),
      );
    } on BaseExceptions catch (e) {
      emit(
        TodoState.error(
          isLoading: false,
          error: e,
          listOfTodos: state.listOfTodos,
          filterTodosBase: state.filterTodosBase,
        ),
      );
    } catch (e) {
      emit(
        TodoState.error(
          filterTodosBase: state.filterTodosBase,
          isLoading: false,
          error: BaseExceptions(
            error: 'Cannot Delete TodoModel : ${e.toString()}',
            code: 11,
          ),
          listOfTodos: state.listOfTodos,
        ),
      );
    }
  }

  Future<void> _onSortTodoPressed(
      SortTodoPressed event, Emitter<TodoState> emit) async {
    try {
      emit(TodoState.loading(
        listOfTodos: state.listOfTodos,
        isLoading: true,
        filterTodosBase: state.filterTodosBase,
      ));

      _todoRepository.filterTodosBaseFilterEnum(
          filterTodosBase: event.filterBase,
          todoModelStorageKey: DatabaseConfig.todoModelStorageKey);
      emit(TodoState.success(
        listOfTodos: state.listOfTodos,
        filterTodosBase: event.filterBase,
      ));
    } on BaseExceptions catch (e) {
      emit(
        TodoState.error(
          isLoading: false,
          error: e,
          listOfTodos: state.listOfTodos,
        ),
      );
    } catch (e) {
      emit(
        TodoState.error(
          isLoading: false,
          error: BaseExceptions(
            error: 'Cannot Sort TodoModel : ${e.toString()}',
            code: 11,
          ),
          listOfTodos: state.listOfTodos,
          filterTodosBase: event.filterBase,
        ),
      );
    }
  }

  Future<void> _onEditTodoPressed(
      EditTodoPressed event, Emitter<TodoState> emit) async {
    try {
      emit(TodoState.loading(
        filterTodosBase: state.filterTodosBase,
      ));
      await _todoRepository.editTodoModel(
          todoModel: event.editedTodoModel,
          todoModelStorageKey: DatabaseConfig.todoModelStorageKey);
      emit(TodoState.success(listOfTodos: state.listOfTodos, isLoading: false));
    } on BaseExceptions catch (e) {
      emit(
        TodoState.error(
          filterTodosBase: state.filterTodosBase,
          isLoading: false,
          error: e,
          listOfTodos: state.listOfTodos,
        ),
      );
    } catch (e) {
      emit(
        TodoState.error(
          filterTodosBase: state.filterTodosBase,
          isLoading: false,
          error: BaseExceptions(
            error: 'Cannot Edit TodoModel : ${e.toString()}',
            code: 11,
          ),
          listOfTodos: state.listOfTodos,
        ),
      );
    }
  }

  Future<void> _onGetAllTodoPressed(
      GetAllTodosPressed event, Emitter<TodoState> emit) async {
    try {
      emit(TodoState.loading(
        filterTodosBase: state.filterTodosBase,
      ));
      emit(
        TodoState.success(
          listOfTodos: event.todos,
          filterTodosBase: state.filterTodosBase,
        ),
      );
    } on BaseExceptions catch (e) {
      emit(
        TodoState.error(
          isLoading: false,
          filterTodosBase: state.filterTodosBase,
          error: e,
          listOfTodos: state.listOfTodos,
        ),
      );
    } catch (e) {
      emit(
        TodoState.error(
          isLoading: false,
          filterTodosBase: state.filterTodosBase,
          error: BaseExceptions(
            error: 'Cannot GetAll TodoModel : ${e.toString()}',
            code: 11,
          ),
          listOfTodos: state.listOfTodos,
        ),
      );
    }
  }

  Future<void> _onInitializeApplication(
      InitializeApplication event, Emitter<TodoState> emit) async {
    try {
      _todoRepository.initializeDatabase(
        path: event.dbPath,
      );
      final List<TodoModel> _todos = await _todoRepository.getListOfAllTodos(
          todoModelStorageKey: DatabaseConfig.todoModelStorageKey);
      add(GetAllTodosPressed(todos: _todos));
    } on BaseExceptions catch (e) {
      emit(
        TodoState.error(
          filterTodosBase: state.filterTodosBase,
          error: e,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(
        TodoState.error(
          filterTodosBase: state.filterTodosBase,
          error: BaseExceptions(
              code: 10, error: 'Cannot InitDatas : ${e.toString()}'),
          isLoading: false,
        ),
      );
    }
  }
}
