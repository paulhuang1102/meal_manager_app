import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_user.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/domain/usecases/logout.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/person/data/datasources/person_local_data_source.dart';
import 'features/person/data/repositories/person_repository_impl.dart';
import 'features/person/domain/repositories/person_repository.dart';
import 'features/person/domain/usecases/add_person.dart';
import 'features/person/domain/usecases/delete_person.dart';
import 'features/person/domain/usecases/get_persons.dart';
import 'features/person/domain/usecases/search_persons.dart';
import 'features/person/domain/usecases/update_person.dart';
import 'features/person/presentation/bloc/person_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  //! Features - Auth
  // Bloc
  sl.registerFactory(
    () => AuthBloc(login: sl(), logout: sl(), getCurrentUser: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Features - Person
  // Bloc
  sl.registerFactory(
    () => PersonBloc(
      getPersons: sl(),
      addPerson: sl(),
      updatePerson: sl(),
      deletePerson: sl(),
      searchPersons: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetPersons(sl()));
  sl.registerLazySingleton(() => AddPerson(sl()));
  sl.registerLazySingleton(() => UpdatePerson(sl()));
  sl.registerLazySingleton(() => DeletePerson(sl()));
  sl.registerLazySingleton(() => SearchPersons(sl()));

  // Repository
  sl.registerLazySingleton<PersonRepository>(
    () => PersonRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<PersonLocalDataSource>(
    () => PersonLocalDataSourceImpl(sharedPreferences: sl()),
  );
  
   // Meal Order
}
