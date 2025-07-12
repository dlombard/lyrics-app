import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/lyric.dart';
import '../../domain/entities/lyric_section.dart';
import '../../domain/entities/arrangement.dart';
import '../../domain/repositories/lyrics_repository.dart';
import '../datasources/lyrics_data_source_interface.dart';

class LyricsRepositoryImpl implements LyricsRepository {
  final LyricsDataSource localDataSource;
  final Uuid uuid;

  LyricsRepositoryImpl({
    required this.localDataSource,
    required this.uuid,
  });

  @override
  Future<Either<Failure, List<Lyric>>> getAllLyrics() async {
    try {
      final lyrics = await localDataSource.getAllLyrics();
      return Right(lyrics);
    } catch (e) {
      return Left(DatabaseFailure('Failed to get lyrics: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Lyric>> getLyricById(String id) async {
    try {
      final lyric = await localDataSource.getLyricById(id);
      if (lyric == null) {
        return const Left(DatabaseFailure('Lyric not found'));
      }
      return Right(lyric);
    } catch (e) {
      return Left(DatabaseFailure('Failed to get lyric: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Lyric>> createLyric(Lyric lyric) async {
    try {
      if (lyric.title.trim().isEmpty) {
        return const Left(ValidationFailure('Lyric title cannot be empty'));
      }

      final now = DateTime.now();
      final lyricId = lyric.id.isNotEmpty ? lyric.id : uuid.v4();
      
      final defaultArrangementId = uuid.v4();
      final defaultArrangement = Arrangement(
        id: defaultArrangementId,
        name: 'Default',
        lyricId: lyricId,
        sectionOrder: lyric.sections.map((s) => s.id).toList(),
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      );

      final updatedLyric = lyric.copyWith(
        id: lyricId,
        defaultArrangementId: defaultArrangementId,
        arrangements: [defaultArrangement, ...lyric.arrangements],
        createdAt: lyric.createdAt == lyric.updatedAt ? now : lyric.createdAt,
        updatedAt: now,
      );

      final createdLyric = await localDataSource.createLyric(updatedLyric);
      
      return Right(createdLyric);
    } catch (e) {
      return Left(DatabaseFailure('Failed to create lyric: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Lyric>> updateLyric(Lyric lyric) async {
    try {
      if (lyric.title.trim().isEmpty) {
        return const Left(ValidationFailure('Lyric title cannot be empty'));
      }

      final updatedLyric = lyric.copyWith(updatedAt: DateTime.now());
      final result = await localDataSource.updateLyric(updatedLyric);
      
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure('Failed to update lyric: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteLyric(String id) async {
    try {
      await localDataSource.deleteLyric(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Failed to delete lyric: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Lyric>>> searchLyrics(String query) async {
    try {
      if (query.trim().isEmpty) {
        return const Right([]);
      }
      final lyrics = await localDataSource.searchLyrics(query.trim());
      return Right(lyrics);
    } catch (e) {
      return Left(DatabaseFailure('Failed to search lyrics: ${e.toString()}'));
    }
  }

  // Simplified implementations for section and arrangement methods
  @override
  Future<Either<Failure, LyricSection>> createSection(LyricSection section) async {
    return Left(DatabaseFailure('Method not implemented yet'));
  }

  @override
  Future<Either<Failure, LyricSection>> updateSection(LyricSection section) async {
    return Left(DatabaseFailure('Method not implemented yet'));
  }

  @override
  Future<Either<Failure, void>> deleteSection(String sectionId) async {
    return Left(DatabaseFailure('Method not implemented yet'));
  }

  @override
  Future<Either<Failure, List<LyricSection>>> reorderSections(
    String lyricId, 
    List<String> sectionIds,
  ) async {
    return Left(DatabaseFailure('Method not implemented yet'));
  }

  @override
  Future<Either<Failure, Arrangement>> createArrangement(Arrangement arrangement) async {
    return Left(DatabaseFailure('Method not implemented yet'));
  }

  @override
  Future<Either<Failure, Arrangement>> updateArrangement(Arrangement arrangement) async {
    return Left(DatabaseFailure('Method not implemented yet'));
  }

  @override
  Future<Either<Failure, void>> deleteArrangement(String arrangementId) async {
    return Left(DatabaseFailure('Method not implemented yet'));
  }

  @override
  Future<Either<Failure, String>> exportLyric(String lyricId) async {
    return Left(DatabaseFailure('Method not implemented yet'));
  }

  @override
  Future<Either<Failure, Lyric>> importLyric(String data) async {
    return Left(DatabaseFailure('Method not implemented yet'));
  }
}