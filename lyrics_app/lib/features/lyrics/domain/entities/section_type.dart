import 'package:hive/hive.dart';

part 'section_type.g.dart';

@HiveType(typeId: 0)
enum SectionType {
  @HiveField(0)
  verse,
  @HiveField(1)
  chorus,
  @HiveField(2)
  bridge,
  @HiveField(3)
  intro,
  @HiveField(4)
  outro,
  @HiveField(5)
  preChorus,
  @HiveField(6)
  interlude,
  @HiveField(7)
  custom;

  String get displayName {
    switch (this) {
      case SectionType.verse:
        return 'Verse';
      case SectionType.chorus:
        return 'Chorus';
      case SectionType.bridge:
        return 'Bridge';
      case SectionType.intro:
        return 'Intro';
      case SectionType.outro:
        return 'Outro';
      case SectionType.preChorus:
        return 'Pre-Chorus';
      case SectionType.interlude:
        return 'Interlude';
      case SectionType.custom:
        return 'Custom';
    }
  }
}