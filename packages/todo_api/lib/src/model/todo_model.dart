import 'dart:convert';

import 'package:base_repository/base_repository.dart';
import 'package:equatable/equatable.dart';

class TodoModel extends Equatable with BaseModel {
  final String id;
  final String title;
  final String? description;
  final bool isComplete;
  final DateTime createdAt;

  TodoModel({
    required this.id,
    required this.title,
    required this.isComplete,
    required this.createdAt,
    this.description,
  });
  @override
  List<Object?> get props => [
        id,
        title,
        isComplete,
        createdAt,
        description,
      ];
  @override
  String toString() {
    return toMap().toString();
  }

  String toJson() {
    return json.encode(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isComplete': isComplete,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TodoModel.fromJson({required String jsonData}) {
    final Map<String, dynamic> mapData = json.decode(jsonData);
    return TodoModel.fromMap(mapData: mapData);
  }
  factory TodoModel.fromMap({required Map<String, dynamic> mapData}) {
    final String id = mapData['id'];
    final String title = mapData['title'];
    final String? description = mapData['description'];
    final bool isComplete = mapData['isComplete'];
    final DateTime createdAt = DateTime.parse(mapData['createdAt']);
    return TodoModel(
        id: id,
        title: title,
        isComplete: isComplete,
        createdAt: createdAt,
        description: description);
  }
  static TodoModel empty = TodoModel(
    id: '-',
    title: '',
    isComplete: false,
    createdAt: DateTime.now(),
  );
  TodoModel copyWith({String? title, String? description, bool? isComplete}) {
    return TodoModel(
      id: id,
      title: title ?? this.title,
      isComplete: isComplete ?? this.isComplete,
      createdAt: createdAt,
      description: description,
    );
  }

  static List<TodoModel> getListOfTodoModelFromListOfMapData(
      {required List<dynamic> listOfMap}) {
    List<TodoModel> listOfTodos = [];
    for (Map<String, dynamic> data in listOfMap) {
      final TodoModel _todoModel = TodoModel.fromMap(mapData: data);
      listOfTodos.add(_todoModel);
    }
    return listOfTodos;
  }
}
