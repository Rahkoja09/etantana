import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapboxConst {
  static final String mapxBoxAccessToken = dotenv.env['MAPBOX_ACCESS_TOKEN']!;
}
