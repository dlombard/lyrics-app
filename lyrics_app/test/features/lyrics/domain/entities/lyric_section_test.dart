import 'package:flutter_test/flutter_test.dart';
import 'package:lyrics_app/features/lyrics/domain/entities/lyric_section.dart';
import 'package:lyrics_app/features/lyrics/domain/entities/section_type.dart';

void main() {
  group('LyricSection Entity', () {
    final now = DateTime.now();

    test('should create a valid LyricSection instance', () {
      // Arrange & Act
      final section = LyricSection(
        id: 'section-1',
        title: 'Verse 1',
        content: 'This is the first verse content\nWith multiple lines',
        type: SectionType.verse,
        order: 0,
        createdAt: now,
        updatedAt: now,
      );

      // Assert
      expect(section.id, 'section-1');
      expect(section.title, 'Verse 1');
      expect(section.content, 'This is the first verse content\nWith multiple lines');
      expect(section.type, SectionType.verse);
      expect(section.order, 0);
      expect(section.createdAt, now);
      expect(section.updatedAt, now);
    });

    test('should support equality comparison', () {
      // Arrange
      final section1 = LyricSection(
        id: 'section-1',
        title: 'Verse 1',
        content: 'Content',
        type: SectionType.verse,
        order: 0,
        createdAt: now,
        updatedAt: now,
      );

      final section2 = LyricSection(
        id: 'section-1',
        title: 'Verse 1',
        content: 'Content',
        type: SectionType.verse,
        order: 0,
        createdAt: now,
        updatedAt: now,
      );

      final section3 = LyricSection(
        id: 'section-2',
        title: 'Verse 1',
        content: 'Content',
        type: SectionType.verse,
        order: 0,
        createdAt: now,
        updatedAt: now,
      );

      // Act & Assert
      expect(section1, equals(section2));
      expect(section1, isNot(equals(section3)));
      expect(section1.hashCode, equals(section2.hashCode));
      expect(section1.hashCode, isNot(equals(section3.hashCode)));
    });

    test('should create copyWith correctly', () {
      // Arrange
      final originalSection = LyricSection(
        id: 'section-1',
        title: 'Original Title',
        content: 'Original Content',
        type: SectionType.verse,
        order: 0,
        createdAt: now,
        updatedAt: now,
      );

      final newTime = now.add(const Duration(minutes: 30));

      // Act
      final updatedSection = originalSection.copyWith(
        title: 'Updated Title',
        content: 'Updated Content',
        type: SectionType.chorus,
        order: 5,
        updatedAt: newTime,
      );

      // Assert
      expect(updatedSection.id, originalSection.id);
      expect(updatedSection.title, 'Updated Title');
      expect(updatedSection.content, 'Updated Content');
      expect(updatedSection.type, SectionType.chorus);
      expect(updatedSection.order, 5);
      expect(updatedSection.createdAt, originalSection.createdAt);
      expect(updatedSection.updatedAt, newTime);
    });

    test('should handle empty content', () {
      // Arrange & Act
      final section = LyricSection(
        id: 'section-1',
        title: 'Empty Section',
        content: '',
        type: SectionType.verse,
        order: 0,
        createdAt: now,
        updatedAt: now,
      );

      // Assert
      expect(section.content, isEmpty);
    });

    test('should handle different section types', () {
      // Arrange
      final types = [
        SectionType.verse,
        SectionType.chorus,
        SectionType.bridge,
        SectionType.intro,
        SectionType.outro,
        SectionType.preChorus,
        SectionType.interlude,
        SectionType.custom,
      ];

      // Act & Assert
      for (final type in types) {
        final section = LyricSection(
          id: 'section-${type.name}',
          title: type.displayName,
          content: 'Content for ${type.name}',
          type: type,
          order: 0,
          createdAt: now,
          updatedAt: now,
        );

        expect(section.type, type);
        expect(section.title, type.displayName);
      }
    });
  });
}