import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/lyric.dart';
import '../repositories/lyrics_repository.dart';

class GetAllLyrics implements UseCase<List<Lyric>, NoParams> {
  final LyricsRepository repository;

  GetAllLyrics(this.repository);

  @override
  Future<Either<Failure, List<Lyric>>> call(NoParams params) async {
    return await repository.getAllLyrics();
  }
}