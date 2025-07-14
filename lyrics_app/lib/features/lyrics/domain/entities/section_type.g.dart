// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SectionTypeAdapter extends TypeAdapter<SectionType> {
  @override
  final int typeId = 0;

  @override
  SectionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SectionType.verse;
      case 1:
        return SectionType.chorus;
      case 2:
        return SectionType.bridge;
      case 3:
        return SectionType.intro;
      case 4:
        return SectionType.outro;
      case 5:
        return SectionType.preChorus;
      case 6:
        return SectionType.interlude;
      case 7:
        return SectionType.custom;
      default:
        return SectionType.verse;
    }
  }

  @override
  void write(BinaryWriter writer, SectionType obj) {
    switch (obj) {
      case SectionType.verse:
        writer.writeByte(0);
        break;
      case SectionType.chorus:
        writer.writeByte(1);
        break;
      case SectionType.bridge:
        writer.writeByte(2);
        break;
      case SectionType.intro:
        writer.writeByte(3);
        break;
      case SectionType.outro:
        writer.writeByte(4);
        break;
      case SectionType.preChorus:
        writer.writeByte(5);
        break;
      case SectionType.interlude:
        writer.writeByte(6);
        break;
      case SectionType.custom:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SectionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
