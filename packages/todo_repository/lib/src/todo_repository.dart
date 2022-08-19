import 'package:base_repository/base_repository.dart';
import 'package:local_storage_todo_api/local_storage_todo_api.dart';
import 'package:todo_api/todo_api.dart';
import 'package:todo_repository/todo_repository.dart';

class TodoRepository {
  final _storageApi = StorageApi();
  void initializeDatabase({required String path}) {
    try {
      _storageApi.initHiveDb(path: path);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createTodoModel(
      {required TodoModel todoModel,
      required String todoModelStorageKey}) async {
    try {
      if (todoModel.title.length < 3) {
        throw const TodoModelDatasIsNotValidException(
          error: 'Please Enter Valid Datas For Todo!',
          code: -1,
        );
      } else {
        await _storageApi.saveTodoModelIntoDb(
          baseModel: todoModel,
          key: todoModelStorageKey,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<TodoModel>> getListOfTodoModel(
      {required String todoModelStorageKey}) {
    return _storageApi.getListOfAllTodosStream(key: todoModelStorageKey);
  }

  Future<List<TodoModel>> getListOfAllTodos(
      {required String todoModelStorageKey}) {
    return _storageApi.getListOfAllTodos(key: todoModelStorageKey);
  }

  Future<void> removeTodoModel(
      {required String id, required String todoModelStorageKey}) async {
    try {
      await _storageApi.removeTodoModel(id: id, key: todoModelStorageKey);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editTodoModel(
      {required TodoModel todoModel,
      required String todoModelStorageKey}) async {
    try {
      await _storageApi.updateTodoModel(
          todoModel: todoModel, key: todoModelStorageKey);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TodoModel>> searchIntoTodos(
      {required String keyword, required String totodModelStorageKey}) async {
    try {
      final List<TodoModel> _todos =
          await _storageApi.getListOfAllTodos(key: totodModelStorageKey);
      return _todos
          .where((element) =>
              element.title.contains(keyword) ||
              (element.description ?? '').contains(keyword))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> filterTodosBaseFilterEnum(
      {required FilterTodosBase filterTodosBase,
      required String todoModelStorageKey}) async {
    _storageApi.filterTodos(
        filterTodosBase: filterTodosBase, key: todoModelStorageKey);
    // final List<TodoModel> listOfTodos =
    //     await _storageApi.getListOfAllTodos(key: todoModelStorageKey);
    // switch (filterTodosBase) {
    //   case FilterTodosBase.complete:
    //     return listOfTodos.where((element) => element.isComplete).toList();
    //   case FilterTodosBase.unComplete:
    //     return listOfTodos.where((element) => !element.isComplete).toList();
    //   case FilterTodosBase.all:
    //     return listOfTodos;
    // }
  }
}
