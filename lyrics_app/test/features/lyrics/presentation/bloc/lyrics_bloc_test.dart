import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';

import 'package:lyrics_app/features/lyrics/presentation/bloc/lyrics_bloc.dart';
import 'package:lyrics_app/features/lyrics/presentation/bloc/lyrics_event.dart';
import 'package:lyrics_app/features/lyrics/presentation/bloc/lyrics_state.dart';
import 'package:lyrics_app/features/lyrics/domain/usecases/get_all_lyrics.dart';
import 'package:lyrics_app/features/lyrics/domain/usecases/create_lyric.dart';
import 'package:lyrics_app/features/lyrics/domain/usecases/search_lyrics.dart';
import 'package:lyrics_app/features/lyrics/domain/entities/lyric.dart';
import 'package:lyrics_app/features/lyrics/domain/entities/lyric_section.dart';
import 'package:lyrics_app/features/lyrics/domain/entities/arrangement.dart';
import 'package:lyrics_app/features/lyrics/domain/entities/section_type.dart';
import 'package:lyrics_app/core/error/failures.dart';
import 'package:lyrics_app/core/usecases/usecase.dart';

import 'lyrics_bloc_test.mocks.dart';

@GenerateMocks([GetAllLyrics, CreateLyric, SearchLyrics])
void main() {
  late LyricsBloc bloc;
  late MockGetAllLyrics mockGetAllLyrics;
  late MockCreateLyric mockCreateLyric;
  late MockSearchLyrics mockSearchLyrics;

  setUp(() {
    mockGetAllLyrics = MockGetAllLyrics();
    mockCreateLyric = MockCreateLyric();
    mockSearchLyrics = MockSearchLyrics();
    bloc = LyricsBloc(
      getAllLyrics: mockGetAllLyrics,
      createLyric: mockCreateLyric,
      searchLyrics: mockSearchLyrics,
    );
  });

  tearDown(() {
    bloc.close();
  });

  final tLyric = Lyric(
    id: '1',
    title: 'Test Song',
    sections: [
      LyricSection(
        id: 'section1',
        title: 'Verse 1',
        content: 'Test content',
        type: SectionType.verse,
        order: 1,
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 1),
      ),
    ],
    arrangements: const [],
    createdAt: DateTime(2023, 1, 1),
    updatedAt: DateTime(2023, 1, 1),
  );

  final tLyricsList = [tLyric];

  group('LyricsBloc', () {
    test('initial state should be LyricsInitial', () {
      expect(bloc.state, equals(LyricsInitial()));
    });

    group('LoadLyrics', () {
      blocTest<LyricsBloc, LyricsState>(
        'should emit [LyricsLoading, LyricsLoaded] when data is loaded successfully',
        build: () {
          when(mockGetAllLyrics(any))
              .thenAnswer((_) async => Right(tLyricsList));
          return bloc;
        },
        act: (bloc) => bloc.add(LoadLyrics()),
        expect: () => [
          LyricsLoading(),
          LyricsLoaded(lyrics: tLyricsList),
        ],
        verify: (_) {
          verify(mockGetAllLyrics(any));
        },
      );

      blocTest<LyricsBloc, LyricsState>(
        'should emit [LyricsLoading, LyricsError] when loading fails',
        build: () {
          when(mockGetAllLyrics(any))
              .thenAnswer((_) async => const Left(DatabaseFailure('Database error')));
          return bloc;
        },
        act: (bloc) => bloc.add(LoadLyrics()),
        expect: () => [
          LyricsLoading(),
          const LyricsError('Database error'),
        ],
      );
    });

    group('CreateLyricEvent', () {
      blocTest<LyricsBloc, LyricsState>(
        'should emit [LyricsLoading, LyricsLoaded] when lyric is created successfully',
        seed: () => LyricsLoaded(lyrics: const []),
        build: () {
          when(mockCreateLyric(any))
              .thenAnswer((_) async => Right(tLyric));
          return bloc;
        },
        act: (bloc) => bloc.add(CreateLyricEvent(tLyric)),
        expect: () => [
          LyricsLoading(),
          LyricsLoaded(lyrics: [tLyric]),
        ],
        verify: (_) {
          verify(mockCreateLyric(any));
        },
      );

      blocTest<LyricsBloc, LyricsState>(
        'should emit [LyricsLoading, LyricsError] when creation fails',
        seed: () => LyricsLoaded(lyrics: const []),
        build: () {
          when(mockCreateLyric(any))
              .thenAnswer((_) async => const Left(ValidationFailure('Title cannot be empty')));
          return bloc;
        },
        act: (bloc) => bloc.add(CreateLyricEvent(tLyric)),
        expect: () => [
          LyricsLoading(),
          const LyricsError('Title cannot be empty'),
        ],
      );
    });

    group('SearchLyricsEvent', () {
      const tQuery = 'test';

      blocTest<LyricsBloc, LyricsState>(
        'should emit search state when search is successful',
        seed: () => LyricsLoaded(lyrics: tLyricsList),
        build: () {
          when(mockSearchLyrics(any))
              .thenAnswer((_) async => Right(tLyricsList));
          return bloc;
        },
        act: (bloc) => bloc.add(const SearchLyricsEvent(tQuery)),
        expect: () => [
          isA<LyricsLoaded>().having((state) => state.isSearching, 'isSearching', true),
        ],
        verify: (_) {
          verify(mockSearchLyrics(any));
        },
      );

      blocTest<LyricsBloc, LyricsState>(
        'should clear search when query is empty',
        seed: () => LyricsLoaded(lyrics: [tLyric], isSearching: true, searchQuery: 'old'),
        build: () => bloc,
        act: (bloc) => bloc.add(const SearchLyricsEvent('')),
        expect: () => [
          LyricsLoaded(lyrics: [tLyric], isSearching: false, searchQuery: ''),
        ],
      );

      blocTest<LyricsBloc, LyricsState>(
        'should emit error when search fails',
        seed: () => LyricsLoaded(lyrics: tLyricsList),
        build: () {
          when(mockSearchLyrics(any))
              .thenAnswer((_) async => const Left(DatabaseFailure('Search failed')));
          return bloc;
        },
        act: (bloc) => bloc.add(const SearchLyricsEvent(tQuery)),
        expect: () => [
          LyricsLoaded(lyrics: [tLyric], isSearching: true, searchQuery: tQuery),
          const LyricsError('Search failed'),
        ],
      );
    });

    group('ClearSearch', () {
      blocTest<LyricsBloc, LyricsState>(
        'should trigger LoadLyrics when clearing search',
        seed: () => LyricsLoaded(lyrics: [], isSearching: true),
        build: () {
          when(mockGetAllLyrics(any))
              .thenAnswer((_) async => Right(tLyricsList));
          return bloc;
        },
        act: (bloc) => bloc.add(ClearSearch()),
        expect: () => [
          LyricsLoading(),
          LyricsLoaded(lyrics: tLyricsList),
        ],
      );
    });

    group('Error Handling', () {
      blocTest<LyricsBloc, LyricsState>(
        'should handle CacheFailure',
        build: () {
          when(mockGetAllLyrics(any))
              .thenAnswer((_) async => const Left(CacheFailure('Cache error')));
          return bloc;
        },
        act: (bloc) => bloc.add(LoadLyrics()),
        expect: () => [
          LyricsLoading(),
          const LyricsError('Cache error'),
        ],
      );

      blocTest<LyricsBloc, LyricsState>(
        'should handle ValidationFailure',
        seed: () => LyricsLoaded(lyrics: const []),
        build: () {
          when(mockCreateLyric(any))
              .thenAnswer((_) async => const Left(ValidationFailure('Validation failed')));
          return bloc;
        },
        act: (bloc) => bloc.add(CreateLyricEvent(tLyric)),
        expect: () => [
          LyricsLoading(),
          const LyricsError('Validation failed'),
        ],
      );

      blocTest<LyricsBloc, LyricsState>(
        'should handle DatabaseFailure',
        seed: () => LyricsLoaded(lyrics: const []),
        build: () {
          when(mockSearchLyrics(any))
              .thenAnswer((_) async => const Left(DatabaseFailure('Database error')));
          return bloc;
        },
        act: (bloc) => bloc.add(const SearchLyricsEvent('test')),
        expect: () => [
          LyricsLoaded(lyrics: [], isSearching: true, searchQuery: 'test'),
          const LyricsError('Database error'),
        ],
      );
    });

    group('State Transitions', () {
      blocTest<LyricsBloc, LyricsState>(
        'should handle multiple events correctly',
        build: () {
          when(mockGetAllLyrics(any))
              .thenAnswer((_) async => Right(tLyricsList));
          when(mockSearchLyrics(any))
              .thenAnswer((_) async => const Right([]));
          return bloc;
        },
        act: (bloc) async {
          bloc.add(LoadLyrics());
          await Future.delayed(const Duration(milliseconds: 100));
          bloc.add(const SearchLyricsEvent('test'));
        },
        expect: () => [
          LyricsLoading(),
          LyricsLoaded(lyrics: tLyricsList),
          LyricsLoaded(lyrics: [tLyric], isSearching: true, searchQuery: 'test'),
          LyricsLoaded(lyrics: [], isSearching: true, searchQuery: 'test'),
        ],
      );
    });

    group('Edge Cases', () {
      blocTest<LyricsBloc, LyricsState>(
        'should not process CreateLyricEvent when not in LyricsLoaded state',
        build: () => bloc,
        act: (bloc) => bloc.add(CreateLyricEvent(tLyric)),
        expect: () => [],
        verify: (_) {
          verifyNever(mockCreateLyric(any));
        },
      );

      blocTest<LyricsBloc, LyricsState>(
        'should not process SearchLyricsEvent when not in LyricsLoaded state',
        build: () => bloc,
        act: (bloc) => bloc.add(const SearchLyricsEvent('test')),
        expect: () => [],
        verify: (_) {
          verifyNever(mockSearchLyrics(any));
        },
      );

      blocTest<LyricsBloc, LyricsState>(
        'should not process ClearSearch when not in LyricsLoaded state',
        build: () => bloc,
        act: (bloc) => bloc.add(ClearSearch()),
        expect: () => [],
      );
    });
  });
}