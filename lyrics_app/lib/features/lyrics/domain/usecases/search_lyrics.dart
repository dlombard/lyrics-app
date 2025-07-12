import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/lyric.dart';
import '../repositories/lyrics_repository.dart';

class SearchLyrics implements UseCase<List<Lyric>, SearchLyricsParams> {
  final LyricsRepository repository;

  SearchLyrics(this.repository);

  @override
  Future<Either<Failure, List<Lyric>>> call(SearchLyricsParams params) async {
    if (params.query.trim().isEmpty) {
      return const Right([]);
    }
    return await repository.searchLyrics(params.query);
  }
}

class SearchLyricsParams {
  final String query;

  SearchLyricsParams({required this.query});
}