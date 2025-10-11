import 'package:get_it/get_it.dart';
import '../../data/datasources/photo_local_datasource.dart';
import '../../data/repositories/photo_repository_impl.dart';
import '../../domain/repositories/photo_repository.dart';
import '../../domain/usecases/photo_usecases.dart';
import '../../domain/usecases/layout_usecases.dart';
import '../../presentation/bloc/photo_editor_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(
    () => PhotoEditorBloc(
      pickPhotoUseCase: sl(),
      pickMultiplePhotosUseCase: sl(),
      savePhotoUseCase: sl(),
      savePhotosAsPdfUseCase: sl(),
      sharePhotoUseCase: sl(),
      calculateLayoutUseCase: sl(),
      validateLayoutConfigUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => PickPhotoUseCase(sl()));
  sl.registerLazySingleton(() => PickMultiplePhotosUseCase(sl()));
  sl.registerLazySingleton(() => SavePhotoUseCase(sl()));
  sl.registerLazySingleton(() => SavePhotosAsPdfUseCase(sl()));
  sl.registerLazySingleton(() => SharePhotoUseCase(sl()));
  sl.registerLazySingleton(() => CalculateLayoutUseCase());
  sl.registerLazySingleton(() => ValidateLayoutConfigUseCase());

  // Repositories
  sl.registerLazySingleton<PhotoRepository>(
    () => PhotoRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<PhotoLocalDataSource>(
    () => PhotoLocalDataSource(),
  );
}