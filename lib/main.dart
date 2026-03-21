import 'dart:convert';
import 'package:device_preview/device_preview.dart';
import 'package:e_tantana/config/constants/app_const.dart';
import 'package:e_tantana/config/constants/mapBox_const.dart';
import 'package:e_tantana/config/constants/supabase_api_constants.dart';
import 'package:e_tantana/config/theme/theme_provider.dart';
import 'package:e_tantana/core/di/injection_container.dart' as di;
import 'package:e_tantana/core/router/app_router.dart';
import 'package:e_tantana/core/services/storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:json_theme/json_theme.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart'
    show MapboxOptions;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // charger shared_preferences ----------------
  final prefs = await SharedPreferences.getInstance();

  // Charger themes dark and light ------------
  final lightStr = await rootBundle.loadString("assets/theme/light_theme.json");
  final darkStr = await rootBundle.loadString("assets/theme/dark_theme.json");

  final lightJson = jsonDecode(lightStr);
  final darkJson = jsonDecode(darkStr);

  await dotenv.load(fileName: ".env");

  lightTheme = ThemeDecoder.decodeThemeData(lightJson)!;
  darkTheme = ThemeDecoder.decodeThemeData(darkJson)!;

  await Supabase.initialize(
    url: SupabaseApiConstants.apiUrl,
    anonKey: SupabaseApiConstants.apiKey,
    authOptions: const FlutterAuthClientOptions(
      autoRefreshToken: true,
      detectSessionInUri: true,
    ),
  );
  MapboxOptions.setAccessToken(MapboxConst.mapxBoxAccessToken);

  await di.init();

  runApp(
    ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(StorageService(prefs)),
      ],
      child: DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => MyApp(),
      ),
    ),
  );

  //runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final router = ref.watch(appRouterProvider);
    return ScreenUtilInit(
      designSize: const Size(390, 844), // iphone 13 ----
      minTextAdapt: true,
      builder: (context, child) {
        return ToastificationWrapper(
          child: MaterialApp.router(
            routerConfig: router,
            theme: theme,
            debugShowCheckedModeBanner: false,
            title: AppConst.appName,
          ),
        );
      },
    );
  }
}
