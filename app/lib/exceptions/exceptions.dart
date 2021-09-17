class ClientConfigNotInitializedException implements Exception {
  final String msg;
  ClientConfigNotInitializedException(this.msg);
}

class MalformedJsonException implements Exception {
  final String msg;
  MalformedJsonException(this.msg);
}

class MalformedQuestionnaireObjectException implements Exception {
  final String msg;
  MalformedQuestionnaireObjectException(this.msg);
}

class MalformedMoodsException implements Exception {
  final String msg;
  MalformedMoodsException(this.msg);
}

class MalformedUtcNotificationTimesException implements Exception {
  final String msg;
  MalformedUtcNotificationTimesException(this.msg);
}

class EmptyHiveBoxException implements Exception {
  final String msg;
  EmptyHiveBoxException(this.msg);
}

class HiveBoxNullValueException implements Exception {
  final String msg;
  HiveBoxNullValueException(this.msg);
}

class MalformedServerUrlException implements Exception {
  final String msg;
  MalformedServerUrlException(this.msg);
}
