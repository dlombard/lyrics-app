import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';

import 'package:lyrics_app/features/lyrics/data/repositories/lyrics_repository_impl.dart';
import 'package:lyrics_app/features/lyrics/data/datasources/lyrics_data_source_interface.dart';
import 'package:lyrics_app/features/lyrics/domain/entities/lyric.dart';
import 'package:lyrics_app/features/lyrics/domain/entities/lyric_section.dart';
import 'package:lyrics_app/features/lyrics/domain/entities/arrangement.dart';
import 'package:lyrics_app/features/lyrics/domain/entities/section_type.dart';
import 'package:lyrics_app/core/error/failures.dart';

import 'lyrics_repository_impl_test.mocks.dart';

@GenerateMocks([LyricsDataSource, Uuid])
void main() {
  late LyricsRepositoryImpl repository;
  late MockLyricsDataSource mockLocalDataSource;
  late MockUuid mockUuid;

  setUp(() {
    mockLocalDataSource = MockLyricsDataSource();
    mockUuid = MockUuid();
    repository = LyricsRepositoryImpl(
      localDataSource: mockLocalDataSource,
      uuid: mockUuid,
    );
  });

  group('getAllLyrics', () {
    final tLyrics = [
      Lyric(
        id: '1',
        title: 'Test Song',
        sections: const [],
        arrangements: const [],
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 1),
      ),
    ];

    test('should return lyrics list when call to data source is successful', () async {
      // arrange
      when(mockLocalDataSource.getAllLyrics()).thenAnswer((_) async => tLyrics);

      // act
      final result = await repository.getAllLyrics();

      // assert
      verify(mockLocalDataSource.getAllLyrics());
      expect(result, equals(Right(tLyrics)));
    });

    test('should return DatabaseFailure when call to data source throws exception', () async {
      // arrange
      when(mockLocalDataSource.getAllLyrics()).thenThrow(Exception('Database error'));

      // act
      final result = await repository.getAllLyrics();

      // assert
      verify(mockLocalDataSource.getAllLyrics());
      expect(result, isA<Left<Failure, List<Lyric>>>());
      result.fold(
        (failure) => expect(failure, isA<DatabaseFailure>()),
        (lyrics) => fail('Should return failure'),
      );
    });
  });

  group('getLyricById', () {
    const tLyricId = '1';
    final tLyric = Lyric(
      id: tLyricId,
      title: 'Test Song',
      sections: const [],
      arrangements: const [],
      createdAt: DateTime(2023, 1, 1),
      updatedAt: DateTime(2023, 1, 1),
    );

    test('should return lyric when call to data source is successful', () async {
      // arrange
      when(mockLocalDataSource.getLyricById(tLyricId)).thenAnswer((_) async => tLyric);

      // act
      final result = await repository.getLyricById(tLyricId);

      // assert
      verify(mockLocalDataSource.getLyricById(tLyricId));
      expect(result, equals(Right(tLyric)));
    });

    test('should return DatabaseFailure when lyric is not found', () async {
      // arrange
      when(mockLocalDataSource.getLyricById(tLyricId)).thenAnswer((_) async => null);

      // act
      final result = await repository.getLyricById(tLyricId);

      // assert
      verify(mockLocalDataSource.getLyricById(tLyricId));
      expect(result, isA<Left<Failure, Lyric>>());
      result.fold(
        (failure) => expect(failure, const DatabaseFailure('Lyric not found')),
        (lyric) => fail('Should return failure'),
      );
    });

    test('should return DatabaseFailure when call to data source throws exception', () async {
      // arrange
      when(mockLocalDataSource.getLyricById(tLyricId)).thenThrow(Exception('Database error'));

      // act
      final result = await repository.getLyricById(tLyricId);

      // assert
      verify(mockLocalDataSource.getLyricById(tLyricId));
      expect(result, isA<Left<Failure, Lyric>>());
      result.fold(
        (failure) => expect(failure, isA<DatabaseFailure>()),
        (lyric) => fail('Should return failure'),
      );
    });
  });

  group('createLyric', () {
    const tLyricId = 'generated-id';
    const tArrangementId = 'arrangement-id';
    final tSection = LyricSection(
      id: 'section-1',
      title: 'Verse 1',
      content: 'This is verse content',
      type: SectionType.verse,
      order: 1,
      createdAt: DateTime(2023, 1, 1),
      updatedAt: DateTime(2023, 1, 1),
    );
    final tLyric = Lyric(
      id: '',
      title: 'Test Song',
      sections: [tSection],
      arrangements: const [],
      createdAt: DateTime(2023, 1, 1),
      updatedAt: DateTime(2023, 1, 1),
    );

    test('should create lyric with generated ID and default arrangement when successful', () async {
      // arrange
      when(mockUuid.v4()).thenReturn(tLyricId);
      when(mockLocalDataSource.createLyric(any)).thenAnswer((invocation) async {
        return invocation.positionalArguments[0] as Lyric;
      });

      // act
      final result = await repository.createLyric(tLyric);

      // assert
      verify(mockUuid.v4()).called(2); // Once for lyric ID, once for arrangement ID
      verify(mockLocalDataSource.createLyric(any));
      
      expect(result, isA<Right<Failure, Lyric>>());
      result.fold(
        (failure) => fail('Should return success'),
        (lyric) {
          expect(lyric.id, equals(tLyricId));
          expect(lyric.arrangements.length, equals(1));
          expect(lyric.defaultArrangementId, isNotEmpty);
          expect(lyric.arrangements.first.name, equals('Default'));
          expect(lyric.arrangements.first.isDefault, isTrue);
        },
      );
    });

    test('should preserve existing ID when lyric already has one', () async {
      // arrange
      const existingId = 'existing-id';
      final lyricWithId = tLyric.copyWith(id: existingId);
      when(mockUuid.v4()).thenReturn(tArrangementId);
      when(mockLocalDataSource.createLyric(any)).thenAnswer((invocation) async {
        return invocation.positionalArguments[0] as Lyric;
      });

      // act
      final result = await repository.createLyric(lyricWithId);

      // assert
      verify(mockUuid.v4()).called(1); // Only for arrangement ID
      verify(mockLocalDataSource.createLyric(any));
      
      result.fold(
        (failure) => fail('Should return success'),
        (lyric) => expect(lyric.id, equals(existingId)),
      );
    });

    test('should return ValidationFailure when title is empty', () async {
      // arrange
      final lyricWithEmptyTitle = tLyric.copyWith(title: '');

      // act
      final result = await repository.createLyric(lyricWithEmptyTitle);

      // assert
      verifyNever(mockLocalDataSource.createLyric(any));
      expect(result, isA<Left<Failure, Lyric>>());
      result.fold(
        (failure) => expect(failure, const ValidationFailure('Lyric title cannot be empty')),
        (lyric) => fail('Should return failure'),
      );
    });

    test('should return ValidationFailure when title is only whitespace', () async {
      // arrange
      final lyricWithWhitespaceTitle = tLyric.copyWith(title: '   ');

      // act
      final result = await repository.createLyric(lyricWithWhitespaceTitle);

      // assert
      verifyNever(mockLocalDataSource.createLyric(any));
      expect(result, isA<Left<Failure, Lyric>>());
      result.fold(
        (failure) => expect(failure, const ValidationFailure('Lyric title cannot be empty')),
        (lyric) => fail('Should return failure'),
      );
    });

    test('should return DatabaseFailure when data source throws exception', () async {
      // arrange
      when(mockUuid.v4()).thenReturn(tLyricId);
      when(mockLocalDataSource.createLyric(any)).thenThrow(Exception('Database error'));

      // act
      final result = await repository.createLyric(tLyric);

      // assert
      verify(mockLocalDataSource.createLyric(any));
      expect(result, isA<Left<Failure, Lyric>>());
      result.fold(
        (failure) => expect(failure, isA<DatabaseFailure>()),
        (lyric) => fail('Should return failure'),
      );
    });
  });

  group('updateLyric', () {
    final tLyric = Lyric(
      id: '1',
      title: 'Updated Song',
      sections: const [],
      arrangements: const [],
      createdAt: DateTime(2023, 1, 1),
      updatedAt: DateTime(2023, 1, 1),
    );

    test('should update lyric with new timestamp when successful', () async {
      // arrange
      when(mockLocalDataSource.updateLyric(any)).thenAnswer((invocation) async {
        return invocation.positionalArguments[0] as Lyric;
      });

      // act
      final result = await repository.updateLyric(tLyric);

      // assert
      verify(mockLocalDataSource.updateLyric(any));
      expect(result, isA<Right<Failure, Lyric>>());
      result.fold(
        (failure) => fail('Should return success'),
        (lyric) {
          expect(lyric.id, equals(tLyric.id));
          expect(lyric.updatedAt.isAfter(tLyric.updatedAt), isTrue);
        },
      );
    });

    test('should return ValidationFailure when title is empty', () async {
      // arrange
      final lyricWithEmptyTitle = tLyric.copyWith(title: '');

      // act
      final result = await repository.updateLyric(lyricWithEmptyTitle);

      // assert
      verifyNever(mockLocalDataSource.updateLyric(any));
      expect(result, isA<Left<Failure, Lyric>>());
      result.fold(
        (failure) => expect(failure, const ValidationFailure('Lyric title cannot be empty')),
        (lyric) => fail('Should return failure'),
      );
    });

    test('should return DatabaseFailure when data source throws exception', () async {
      // arrange
      when(mockLocalDataSource.updateLyric(any)).thenThrow(Exception('Database error'));

      // act
      final result = await repository.updateLyric(tLyric);

      // assert
      verify(mockLocalDataSource.updateLyric(any));
      expect(result, isA<Left<Failure, Lyric>>());
      result.fold(
        (failure) => expect(failure, isA<DatabaseFailure>()),
        (lyric) => fail('Should return failure'),
      );
    });
  });

  group('deleteLyric', () {
    const tLyricId = '1';

    test('should delete lyric when successful', () async {
      // arrange
      when(mockLocalDataSource.deleteLyric(tLyricId)).thenAnswer((_) async {});

      // act
      final result = await repository.deleteLyric(tLyricId);

      // assert
      verify(mockLocalDataSource.deleteLyric(tLyricId));
      expect(result, equals(const Right<Failure, void>(null)));
    });

    test('should return DatabaseFailure when data source throws exception', () async {
      // arrange
      when(mockLocalDataSource.deleteLyric(tLyricId)).thenThrow(Exception('Database error'));

      // act
      final result = await repository.deleteLyric(tLyricId);

      // assert
      verify(mockLocalDataSource.deleteLyric(tLyricId));
      expect(result, isA<Left<Failure, void>>());
      result.fold(
        (failure) => expect(failure, isA<DatabaseFailure>()),
        (value) => fail('Should return failure'),
      );
    });
  });

  group('searchLyrics', () {
    const tQuery = 'test';
    final tLyrics = [
      Lyric(
        id: '1',
        title: 'Test Song',
        sections: const [],
        arrangements: const [],
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 1),
      ),
    ];

    test('should return search results when successful', () async {
      // arrange
      when(mockLocalDataSource.searchLyrics(tQuery)).thenAnswer((_) async => tLyrics);

      // act
      final result = await repository.searchLyrics(tQuery);

      // assert
      verify(mockLocalDataSource.searchLyrics(tQuery));
      expect(result, equals(Right(tLyrics)));
    });

    test('should return empty list when query is empty', () async {
      // act
      final result = await repository.searchLyrics('');

      // assert
      verifyNever(mockLocalDataSource.searchLyrics(any));
      expect(result, equals(const Right<Failure, List<Lyric>>(<Lyric>[])));
    });

    test('should return empty list when query is only whitespace', () async {
      // act
      final result = await repository.searchLyrics('   ');

      // assert
      verifyNever(mockLocalDataSource.searchLyrics(any));
      expect(result, equals(const Right<Failure, List<Lyric>>(<Lyric>[])));
    });

    test('should trim query before searching', () async {
      // arrange
      const queryWithSpaces = '  test  ';
      when(mockLocalDataSource.searchLyrics('test')).thenAnswer((_) async => tLyrics);

      // act
      final result = await repository.searchLyrics(queryWithSpaces);

      // assert
      verify(mockLocalDataSource.searchLyrics('test'));
      expect(result, equals(Right(tLyrics)));
    });

    test('should return DatabaseFailure when data source throws exception', () async {
      // arrange
      when(mockLocalDataSource.searchLyrics(tQuery)).thenThrow(Exception('Database error'));

      // act
      final result = await repository.searchLyrics(tQuery);

      // assert
      verify(mockLocalDataSource.searchLyrics(tQuery));
      expect(result, isA<Left<Failure, List<Lyric>>>());
      result.fold(
        (failure) => expect(failure, isA<DatabaseFailure>()),
        (lyrics) => fail('Should return failure'),
      );
    });
  });

  group('unimplemented methods', () {
    test('should return DatabaseFailure for createSection', () async {
      final section = LyricSection(
        id: '1',
        title: 'Test',
        content: 'Content',
        type: SectionType.verse,
        order: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final result = await repository.createSection(section);

      expect(result, isA<Left<Failure, LyricSection>>());
      result.fold(
        (failure) => expect(failure, const DatabaseFailure('Method not implemented yet')),
        (section) => fail('Should return failure'),
      );
    });

    test('should return DatabaseFailure for updateSection', () async {
      final section = LyricSection(
        id: '1',
        title: 'Test',
        content: 'Content',
        type: SectionType.verse,
        order: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final result = await repository.updateSection(section);

      expect(result, isA<Left<Failure, LyricSection>>());
      result.fold(
        (failure) => expect(failure, const DatabaseFailure('Method not implemented yet')),
        (section) => fail('Should return failure'),
      );
    });

    test('should return DatabaseFailure for deleteSection', () async {
      final result = await repository.deleteSection('1');

      expect(result, isA<Left<Failure, void>>());
      result.fold(
        (failure) => expect(failure, const DatabaseFailure('Method not implemented yet')),
        (value) => fail('Should return failure'),
      );
    });

    test('should return DatabaseFailure for reorderSections', () async {
      final result = await repository.reorderSections('1', ['1', '2']);

      expect(result, isA<Left<Failure, List<LyricSection>>>());
      result.fold(
        (failure) => expect(failure, const DatabaseFailure('Method not implemented yet')),
        (sections) => fail('Should return failure'),
      );
    });

    test('should return DatabaseFailure for createArrangement', () async {
      final arrangement = Arrangement(
        id: '1',
        name: 'Test',
        lyricId: '1',
        sectionOrder: const ['1'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final result = await repository.createArrangement(arrangement);

      expect(result, isA<Left<Failure, Arrangement>>());
      result.fold(
        (failure) => expect(failure, const DatabaseFailure('Method not implemented yet')),
        (arrangement) => fail('Should return failure'),
      );
    });

    test('should return DatabaseFailure for updateArrangement', () async {
      final arrangement = Arrangement(
        id: '1',
        name: 'Test',
        lyricId: '1',
        sectionOrder: const ['1'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final result = await repository.updateArrangement(arrangement);

      expect(result, isA<Left<Failure, Arrangement>>());
      result.fold(
        (failure) => expect(failure, const DatabaseFailure('Method not implemented yet')),
        (arrangement) => fail('Should return failure'),
      );
    });

    test('should return DatabaseFailure for deleteArrangement', () async {
      final result = await repository.deleteArrangement('1');

      expect(result, isA<Left<Failure, void>>());
      result.fold(
        (failure) => expect(failure, const DatabaseFailure('Method not implemented yet')),
        (value) => fail('Should return failure'),
      );
    });

    test('should return DatabaseFailure for exportLyric', () async {
      final result = await repository.exportLyric('1');

      expect(result, isA<Left<Failure, String>>());
      result.fold(
        (failure) => expect(failure, const DatabaseFailure('Method not implemented yet')),
        (data) => fail('Should return failure'),
      );
    });

    test('should return DatabaseFailure for importLyric', () async {
      final result = await repository.importLyric('data');

      expect(result, isA<Left<Failure, Lyric>>());
      result.fold(
        (failure) => expect(failure, const DatabaseFailure('Method not implemented yet')),
        (lyric) => fail('Should return failure'),
      );
    });
  });
}