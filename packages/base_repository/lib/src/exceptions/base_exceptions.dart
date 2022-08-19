class BaseExceptions implements Exception {
  const BaseExceptions({
    this.error,
    this.code,
  }):super();
  final String? error;
  final int? code;
  @override
  bool operator ==(covariant BaseExceptions other) {
    return other.error == error && other.code == code;
  }
  @override
  int get hashCode => error.hashCode^code.hashCode;
}
