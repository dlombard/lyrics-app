// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lyric_section.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LyricSectionAdapter extends TypeAdapter<LyricSection> {
  @override
  final int typeId = 1;

  @override
  LyricSection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LyricSection(
      id: fields[0] as String,
      title: fields[1] as String,
      content: fields[2] as String,
      type: fields[3] as SectionType,
      customType: fields[4] as String?,
      order: fields[5] as int,
      createdAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, LyricSection obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.customType)
      ..writeByte(5)
      ..write(obj.order)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LyricSectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
