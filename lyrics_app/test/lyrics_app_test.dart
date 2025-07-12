import 'package:flutter_test/flutter_test.dart';
import 'package:lyrics_app/features/lyrics/domain/entities/lyric.dart';
import 'package:lyrics_app/features/lyrics/domain/entities/lyric_section.dart';
import 'package:lyrics_app/features/lyrics/domain/entities/section_type.dart';
import 'package:lyrics_app/features/lyrics/domain/entities/arrangement.dart';

void main() {
  group('Lyrics Domain Entities', () {
    test('should create a lyric section with correct properties', () {
      // Arrange
      final now = DateTime.now();
      
      // Act
      final section = LyricSection(
        id: '1',
        title: 'Verse 1',
        content: 'Test content',
        type: SectionType.verse,
        order: 0,
        createdAt: now,
        updatedAt: now,
      );
      
      // Assert
      expect(section.id, '1');
      expect(section.title, 'Verse 1');
      expect(section.content, 'Test content');
      expect(section.type, SectionType.verse);
      expect(section.order, 0);
    });

    test('should create a lyric with sections and arrangements', () {
      // Arrange
      final now = DateTime.now();
      
      final section = LyricSection(
        id: '1',
        title: 'Verse 1',
        content: 'Test content',
        type: SectionType.verse,
        order: 0,
        createdAt: now,
        updatedAt: now,
      );
      
      final arrangement = Arrangement(
        id: 'arr1',
        name: 'Default',
        lyricId: 'lyric1',
        sectionOrder: ['1'],
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      );
      
      // Act
      final lyric = Lyric(
        id: 'lyric1',
        title: 'Test Song',
        sections: [section],
        arrangements: [arrangement],
        createdAt: now,
        updatedAt: now,
      );
      
      // Assert
      expect(lyric.id, 'lyric1');
      expect(lyric.title, 'Test Song');
      expect(lyric.sections.length, 1);
      expect(lyric.arrangements.length, 1);
      expect(lyric.sections.first.title, 'Verse 1');
      expect(lyric.arrangements.first.name, 'Default');
    });

    test('should get sections in arrangement order', () {
      // Arrange
      final now = DateTime.now();
      
      final section1 = LyricSection(
        id: '1',
        title: 'Verse 1',
        content: 'First verse',
        type: SectionType.verse,
        order: 0,
        createdAt: now,
        updatedAt: now,
      );
      
      final section2 = LyricSection(
        id: '2',
        title: 'Chorus',
        content: 'Chorus content',
        type: SectionType.chorus,
        order: 1,
        createdAt: now,
        updatedAt: now,
      );
      
      final arrangement = Arrangement(
        id: 'arr1',
        name: 'Default',
        lyricId: 'lyric1',
        sectionOrder: ['2', '1'], // Chorus first, then verse
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      );
      
      final lyric = Lyric(
        id: 'lyric1',
        title: 'Test Song',
        sections: [section1, section2],
        arrangements: [arrangement],
        defaultArrangementId: 'arr1',
        createdAt: now,
        updatedAt: now,
      );
      
      // Act
      final orderedSections = lyric.getSectionsInOrder('arr1');
      
      // Assert
      expect(orderedSections.length, 2);
      expect(orderedSections[0].title, 'Chorus');
      expect(orderedSections[1].title, 'Verse 1');
    });
  });
}