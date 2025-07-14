import 'package:flutter_test/flutter_test.dart';
import 'package:lyrics_app/features/lyrics/domain/entities/lyric.dart';
import 'package:lyrics_app/features/lyrics/domain/entities/lyric_section.dart';
import 'package:lyrics_app/features/lyrics/domain/entities/section_type.dart';
import 'package:lyrics_app/features/lyrics/domain/entities/arrangement.dart';

void main() {
  group('Lyric Entity', () {
    final now = DateTime.now();
    final testSections = [
      LyricSection(
        id: '1',
        title: 'Verse 1',
        content: 'First verse content',
        type: SectionType.verse,
        order: 0,
        createdAt: now,
        updatedAt: now,
      ),
      LyricSection(
        id: '2',
        title: 'Chorus',
        content: 'Chorus content',
        type: SectionType.chorus,
        order: 1,
        createdAt: now,
        updatedAt: now,
      ),
      LyricSection(
        id: '3',
        title: 'Verse 2',
        content: 'Second verse content',
        type: SectionType.verse,
        order: 2,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    final testArrangement = Arrangement(
      id: 'arr1',
      name: 'Standard',
      lyricId: 'test-id',
      sectionOrder: ['1', '2', '3', '2'],
      isDefault: true,
      createdAt: now,
      updatedAt: now,
    );

    test('should create a valid Lyric instance', () {
      // Arrange & Act
      final lyric = Lyric(
        id: 'test-id',
        title: 'Test Song',
        artist: 'Test Artist',
        album: 'Test Album',
        sections: testSections,
        arrangements: [testArrangement],
        tags: ['rock', 'ballad'],
        createdAt: now,
        updatedAt: now,
      );

      // Assert
      expect(lyric.id, 'test-id');
      expect(lyric.title, 'Test Song');
      expect(lyric.artist, 'Test Artist');
      expect(lyric.album, 'Test Album');
      expect(lyric.sections, testSections);
      expect(lyric.arrangements, [testArrangement]);
      expect(lyric.tags, ['rock', 'ballad']);
      expect(lyric.createdAt, now);
      expect(lyric.updatedAt, now);
    });

    test('should create Lyric with null optional fields', () {
      // Arrange & Act
      final lyric = Lyric(
        id: 'test-id',
        title: 'Test Song',
        artist: null,
        album: null,
        sections: testSections,
        arrangements: [],
        tags: [],
        createdAt: now,
        updatedAt: now,
      );

      // Assert
      expect(lyric.artist, isNull);
      expect(lyric.album, isNull);
      expect(lyric.arrangements, isEmpty);
      expect(lyric.tags, isEmpty);
    });

    test('should return sections in arrangement order', () {
      // Arrange
      final lyric = Lyric(
        id: 'test-id',
        title: 'Test Song',
        artist: 'Test Artist',
        album: null,
        sections: testSections,
        arrangements: [testArrangement],
        tags: [],
        createdAt: now,
        updatedAt: now,
      );

      // Act
      final orderedSections = lyric.getSectionsInOrder(testArrangement.id);

      // Assert
      expect(orderedSections.length, 4);
      expect(orderedSections[0].id, '1'); // Verse 1
      expect(orderedSections[1].id, '2'); // Chorus
      expect(orderedSections[2].id, '3'); // Verse 2
      expect(orderedSections[3].id, '2'); // Chorus (repeated)
    });

    test('should return empty list when arrangement has invalid section IDs', () {
      // Arrange
      final invalidArrangement = Arrangement(
        id: 'arr2',
        name: 'Invalid',
        lyricId: 'test-id',
        sectionOrder: ['99', '88'], // Non-existent section IDs
        isDefault: false,
        createdAt: now,
        updatedAt: now,
      );

      final lyric = Lyric(
        id: 'test-id',
        title: 'Test Song',
        artist: 'Test Artist',
        album: null,
        sections: testSections,
        arrangements: [invalidArrangement],
        tags: [],
        createdAt: now,
        updatedAt: now,
      );

      // Act
      final orderedSections = lyric.getSectionsInOrder(invalidArrangement.id);

      // Assert
      expect(orderedSections, isEmpty);
    });

    test('should support equality comparison', () {
      // Arrange
      final lyric1 = Lyric(
        id: 'test-id',
        title: 'Test Song',
        artist: 'Test Artist',
        album: 'Test Album',
        sections: testSections,
        arrangements: [testArrangement],
        tags: ['rock'],
        createdAt: now,
        updatedAt: now,
      );

      final lyric2 = Lyric(
        id: 'test-id',
        title: 'Test Song',
        artist: 'Test Artist',
        album: 'Test Album',
        sections: testSections,
        arrangements: [testArrangement],
        tags: ['rock'],
        createdAt: now,
        updatedAt: now,
      );

      final lyric3 = Lyric(
        id: 'different-id',
        title: 'Test Song',
        artist: 'Test Artist',
        album: 'Test Album',
        sections: testSections,
        arrangements: [testArrangement],
        tags: ['rock'],
        createdAt: now,
        updatedAt: now,
      );

      // Act & Assert
      expect(lyric1, equals(lyric2));
      expect(lyric1, isNot(equals(lyric3)));
      expect(lyric1.hashCode, equals(lyric2.hashCode));
      expect(lyric1.hashCode, isNot(equals(lyric3.hashCode)));
    });

    test('should create copyWith correctly', () {
      // Arrange
      final originalLyric = Lyric(
        id: 'test-id',
        title: 'Original Title',
        artist: 'Original Artist',
        album: 'Original Album',
        sections: testSections,
        arrangements: [testArrangement],
        tags: ['rock'],
        createdAt: now,
        updatedAt: now,
      );

      final newTime = now.add(const Duration(hours: 1));

      // Act
      final updatedLyric = originalLyric.copyWith(
        title: 'Updated Title',
        artist: 'Updated Artist',
        updatedAt: newTime,
      );

      // Assert
      expect(updatedLyric.id, originalLyric.id);
      expect(updatedLyric.title, 'Updated Title');
      expect(updatedLyric.artist, 'Updated Artist');
      expect(updatedLyric.album, originalLyric.album);
      expect(updatedLyric.sections, originalLyric.sections);
      expect(updatedLyric.arrangements, originalLyric.arrangements);
      expect(updatedLyric.tags, originalLyric.tags);
      expect(updatedLyric.createdAt, originalLyric.createdAt);
      expect(updatedLyric.updatedAt, newTime);
    });
  });
}