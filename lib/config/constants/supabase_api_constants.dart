import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseApiConstants {
  static final String apiUrl = dotenv.env['SUPABASE_URL'] ?? "";
  static final String apiKey = dotenv.env['SUPABASE_ANON_KEY'] ?? "";
}
