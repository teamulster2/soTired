import 'package:hive/hive.dart';

part 'module_type.g.dart';

/// This enum defines which games are available / have been executed.
@HiveType(typeId: 6)
enum ModuleType {
  @HiveField(0)
  spatialSpanTask,
  @HiveField(2)
  psychomotorVigilanceTask
}
