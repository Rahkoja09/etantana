import 'package:flutter_dotenv/flutter_dotenv.dart';

class ClientConst {
  static final String iosClientID = dotenv.env['IOS_CLIENT_ID']!;
  static final String webClientID = dotenv.env['WEB_CLIENT_ID']!;
}
