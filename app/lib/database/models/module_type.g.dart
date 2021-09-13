// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModuleTypeAdapter extends TypeAdapter<ModuleType> {
  @override
  final int typeId = 6;

  @override
  ModuleType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ModuleType.spatialSpanTask;
      case 1:
        return ModuleType.mentalArithmetic;
      case 2:
        return ModuleType.psychomotorVigilanceTask;
      case 3:
        return ModuleType.questionnaire;
      case 4:
        return ModuleType.currentActivity;
      default:
        return ModuleType.spatialSpanTask;
    }
  }

  @override
  void write(BinaryWriter writer, ModuleType obj) {
    switch (obj) {
      case ModuleType.spatialSpanTask:
        writer.writeByte(0);
        break;
      case ModuleType.mentalArithmetic:
        writer.writeByte(1);
        break;
      case ModuleType.psychomotorVigilanceTask:
        writer.writeByte(2);
        break;
      case ModuleType.questionnaire:
        writer.writeByte(3);
        break;
      case ModuleType.currentActivity:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModuleTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
