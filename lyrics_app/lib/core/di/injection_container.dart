import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../features/lyrics/data/datasources/lyrics_data_source_interface.dart';
import '../../features/lyrics/data/datasources/lyrics_mock_data_source.dart';
import '../../features/lyrics/data/datasources/lyrics_hive_data_source.dart';
import '../../features/lyrics/data/repositories/lyrics_repository_impl.dart';
import '../../features/lyrics/domain/repositories/lyrics_repository.dart';
import '../../features/lyrics/domain/usecases/get_all_lyrics.dart';
import '../../features/lyrics/domain/usecases/create_lyric.dart';
import '../../features/lyrics/domain/usecases/search_lyrics.dart';
import '../../features/lyrics/domain/entities/lyric.dart';
import '../../features/lyrics/domain/entities/lyric_section.dart';
import '../../features/lyrics/domain/entities/arrangement.dart';
import '../../features/lyrics/domain/entities/section_type.dart';
import '../../features/lyrics/presentation/bloc/lyrics_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(SectionTypeAdapter());
  Hive.registerAdapter(LyricSectionAdapter());
  Hive.registerAdapter(ArrangementAdapter());
  Hive.registerAdapter(LyricAdapter());

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

  // Data sources - Use platform-specific implementation
  if (kIsWeb) {
    // Use mock data source for web to avoid Hive IndexedDB issues
    sl.registerLazySingleton<LyricsDataSource>(
      () => LyricsMockDataSource(),
    );
  } else {
    // Use Hive for mobile platforms - Initialize synchronously to avoid dependency issues
    final dataSource = LyricsHiveDataSource();
    await dataSource.init();
    sl.registerLazySingleton<LyricsDataSource>(() => dataSource);
  }

  // Core
  sl.registerLazySingleton(() => const Uuid());
}