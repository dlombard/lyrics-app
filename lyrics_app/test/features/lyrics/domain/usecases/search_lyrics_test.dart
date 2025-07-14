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
import 'package:lyrics_app/features/lyrics/domain/usecases/search_lyrics.dart';

import 'search_lyrics_test.mocks.dart';

@GenerateMocks([LyricsRepository])
void main() {
  late SearchLyrics usecase;
  late MockLyricsRepository mockRepository;

  setUp(() {
    mockRepository = MockLyricsRepository();
    usecase = SearchLyrics(mockRepository);
  });

  group('SearchLyrics', () {
    final now = DateTime.now();
    final tLyrics = [
      Lyric(
        id: '1',
        title: 'Amazing Grace',
        artist: 'Traditional',
        album: null,
        sections: [
          LyricSection(
            id: 'section-1',
            title: 'Verse 1',
            content: 'Amazing grace how sweet the sound',
            type: SectionType.verse,
            order: 0,
            createdAt: now,
            updatedAt: now,
          ),
        ],
        arrangements: [],
        tags: ['hymn', 'grace'],
        createdAt: now,
        updatedAt: now,
      ),
      Lyric(
        id: '2',
        title: 'Grace Like Rain',
        artist: 'Todd Agnew',
        album: 'Grace Like Rain',
        sections: [
          LyricSection(
            id: 'section-2',
            title: 'Chorus',
            content: 'Grace like rain falls down on me',
            type: SectionType.chorus,
            order: 0,
            createdAt: now,
            updatedAt: now,
          ),
        ],
        arrangements: [],
        tags: ['modern', 'worship'],
        createdAt: now,
        updatedAt: now,
      ),
    ];

    test('should search lyrics by query using the repository', () async {
      // Arrange
      const tQuery = 'grace';
      when(mockRepository.searchLyrics(any))
          .thenAnswer((_) async => Right(tLyrics));

      // Act
      final result = await usecase(SearchLyricsParams(query: tQuery));

      // Assert
      expect(result, Right(tLyrics));
      verify(mockRepository.searchLyrics(tQuery));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return empty list when no lyrics match query', () async {
      // Arrange
      const tQuery = 'nonexistent';
      when(mockRepository.searchLyrics(any))
          .thenAnswer((_) async => const Right<Failure, List<Lyric>>([]));

      // Act
      final result = await usecase(SearchLyricsParams(query: tQuery));

      // Assert
      expect(result, const Right<Failure, List<Lyric>>([]));
      verify(mockRepository.searchLyrics(tQuery));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle empty query string', () async {
      // Arrange
      const tQuery = '';

      // Act
      final result = await usecase(SearchLyricsParams(query: tQuery));

      // Assert
      expect(result, const Right<Failure, List<Lyric>>([]));
      verifyNever(mockRepository.searchLyrics(any));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle whitespace-only query', () async {
      // Arrange
      const tQuery = '   ';

      // Act
      final result = await usecase(SearchLyricsParams(query: tQuery));

      // Assert
      expect(result, const Right<Failure, List<Lyric>>([]));
      verifyNever(mockRepository.searchLyrics(any));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle case-insensitive search', () async {
      // Arrange
      const tQuery = 'GRACE';
      when(mockRepository.searchLyrics(any))
          .thenAnswer((_) async => Right(tLyrics));

      // Act
      final result = await usecase(SearchLyricsParams(query: tQuery));

      // Assert
      expect(result, Right(tLyrics));
      verify(mockRepository.searchLyrics(tQuery));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle special characters in query', () async {
      // Arrange
      const tQuery = 'grace & mercy';
      when(mockRepository.searchLyrics(any))
          .thenAnswer((_) async => const Right<Failure, List<Lyric>>([]));

      // Act
      final result = await usecase(SearchLyricsParams(query: tQuery));

      // Assert
      expect(result, const Right<Failure, List<Lyric>>([]));
      verify(mockRepository.searchLyrics(tQuery));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return CacheFailure when repository fails', () async {
      // Arrange
      const tQuery = 'grace';
      when(mockRepository.searchLyrics(any))
          .thenAnswer((_) async => Left(CacheFailure('Cache error')));

      // Act
      final result = await usecase(SearchLyricsParams(query: tQuery));

      // Assert
      expect(result, Left(CacheFailure('Cache error')));
      verify(mockRepository.searchLyrics(tQuery));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle repository throwing exception', () async {
      // Arrange
      const tQuery = 'grace';
      when(mockRepository.searchLyrics(any))
          .thenThrow(Exception('Database error'));

      // Act & Assert
      expect(() => usecase(SearchLyricsParams(query: tQuery)), throwsException);
      verify(mockRepository.searchLyrics(tQuery));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should validate parameters correctly', () {
      // Arrange
      const tQuery = 'test query';
      final params = SearchLyricsParams(query: tQuery);

      // Act & Assert
      expect(params.query, tQuery);
      expect(params.query, tQuery);
    });
  });
}