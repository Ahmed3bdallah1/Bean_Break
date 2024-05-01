import 'package:bath_room_app/core/controllers/auth/auth_controller.dart';
import 'package:bath_room_app/core/controllers/home/home_controller.dart';
import 'package:bath_room_app/core/controllers/location/location_controller.dart';
import 'package:bath_room_app/core/controllers/reviews/reviews_controller.dart';
import 'package:bath_room_app/core/network/local/cache_helper.dart';
import 'package:bath_room_app/core/network/remote/api_service.dart';
import 'package:connectivity/connectivity.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await ApiService.init();
  // externals
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Connectivity());

  sl.registerLazySingleton(() => ApiService());
  sl.registerLazySingleton(() => CacheHelper(sharedPreferences: sl()));

  // register controllers of the app
  sl.registerFactory(() => HomeController(apiService: sl()));
  sl.registerFactory(() => LocationController(apiService: sl()));
  sl.registerFactory(() => ReviewsController(apiService: sl()));
  sl.registerFactory(() => AuthController(
      apiService: sl(), sharedPreferences: sl(), cacheHelper: sl()));
}
