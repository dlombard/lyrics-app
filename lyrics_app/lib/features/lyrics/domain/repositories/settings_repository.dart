import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/presentation_settings.dart';

abstract class SettingsRepository {
  Future<Either<Failure, PresentationSettings>> getPresentationSettings();
  Future<Either<Failure, void>> savePresentationSettings(PresentationSettings settings);
}