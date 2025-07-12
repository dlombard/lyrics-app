import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/lyric.dart';
import '../entities/lyric_section.dart';
import '../entities/arrangement.dart';

abstract class LyricsRepository {
  Future<Either<Failure, List<Lyric>>> getAllLyrics();
  Future<Either<Failure, Lyric>> getLyricById(String id);
  Future<Either<Failure, Lyric>> createLyric(Lyric lyric);
  Future<Either<Failure, Lyric>> updateLyric(Lyric lyric);
  Future<Either<Failure, void>> deleteLyric(String id);
  
  Future<Either<Failure, LyricSection>> createSection(LyricSection section);
  Future<Either<Failure, LyricSection>> updateSection(LyricSection section);
  Future<Either<Failure, void>> deleteSection(String sectionId);
  Future<Either<Failure, List<LyricSection>>> reorderSections(
    String lyricId, 
    List<String> sectionIds,
  );
  
  Future<Either<Failure, Arrangement>> createArrangement(Arrangement arrangement);
  Future<Either<Failure, Arrangement>> updateArrangement(Arrangement arrangement);
  Future<Either<Failure, void>> deleteArrangement(String arrangementId);
  
  Future<Either<Failure, List<Lyric>>> searchLyrics(String query);
  Future<Either<Failure, String>> exportLyric(String lyricId);
  Future<Either<Failure, Lyric>> importLyric(String data);
}