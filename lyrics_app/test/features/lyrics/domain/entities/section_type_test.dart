import 'package:flutter_test/flutter_test.dart';
import 'package:lyrics_app/features/lyrics/domain/entities/section_type.dart';

void main() {
  group('SectionType Enum', () {
    test('should have correct display names', () {
      // Act & Assert
      expect(SectionType.verse.displayName, 'Verse');
      expect(SectionType.chorus.displayName, 'Chorus');
      expect(SectionType.bridge.displayName, 'Bridge');
      expect(SectionType.intro.displayName, 'Intro');
      expect(SectionType.outro.displayName, 'Outro');
      expect(SectionType.preChorus.displayName, 'Pre-Chorus');
      expect(SectionType.interlude.displayName, 'Interlude');
      expect(SectionType.custom.displayName, 'Custom');
    });

    test('should have all expected section types', () {
      // Arrange
      final expectedTypes = [
        SectionType.verse,
        SectionType.chorus,
        SectionType.bridge,
        SectionType.intro,
        SectionType.outro,
        SectionType.preChorus,
        SectionType.interlude,
        SectionType.custom,
      ];

      // Act
      final actualTypes = SectionType.values;

      // Assert
      expect(actualTypes.length, expectedTypes.length);
      for (final type in expectedTypes) {
        expect(actualTypes, contains(type));
      }
    });

    test('should maintain consistent enum ordering', () {
      // Act
      final values = SectionType.values;

      // Assert - Check that common types are at the beginning
      expect(values[0], SectionType.verse);
      expect(values[1], SectionType.chorus);
      expect(values[2], SectionType.bridge);
      expect(values[3], SectionType.intro);
      expect(values[4], SectionType.outro);
      expect(values[5], SectionType.preChorus);
      expect(values[6], SectionType.interlude);
      expect(values[7], SectionType.custom);
    });

    test('should support equality comparison', () {
      // Act & Assert
      expect(SectionType.verse, equals(SectionType.verse));
      expect(SectionType.chorus, isNot(equals(SectionType.verse)));
    });

    test('should support toString', () {
      // Act & Assert
      expect(SectionType.verse.toString(), 'SectionType.verse');
      expect(SectionType.chorus.toString(), 'SectionType.chorus');
      expect(SectionType.preChorus.toString(), 'SectionType.preChorus');
    });

    test('should support name property', () {
      // Act & Assert
      expect(SectionType.verse.name, 'verse');
      expect(SectionType.chorus.name, 'chorus');
      expect(SectionType.preChorus.name, 'preChorus');
      expect(SectionType.custom.name, 'custom');
    });

    test('should support index property', () {
      // Act & Assert
      expect(SectionType.verse.index, 0);
      expect(SectionType.chorus.index, 1);
      expect(SectionType.bridge.index, 2);
      expect(SectionType.custom.index, 7);
    });
  });
}