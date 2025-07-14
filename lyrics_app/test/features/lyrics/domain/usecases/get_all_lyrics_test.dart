import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:lyrics_app/core/error/failures.dart';
import 'package:lyrics_app/core/usecases/usecase.dart';
import 'package:lyrics_app/features/lyrics/domain/entities/lyric.dart';
import 'package:lyrics_app/features/lyrics/domain/entities/lyric_section.dart';
import 'package:lyrics_app/features/lyrics/domain/entities/section_type.dart';
import 'package:lyrics_app/features/lyrics/domain/entities/arrangement.dart';
import 'package:lyrics_app/features/lyrics/domain/repositories/lyrics_repository.dart';
import 'package:lyrics_app/features/lyrics/domain/usecases/get_all_lyrics.dart';

import 'get_all_lyrics_test.mocks.dart';

@GenerateMocks([LyricsRepository])
void main() {
  late GetAllLyrics usecase;
  late MockLyricsRepository mockRepository;

  setUp(() {
    mockRepository = MockLyricsRepository();
    usecase = GetAllLyrics(mockRepository);
  });

  group('GetAllLyrics', () {
    final now = DateTime.now();
    final tLyrics = [
      Lyric(
        id: '1',
        title: 'Test Song 1',
        artist: 'Test Artist',
        album: null,
        sections: [
          LyricSection(
            id: 'section-1',
            title: 'Verse 1',
            content: 'Test content',
            type: SectionType.verse,
            order: 0,
            createdAt: now,
            updatedAt: now,
          ),
        ],
        arrangements: [
          Arrangement(
            id: 'arr-1',
            name: 'Standard',
            lyricId: '1',
            sectionOrder: ['section-1'],
            isDefault: true,
            createdAt: now,
            updatedAt: now,
          ),
        ],
        tags: ['test'],
        createdAt: now,
        updatedAt: now,
      ),
      Lyric(
        id: '2',
        title: 'Test Song 2',
        artist: 'Another Artist',
        album: 'Test Album',
        sections: [
          LyricSection(
            id: 'section-2',
            title: 'Chorus',
            content: 'Another content',
            type: SectionType.chorus,
            order: 0,
            createdAt: now,
            updatedAt: now,
          ),
        ],
        arrangements: [],
        tags: [],
        createdAt: now,
        updatedAt: now,
      ),
    ];

    test('should get all lyrics from the repository', () async {
      // Arrange
      when(mockRepository.getAllLyrics())
          .thenAnswer((_) async => Right(tLyrics));

      // Act
      final result = await usecase(NoParams());

      // Assert
      expect(result, Right(tLyrics));
      verify(mockRepository.getAllLyrics());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return CacheFailure when repository fails', () async {
      // Arrange
      when(mockRepository.getAllLyrics())
          .thenAnswer((_) async => Left(CacheFailure('Cache error')));

      // Act
      final result = await usecase(NoParams());

      // Assert
      expect(result, Left(CacheFailure('Cache error')));
      verify(mockRepository.getAllLyrics());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return empty list when no lyrics exist', () async {
      // Arrange
      when(mockRepository.getAllLyrics())
          .thenAnswer((_) async => const Right([]));

      // Act
      final result = await usecase(NoParams());

      // Assert
      expect(result, const Right<Failure, List<Lyric>>([]));
      verify(mockRepository.getAllLyrics());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle repository throwing exception', () async {
      // Arrange
      when(mockRepository.getAllLyrics())
          .thenThrow(Exception('Database error'));

      // Act & Assert
      expect(() => usecase(NoParams()), throwsException);
      verify(mockRepository.getAllLyrics());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}