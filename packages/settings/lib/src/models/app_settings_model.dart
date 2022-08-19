import 'package:base_repository/base_repository.dart';
import 'package:equatable/equatable.dart';

class AppSettingsModel extends Equatable with BaseModel {
  final bool isDarkMode;
  const AppSettingsModel({this.isDarkMode = false});
  @override
  List<Object?> get props => [isDarkMode];
}
