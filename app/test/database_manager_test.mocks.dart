// Mocks generated by Mockito 5.0.16 from annotations
// in so_tired/test/database_manager_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i8;

import 'package:hive_flutter/hive_flutter.dart' as _i7;
import 'package:mockito/mockito.dart' as _i1;
import 'package:so_tired/database/database_manager.dart' as _i9;
import 'package:so_tired/database/models/questionnaire/questionnaire_result.dart'
    as _i5;
import 'package:so_tired/database/models/score/personal_high_score.dart' as _i2;
import 'package:so_tired/database/models/settings/settings_object.dart' as _i6;
import 'package:so_tired/database/models/user/user_log.dart' as _i3;
import 'package:so_tired/database/models/user/user_state.dart' as _i4;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakePersonalHighScore_0 extends _i1.Fake
    implements _i2.PersonalHighScore {}

class _FakeUserLog_1 extends _i1.Fake implements _i3.UserLog {}

class _FakeUserState_2 extends _i1.Fake implements _i4.UserState {}

class _FakeQuestionnaireResult_3 extends _i1.Fake
    implements _i5.QuestionnaireResult {}

class _FakeSettingsObject_4 extends _i1.Fake implements _i6.SettingsObject {}

/// A class which mocks [Box].
///
/// See the documentation for Mockito's code generation for more information.
class MockBox<E> extends _i1.Mock implements _i7.Box<E> {
  MockBox() {
    _i1.throwOnMissingStub(this);
  }

  @override
  Iterable<E> get values =>
      (super.noSuchMethod(Invocation.getter(#values), returnValue: <E>[])
          as Iterable<E>);
  @override
  String get name =>
      (super.noSuchMethod(Invocation.getter(#name), returnValue: '') as String);
  @override
  bool get isOpen =>
      (super.noSuchMethod(Invocation.getter(#isOpen), returnValue: false)
          as bool);
  @override
  bool get lazy =>
      (super.noSuchMethod(Invocation.getter(#lazy), returnValue: false)
          as bool);
  @override
  Iterable<dynamic> get keys =>
      (super.noSuchMethod(Invocation.getter(#keys), returnValue: <dynamic>[])
          as Iterable<dynamic>);
  @override
  int get length =>
      (super.noSuchMethod(Invocation.getter(#length), returnValue: 0) as int);
  @override
  bool get isEmpty =>
      (super.noSuchMethod(Invocation.getter(#isEmpty), returnValue: false)
          as bool);
  @override
  bool get isNotEmpty =>
      (super.noSuchMethod(Invocation.getter(#isNotEmpty), returnValue: false)
          as bool);
  @override
  Iterable<E> valuesBetween({dynamic startKey, dynamic endKey}) =>
      (super.noSuchMethod(
          Invocation.method(
              #valuesBetween, [], {#startKey: startKey, #endKey: endKey}),
          returnValue: <E>[]) as Iterable<E>);
  @override
  E? getAt(int? index) =>
      (super.noSuchMethod(Invocation.method(#getAt, [index])) as E?);
  @override
  Map<dynamic, E> toMap() => (super.noSuchMethod(Invocation.method(#toMap, []),
      returnValue: <dynamic, E>{}) as Map<dynamic, E>);
  @override
  String toString() => super.toString();
  @override
  dynamic keyAt(int? index) =>
      super.noSuchMethod(Invocation.method(#keyAt, [index]));
  @override
  _i8.Stream<_i7.BoxEvent> watch({dynamic key}) => (super.noSuchMethod(
      Invocation.method(#watch, [], {#key: key}),
      returnValue: Stream<_i7.BoxEvent>.empty()) as _i8.Stream<_i7.BoxEvent>);
  @override
  bool containsKey(dynamic key) =>
      (super.noSuchMethod(Invocation.method(#containsKey, [key]),
          returnValue: false) as bool);
  @override
  _i8.Future<void> put(dynamic key, E? value) =>
      (super.noSuchMethod(Invocation.method(#put, [key, value]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> putAt(int? index, E? value) =>
      (super.noSuchMethod(Invocation.method(#putAt, [index, value]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> putAll(Map<dynamic, E>? entries) =>
      (super.noSuchMethod(Invocation.method(#putAll, [entries]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<int> add(E? value) =>
      (super.noSuchMethod(Invocation.method(#add, [value]),
          returnValue: Future<int>.value(0)) as _i8.Future<int>);
  @override
  _i8.Future<Iterable<int>> addAll(Iterable<E>? values) =>
      (super.noSuchMethod(Invocation.method(#addAll, [values]),
              returnValue: Future<Iterable<int>>.value(<int>[]))
          as _i8.Future<Iterable<int>>);
  @override
  _i8.Future<void> delete(dynamic key) =>
      (super.noSuchMethod(Invocation.method(#delete, [key]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> deleteAt(int? index) =>
      (super.noSuchMethod(Invocation.method(#deleteAt, [index]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> deleteAll(Iterable<dynamic>? keys) =>
      (super.noSuchMethod(Invocation.method(#deleteAll, [keys]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> compact() =>
      (super.noSuchMethod(Invocation.method(#compact, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<int> clear() => (super.noSuchMethod(Invocation.method(#clear, []),
      returnValue: Future<int>.value(0)) as _i8.Future<int>);
  @override
  _i8.Future<void> close() => (super.noSuchMethod(Invocation.method(#close, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> deleteFromDisk() =>
      (super.noSuchMethod(Invocation.method(#deleteFromDisk, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
}

/// A class which mocks [DatabaseManager].
///
/// See the documentation for Mockito's code generation for more information.
class MockDatabaseManager extends _i1.Mock implements _i9.DatabaseManager {
  MockDatabaseManager() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get databasePath =>
      (super.noSuchMethod(Invocation.getter(#databasePath), returnValue: '')
          as String);
  @override
  _i8.Future<void> initDatabase(String? databasePath) =>
      (super.noSuchMethod(Invocation.method(#initDatabase, [databasePath]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> writePersonalHighScores(
          List<_i2.PersonalHighScore>? scores) =>
      (super.noSuchMethod(Invocation.method(#writePersonalHighScores, [scores]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> writeUserLogs(List<_i3.UserLog>? logs) =>
      (super.noSuchMethod(Invocation.method(#writeUserLogs, [logs]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> writeUserStates(List<_i4.UserState>? activities) =>
      (super.noSuchMethod(Invocation.method(#writeUserStates, [activities]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> writeQuestionnaireResults(
          List<_i5.QuestionnaireResult>? results) =>
      (super.noSuchMethod(
          Invocation.method(#writeQuestionnaireResults, [results]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> writeSettings(_i6.SettingsObject? settings) =>
      (super.noSuchMethod(Invocation.method(#writeSettings, [settings]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i2.PersonalHighScore getPersonalHighScoreById(String? uuid) =>
      (super.noSuchMethod(Invocation.method(#getPersonalHighScoreById, [uuid]),
          returnValue: _FakePersonalHighScore_0()) as _i2.PersonalHighScore);
  @override
  _i3.UserLog getUserLogById(String? uuid) =>
      (super.noSuchMethod(Invocation.method(#getUserLogById, [uuid]),
          returnValue: _FakeUserLog_1()) as _i3.UserLog);
  @override
  _i4.UserState getUserStateById(String? uuid) =>
      (super.noSuchMethod(Invocation.method(#getUserStateById, [uuid]),
          returnValue: _FakeUserState_2()) as _i4.UserState);
  @override
  _i5.QuestionnaireResult getQuestionnaireResultById(String? uuid) => (super
          .noSuchMethod(Invocation.method(#getQuestionnaireResultById, [uuid]),
              returnValue: _FakeQuestionnaireResult_3())
      as _i5.QuestionnaireResult);
  @override
  List<_i2.PersonalHighScore> getAllPersonalHighScores() => (super.noSuchMethod(
      Invocation.method(#getAllPersonalHighScores, []),
      returnValue: <_i2.PersonalHighScore>[]) as List<_i2.PersonalHighScore>);
  @override
  List<_i3.UserLog?> getAllUserLogs() =>
      (super.noSuchMethod(Invocation.method(#getAllUserLogs, []),
          returnValue: <_i3.UserLog?>[]) as List<_i3.UserLog?>);
  @override
  List<_i4.UserState?> getAllUserStates() =>
      (super.noSuchMethod(Invocation.method(#getAllUserStates, []),
          returnValue: <_i4.UserState?>[]) as List<_i4.UserState?>);
  @override
  List<_i5.QuestionnaireResult?> getAllQuestionnaireResults() =>
      (super.noSuchMethod(Invocation.method(#getAllQuestionnaireResults, []),
              returnValue: <_i5.QuestionnaireResult?>[])
          as List<_i5.QuestionnaireResult?>);
  @override
  _i6.SettingsObject getSettings() =>
      (super.noSuchMethod(Invocation.method(#getSettings, []),
          returnValue: _FakeSettingsObject_4()) as _i6.SettingsObject);
  @override
  _i8.Future<void> deletePersonalHighScoreById(String? uuid) => (super
      .noSuchMethod(Invocation.method(#deletePersonalHighScoreById, [uuid]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> deleteUserLogsById(String? uuid) =>
      (super.noSuchMethod(Invocation.method(#deleteUserLogsById, [uuid]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> deleteUserStatesById(String? uuid) =>
      (super.noSuchMethod(Invocation.method(#deleteUserStatesById, [uuid]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> deleteQuestionnaireResultById(String? uuid) => (super
      .noSuchMethod(Invocation.method(#deleteQuestionnaireResultById, [uuid]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  Map<String, dynamic> exportDatabaseForTransfer() =>
      (super.noSuchMethod(Invocation.method(#exportDatabaseForTransfer, []),
          returnValue: <String, dynamic>{}) as Map<String, dynamic>);
  @override
  void closeDatabase() =>
      super.noSuchMethod(Invocation.method(#closeDatabase, []),
          returnValueForMissingStub: null);
  @override
  Map<String, dynamic> adaptDatabaseExportToServerSyntax(
          Map<String, dynamic>? exportMap) =>
      (super.noSuchMethod(
          Invocation.method(#adaptDatabaseExportToServerSyntax, [exportMap]),
          returnValue: <String, dynamic>{}) as Map<String, dynamic>);
  @override
  String toString() => super.toString();
}
