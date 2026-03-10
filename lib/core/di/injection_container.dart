import 'package:e_tantana/core/network/network_info.dart';
import 'package:e_tantana/core/services/storage_service.dart';
import 'package:e_tantana/features/delivring/data/repository/delivering_repository_impl.dart';
import 'package:e_tantana/features/delivring/data/source/delivering_remote_source.dart';
import 'package:e_tantana/features/delivring/domain/repository/delivering_repository.dart';
import 'package:e_tantana/features/delivring/domain/usecases/delivering_usecases.dart';
import 'package:e_tantana/features/home/data/dataSrouce/dashboard_stats_data_source.dart';
import 'package:e_tantana/features/home/data/dataSrouce/dashboard_stats_data_source_impl.dart';
import 'package:e_tantana/features/home/data/repository/dashboard_stats_repository_impl.dart';
import 'package:e_tantana/features/home/domain/repository/dashboard_stats_repository.dart';
import 'package:e_tantana/features/home/domain/usecases/dashboard_stats_usecase.dart';
import 'package:e_tantana/features/map/data/repository/map_repository_impl.dart';
import 'package:e_tantana/features/map/data/source/map_remote_data_source.dart';
import 'package:e_tantana/features/map/domain/repository/map_repository.dart';
import 'package:e_tantana/features/map/domain/usecases/map_usecases.dart';
import 'package:e_tantana/features/order/data/dataSource/order_data_source.dart';
import 'package:e_tantana/features/order/data/dataSource/order_data_source_impl.dart';
import 'package:e_tantana/features/order/data/repository/order_repository_impl.dart';
import 'package:e_tantana/features/order/domain/repository/order_repository.dart';
import 'package:e_tantana/features/order/domain/usecases/order_usecases.dart';
import 'package:e_tantana/features/product/data/dataSource/product_data_source.dart';
import 'package:e_tantana/features/product/data/dataSource/product_data_source_impl.dart';
import 'package:e_tantana/features/product/data/repository/product_repository_impl.dart';
import 'package:e_tantana/features/product/domain/repository/product_repository.dart';
import 'package:e_tantana/features/product/domain/usecases/product_usecases.dart';
import 'package:e_tantana/features/stockPrediction/domain/usecases/stock_prediction_usecases.dart';
import 'package:e_tantana/shared/media/media_services.dart';
import 'package:e_tantana/shared/media/media_services_impl.dart';
import 'package:e_tantana/features/map/presentation/services/mapbox_geoservice.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:e_tantana/features/user/data/repository/user_repository_impl.dart';
import 'package:e_tantana/features/user/data/source/user_remote_source.dart';
import 'package:e_tantana/features/user/domain/repository/user_repository.dart';
import 'package:e_tantana/features/user/domain/usecases/user_usecases.dart';

import 'package:e_tantana/features/auth/data/repository/auth_repository_impl.dart';
import 'package:e_tantana/features/auth/data/source/auth_remote_source.dart';
import 'package:e_tantana/features/auth/data/source/auth_remote_source_impl.dart';
import 'package:e_tantana/features/auth/domain/repository/auth_repository.dart';
import 'package:e_tantana/features/auth/domain/usecases/auth_usecases.dart';
import 'package:e_tantana/features/auth/data/source/email_auth_service.dart';
import 'package:e_tantana/features/auth/data/source/social_auth_service.dart';

// [IMPORT_ANCHOR]
final sl = GetIt.instance;

Future<void> init() async {
  // supabase client & internet connection ------
  await _initCore();

  // inject per features -----------
  _initProduct();
  _initDelivering();
  _initOrder();
  _initMediaService();
  _initDashboard();
  _initFutureStockPrediction();
  _initUser();
  _initAuth();
  // [INIT_ANCHOR]

  _initMap();
}

// supabase_client, internet connection, network -------------
Future<void> _initCore() async {
  final accessTokenMapBox =
      MapboxGeocodeService(
        accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? "",
      ).accessToken;
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => accessTokenMapBox);
  sl.registerLazySingleton(() => Supabase.instance.client);
  sl.registerLazySingleton(() => InternetConnection());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton(() => StorageService(sl<SharedPreferences>()));
}

Future<void> _initProduct() async {
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<ProductDataSource>(
    () => ProductDataSourceImpl(sl()),
  );
  sl.registerLazySingleton(() => ProductUsecases(sl(), sl()));
}

Future<void> _initDashboard() async {
  sl.registerLazySingleton<DashboardStatsRepository>(
    () => DashboardStatsRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<DashboardStatsDataSource>(
    () => DashboardStatsDataSourceImpl(sl()),
  );
  sl.registerLazySingleton(() => DashboardStatsUsecase(sl()));
}

Future<void> _initOrder() async {
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<OrderDataSource>(() => OrderDataSourceImpl(sl()));
  sl.registerLazySingleton(() => OrderUsecases(sl(), sl()));
}

// media services -------
Future<void> _initMediaService() async {
  sl.registerLazySingleton(() => ImagePicker());
  sl.registerLazySingleton<MediaServices>(
    () => MediaServiceImpl(sl(), sl(), sl()),
  );
}

Future<void> _initDelivering() async {
  sl.registerLazySingleton<DeliveringRemoteSource>(
    () => DeliveringRemoteSourceImpl((sl())),
  );
  sl.registerLazySingleton<DeliveringRepository>(
    () => DeliveringRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton(() => DeliveringUsecases(sl()));
}

Future<void> _initFutureStockPrediction() async {
  sl.registerLazySingleton(() => StockPredictionUsecases(sl(), sl()));
}

// map feature- ------------
// Exemple pour Map
Future<void> _initMap() async {
  sl.registerLazySingleton<MapRepository>(
    () => MapRepositoryImpl(sl<MapRemoteDataSource>(), sl<NetworkInfo>()),
  );
  sl.registerLazySingleton<MapRemoteDataSource>(
    () => MapRemoteDataSourceImpl(
      client: sl<http.Client>(),
      accessToken: sl<String>(),
    ),
  );
  sl.registerLazySingleton(() => MapUsecases(sl<MapRepository>()));
}

Future<void> _initUser() async {
  sl.registerLazySingleton<UserRemoteSource>(() => UserRemoteSourceImpl(sl()));
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton(() => UserUsecases(sl()));
}

Future<void> _initAuth() async {
  sl.registerLazySingleton(() => SocialAuthService(sl()));
  sl.registerLazySingleton(() => EmailAuthService(sl()));

  sl.registerLazySingleton<AuthRemoteSource>(
    () => AuthRemoteSourceImpl(sl(), sl(), sl()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton(() => AuthUsecases(sl()));
}
