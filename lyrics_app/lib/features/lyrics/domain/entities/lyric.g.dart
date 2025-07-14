// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lyric.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LyricAdapter extends TypeAdapter<Lyric> {
  @override
  final int typeId = 3;

  @override
  Lyric read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Lyric(
      id: fields[0] as String,
      title: fields[1] as String,
      artist: fields[2] as String?,
      album: fields[3] as String?,
      sections: (fields[4] as List).cast<LyricSection>(),
      arrangements: (fields[5] as List).cast<Arrangement>(),
      defaultArrangementId: fields[6] as String?,
      tags: (fields[7] as List).cast<String>(),
      createdAt: fields[8] as DateTime,
      updatedAt: fields[9] as DateTime,
      isShared: fields[10] as bool,
      sharedById: fields[11] as String?,
      originalId: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Lyric obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.artist)
      ..writeByte(3)
      ..write(obj.album)
      ..writeByte(4)
      ..write(obj.sections)
      ..writeByte(5)
      ..write(obj.arrangements)
      ..writeByte(6)
      ..write(obj.defaultArrangementId)
      ..writeByte(7)
      ..write(obj.tags)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt)
      ..writeByte(10)
      ..write(obj.isShared)
      ..writeByte(11)
      ..write(obj.sharedById)
      ..writeByte(12)
      ..write(obj.originalId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LyricAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
