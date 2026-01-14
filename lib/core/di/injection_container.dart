import 'package:e_tantana/core/network/network_info.dart';
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
import 'package:e_tantana/shared/media/media_services.dart';
import 'package:e_tantana/shared/media/media_services_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // supabase client & internet connection ------
  await _initCore();

  // inject per features -----------
  _initProduct();
  _initOrder();
  _initMediaService();
}

// supabase_client, internet connection, network -------------
Future<void> _initCore() async {
  sl.registerLazySingleton(() => Supabase.instance.client);
  sl.registerLazySingleton(() => InternetConnection());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
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
