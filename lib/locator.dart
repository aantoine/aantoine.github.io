import 'package:card/application/login/login_cubit.dart';
import 'package:card/application/planning/planning_session_cubit.dart';
import 'package:card/application/splash/splash_cubit.dart';
import 'package:card/application/tables/tables_cubit.dart';
import 'package:card/application/user/user_cubit.dart';
import 'package:card/domain/planning_session/planning_session_repository.dart';
import 'package:card/domain/tables/table_repository.dart';
import 'package:card/domain/user/user_repository.dart';
import 'package:card/infrastructure/repositories/planning_session_repository_impl.dart';
import 'package:card/infrastructure/repositories/table_repository_impl.dart';
import 'package:card/infrastructure/repositories/user_repository_impl.dart';
import 'package:card/infrastructure/sources/authentication/authentication_source.dart';
import 'package:card/infrastructure/sources/persistence/external_persistence_source.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator
    // cubits
    ..registerFactory<LoginCubit>(
          () => LoginCubit(locator()),
    )
    ..registerFactory<SplashCubit>(
          () => SplashCubit(locator()),
    )
    ..registerFactory<TablesCubit>(
          () => TablesCubit(locator()),
    )
    ..registerFactory<PlanningSessionCubit>(
          () => PlanningSessionCubit(locator(), locator()),
    )
    ..registerFactory<UserCubit>(
          () => UserCubit(locator()),
    )

    // repositories
    ..registerLazySingleton<UserRepository>(
          () => UserRepositoryImplementation(locator()),
    )
    ..registerLazySingleton<TableRepository>(
          () => TableRepositoryImplementation(locator(), locator()),
    )
    ..registerLazySingleton<PlanningSessionRepository>(
          () => PlanningSessionRepositoryImpl(locator()),
    )

    // sources
    ..registerLazySingleton<AuthenticationSource>(
      () => DummyAuthSource(),
    )
    ..registerLazySingleton<ExternalPersistenceSource>(
          () => DummyPersistenceSource(),
    );
}
