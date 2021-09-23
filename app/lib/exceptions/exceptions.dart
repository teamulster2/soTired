abstract class BaseException implements Exception {
  final String msg;

  BaseException(this.msg);
}

class ClientConfigNotInitializedException implements BaseException {
  @override
  final String msg;

  ClientConfigNotInitializedException(this.msg);
}

class MalformedJsonException implements BaseException {
  @override
  final String msg;

  MalformedJsonException(this.msg);
}

class MalformedQuestionnaireObjectException implements BaseException {
  @override
  final String msg;

  MalformedQuestionnaireObjectException(this.msg);
}

class MalformedUtcNotificationTimesException implements BaseException {
  @override
  final String msg;

  MalformedUtcNotificationTimesException(this.msg);
}

class EmptyHiveBoxException implements BaseException {
  @override
  final String msg;

  EmptyHiveBoxException(this.msg);
}

class HiveBoxNullValueException implements BaseException {
  @override
  final String msg;

  HiveBoxNullValueException(this.msg);
}

class HttpErrorCodeException implements BaseException {
  @override
  final String msg;

  HttpErrorCodeException(this.msg);
}

class DatabaseNotChangedException implements BaseException {
  @override
  final String msg;

  DatabaseNotChangedException(this.msg);
}
