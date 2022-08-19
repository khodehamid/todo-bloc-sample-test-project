import 'dart:async';
import 'dart:convert';

import 'package:base_repository/base_repository.dart';
import 'package:hive/hive.dart';
import 'package:todo_api/todo_api.dart';

class StorageApi {
  StorageApi._internal();
  static StorageApi _shared = StorageApi._internal();
  factory StorageApi() => _shared;
  final StreamController<List<TodoModel>> _todoStreamController =
      StreamController<List<TodoModel>>.broadcast();
  void initHiveDb({required String path}) {
    try {
      Hive.init(path);
    } catch (e) {
      throw BaseExceptions(
          code: 1, error: 'Cannot Init Hive Database ${e.toString()}');
    }
  }

  Future<void> saveTodoModelIntoDb(
      {required TodoModel baseModel, required String key}) async {
    try {
      final Box box = await Hive.openBox(key);
      List<dynamic> mapDatas = [];
      if (box.isNotEmpty) {
        final String jsonDatas = box.get(key);
        mapDatas = json.decode(jsonDatas);
      }
      mapDatas.add(baseModel.toMap());
      await box.put(key, json.encode(mapDatas));
      final List<TodoModel> todos = await getListOfAllTodos(key: key);
      _todoStreamController.add(
        todos,
      );
    } catch (e) {
      print(e.toString());
      throw BaseExceptions(
          code: 2,
          error: 'Cannot Save Model Into Hive Database ${e.toString()}');
    }
  }

  Stream<List<TodoModel>> getListOfAllTodosStream({required String key}) {
    return _todoStreamController.stream;
  }

  Future<List<TodoModel>> getListOfAllTodos({required String key}) async {
    try {
      final Box box = await Hive.openBox(key);
      if (box.isNotEmpty) {
        final String jsonDatas = box.get(key);
        final List<dynamic> mapDatas = json.decode(jsonDatas);
        return TodoModel.getListOfTodoModelFromListOfMapData(
            listOfMap: mapDatas);
      }
      return [];
    } catch (e) {
      throw BaseExceptions(
          code: 3,
          error:
              'Cannot Get List Of Models From Hive Database ${e.toString()}');
    }
  }

  Future<void> removeTodoModel(
      {required String id, required String key}) async {
    try {
      final List<TodoModel> listOfTodos = await getListOfAllTodos(key: key);
      listOfTodos.removeWhere((element) => element.id == id);
      final Box box = await Hive.openBox(key);
      box.put(key, json.encode(listOfTodos.map((e) => e.toMap()).toList()));
      final List<TodoModel> _todos = await getListOfAllTodos(key: key);
      _todoStreamController.add(_todos);
    } catch (e) {
      throw BaseExceptions(
          code: 4,
          error: 'Cannot Remove Todo Model From Hive Database ${e.toString()}');
    }
  }

  Future<void> updateTodoModel(
      {required TodoModel todoModel, required String key}) async {
    try {
      List<TodoModel> listOfAllTodos = await getListOfAllTodos(key: key);
      int index =
          listOfAllTodos.indexWhere((element) => element.id == todoModel.id);
      if (index != -1) {
        listOfAllTodos[index] = todoModel;
      }
      final Box box = await Hive.box(key);
      box.put(key, json.encode(listOfAllTodos.map((e) => e.toMap()).toList()));
      final List<TodoModel> _todos = await getListOfAllTodos(key: key);
      _todoStreamController.add(_todos);
    } catch (e) {
      throw BaseExceptions(
          code: 5,
          error: 'Cannot Update Todo Model From Hive Database ${e.toString()}');
    }
  }

  Future<void> filterTodos(
      {required FilterTodosBase filterTodosBase, required String key}) async {
    try {
      final List<TodoModel> _allTodos = await getListOfAllTodos(key: key);
      switch (filterTodosBase) {
        case FilterTodosBase.complete:
          _todoStreamController
              .add(_allTodos.where((element) => element.isComplete).toList());
          break;
        case FilterTodosBase.unComplete:
          _todoStreamController
              .add(_allTodos.where((element) => !element.isComplete).toList());
          break;
        case FilterTodosBase.all:
          _todoStreamController.add(_allTodos);
          break;
      }
    } catch (e) {
      throw const BaseExceptions(error: 'Cannot Filter Todos!', code: 14);
    }
  }
}
