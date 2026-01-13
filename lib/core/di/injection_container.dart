import 'package:e_tantana/core/network/network_info.dart';
import 'package:e_tantana/features/product/data/dataSource/product_data_source.dart';
import 'package:e_tantana/features/product/data/dataSource/product_data_source_impl.dart';
import 'package:e_tantana/features/product/data/repository/product_repository_impl.dart';
import 'package:e_tantana/features/product/domain/repository/product_repository.dart';
import 'package:e_tantana/features/product/domain/usecases/product_usecases.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // supabase client & internet connection ------
  await _initCore();

  // inject per features -----------
  _initProduct();
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
  sl.registerLazySingleton(() => ProductUsecases(sl()));
}
