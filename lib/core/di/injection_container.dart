import 'package:e_tantana/core/network/network_info.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // supabase client & internet connection ------
  await _initCore();

  // inject per features -----------
}

// supabase_client, internet connection, network -------------
Future<void> _initCore() async {
  sl.registerLazySingleton(() => Supabase.instance.client);
  sl.registerLazySingleton(() => InternetConnection());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
}
