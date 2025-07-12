import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';
import '../../features/lyrics/data/datasources/lyrics_data_source_interface.dart';
import '../../features/lyrics/data/datasources/lyrics_mock_data_source.dart';
import '../../features/lyrics/data/repositories/lyrics_repository_impl.dart';
import '../../features/lyrics/domain/repositories/lyrics_repository.dart';
import '../../features/lyrics/domain/usecases/get_all_lyrics.dart';
import '../../features/lyrics/domain/usecases/create_lyric.dart';
import '../../features/lyrics/domain/usecases/search_lyrics.dart';
import '../../features/lyrics/presentation/bloc/lyrics_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(() => LyricsBloc(
    getAllLyrics: sl(),
    createLyric: sl(),
    searchLyrics: sl(),
  ));

  // Use cases
  sl.registerLazySingleton(() => GetAllLyrics(sl()));
  sl.registerLazySingleton(() => CreateLyric(sl()));
  sl.registerLazySingleton(() => SearchLyrics(sl()));

  // Repository
  sl.registerLazySingleton<LyricsRepository>(
    () => LyricsRepositoryImpl(
      localDataSource: sl(),
      uuid: sl(),
    ),
  );

  // Data sources - Always use mock for now to avoid SQLite web issues
  sl.registerLazySingleton<LyricsDataSource>(
    () => LyricsMockDataSource(), // No sample data - start with empty list
  );

  // Core
  sl.registerLazySingleton(() => const Uuid());
}