import 'package:base_repository/base_repository.dart';

abstract class TodoRepositoryExceptions extends BaseExceptions {
  const TodoRepositoryExceptions({String? error, int? code})
      : super(error: error, code: code);
}

class TodoModelDatasIsNotValidException extends TodoRepositoryExceptions {
  const TodoModelDatasIsNotValidException({String? error, int? code})
      : super(error: error, code: code);
}
