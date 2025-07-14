// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arrangement.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArrangementAdapter extends TypeAdapter<Arrangement> {
  @override
  final int typeId = 2;

  @override
  Arrangement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Arrangement(
      id: fields[0] as String,
      name: fields[1] as String,
      lyricId: fields[2] as String,
      sectionOrder: (fields[3] as List).cast<String>(),
      isDefault: fields[4] as bool,
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Arrangement obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.lyricId)
      ..writeByte(3)
      ..write(obj.sectionOrder)
      ..writeByte(4)
      ..write(obj.isDefault)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArrangementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
