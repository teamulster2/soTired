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
      case 2:
        return ModuleType.psychomotorVigilanceTask;
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
      case ModuleType.psychomotorVigilanceTask:
        writer.writeByte(2);
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
