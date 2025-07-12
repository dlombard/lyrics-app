enum SectionType {
  verse,
  chorus,
  bridge,
  intro,
  outro,
  preChorus,
  interlude,
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