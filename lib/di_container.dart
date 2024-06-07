import 'package:beak_break/core/network/data/auth_data_source/auth_data_source.dart';
import 'package:connectivity/connectivity.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/controllers/auth/auth_controller.dart';
import 'core/controllers/home/home_controller.dart';
import 'core/controllers/location/location_controller.dart';
import 'core/controllers/reviews/reviews_controller.dart';
import 'core/network/local/cache_helper.dart';
import 'core/network/remote/api_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await ApiService.init();
  // externals
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Connectivity());

  sl.registerLazySingleton(() => ApiService());
  sl.registerLazySingleton(() => CacheHelper(sharedPreferences: sl()));

  // register data_source
  sl.registerLazySingleton<AuthDataSource>(() => AuthDataSourceImp(
        apiService: sl(),
        cacheHelper: sl(),
        sharedPreferences: sl(),
      ));

  // register controllers of the app
  sl.registerFactory(() => HomeController(apiService: sl()));
  sl.registerFactory(() => LocationController(apiService: sl()));
  sl.registerFactory(() => ReviewsController(apiService: sl()));
  sl.registerFactory(
      () => AuthController(authDataSource: sl<AuthDataSource>()));
}
