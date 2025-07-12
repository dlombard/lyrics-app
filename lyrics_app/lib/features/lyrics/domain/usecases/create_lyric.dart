import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/lyric.dart';
import '../repositories/lyrics_repository.dart';

class CreateLyric implements UseCase<Lyric, CreateLyricParams> {
  final LyricsRepository repository;

  CreateLyric(this.repository);

  @override
  Future<Either<Failure, Lyric>> call(CreateLyricParams params) async {
    return await repository.createLyric(params.lyric);
  }
}

class CreateLyricParams {
  final Lyric lyric;

  CreateLyricParams({required this.lyric});
}