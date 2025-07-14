import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:lyrics_app/core/error/failures.dart';
import 'package:lyrics_app/features/lyrics/domain/entities/lyric.dart';
import 'package:lyrics_app/features/lyrics/domain/entities/lyric_section.dart';
import 'package:lyrics_app/features/lyrics/domain/entities/section_type.dart';
import 'package:lyrics_app/features/lyrics/domain/entities/arrangement.dart';
import 'package:lyrics_app/features/lyrics/domain/repositories/lyrics_repository.dart';
import 'package:lyrics_app/features/lyrics/domain/usecases/create_lyric.dart';

import 'create_lyric_test.mocks.dart';

@GenerateMocks([LyricsRepository])
void main() {
  late CreateLyric usecase;
  late MockLyricsRepository mockRepository;

  setUp(() {
    mockRepository = MockLyricsRepository();
    usecase = CreateLyric(mockRepository);
  });

  group('CreateLyric', () {
    final now = DateTime.now();
    final tLyric = Lyric(
      id: 'test-id',
      title: 'Test Song',
      artist: 'Test Artist',
      album: 'Test Album',
      sections: [
        LyricSection(
          id: 'section-1',
          title: 'Verse 1',
          content: 'Test verse content\nWith multiple lines',
          type: SectionType.verse,
          order: 0,
          createdAt: now,
          updatedAt: now,
        ),
        LyricSection(
          id: 'section-2',
          title: 'Chorus',
          content: 'Test chorus content',
          type: SectionType.chorus,
          order: 1,
          createdAt: now,
          updatedAt: now,
        ),
      ],
      arrangements: [
        Arrangement(
          id: 'arr-1',
          name: 'Standard',
          lyricId: 'test-id',
          sectionOrder: ['section-1', 'section-2', 'section-1', 'section-2'],
          isDefault: true,
          createdAt: now,
          updatedAt: now,
        ),
      ],
      tags: ['rock', 'ballad'],
      createdAt: now,
      updatedAt: now,
    );

    test('should create lyric using the repository', () async {
      // Arrange
      when(mockRepository.createLyric(any))
          .thenAnswer((_) async => Right(tLyric));

      // Act
      final result = await usecase(CreateLyricParams(lyric: tLyric));

      // Assert
      expect(result, Right(tLyric));
      verify(mockRepository.createLyric(tLyric));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return CacheFailure when repository fails to create', () async {
      // Arrange
      when(mockRepository.createLyric(any))
          .thenAnswer((_) async => Left(CacheFailure('Cache error')));

      // Act
      final result = await usecase(CreateLyricParams(lyric: tLyric));

      // Assert
      expect(result, Left(CacheFailure('Cache error')));
      verify(mockRepository.createLyric(tLyric));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle lyric with empty sections', () async {
      // Arrange
      final emptyLyric = tLyric.copyWith(sections: []);
      when(mockRepository.createLyric(any))
          .thenAnswer((_) async => Right(emptyLyric));

      // Act
      final result = await usecase(CreateLyricParams(lyric: emptyLyric));

      // Assert
      expect(result, Right(emptyLyric));
      verify(mockRepository.createLyric(emptyLyric));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle lyric with no arrangements', () async {
      // Arrange
      final noArrangementsLyric = tLyric.copyWith(arrangements: []);
      when(mockRepository.createLyric(any))
          .thenAnswer((_) async => Right(noArrangementsLyric));

      // Act
      final result = await usecase(CreateLyricParams(lyric: noArrangementsLyric));

      // Assert
      expect(result, Right(noArrangementsLyric));
      verify(mockRepository.createLyric(noArrangementsLyric));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle lyric with null optional fields', () async {
      // Arrange
      final minimalLyric = tLyric.copyWith(
        artist: null,
        album: null,
        tags: [],
      );
      when(mockRepository.createLyric(any))
          .thenAnswer((_) async => Right(minimalLyric));

      // Act
      final result = await usecase(CreateLyricParams(lyric: minimalLyric));

      // Assert
      expect(result, Right(minimalLyric));
      verify(mockRepository.createLyric(minimalLyric));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle repository throwing exception', () async {
      // Arrange
      when(mockRepository.createLyric(any))
          .thenThrow(Exception('Database error'));

      // Act & Assert
      expect(() => usecase(CreateLyricParams(lyric: tLyric)), throwsException);
      verify(mockRepository.createLyric(tLyric));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should validate parameters correctly', () {
      // Arrange
      final params = CreateLyricParams(lyric: tLyric);

      // Act & Assert
      expect(params.lyric, tLyric);
      expect(params.lyric, tLyric);
    });
  });
}