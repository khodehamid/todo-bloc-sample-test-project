import 'package:base_repository/base_repository.dart';

abstract class AppConfig {
  static const Map<String, FilterTodosBase> filteredTodosBase = {
    'تکمیل شده ها': FilterTodosBase.complete,
    'تکمیل نشده ها': FilterTodosBase.unComplete,
    'همه': FilterTodosBase.all,
  };
}
