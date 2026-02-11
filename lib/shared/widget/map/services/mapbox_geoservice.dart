import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final service = MapboxGeocodeService(
  accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? "",
);

class MapboxGeocodeService {
  final String accessToken;

  MapboxGeocodeService({required this.accessToken});

  Future<GeocodeResult?> searchLocation(String query) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);

      final url =
          'https://api.mapbox.com/search/geocode/v6/forward'
          '?q=$encodedQuery'
          '&access_token=${service.accessToken}'
          '&limit=1'
          '&country=mg';

      print('🔍 Recherche v6: $query');

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        final List features = json['features'] ?? [];

        if (features.isEmpty) {
          return null;
        }

        final feature = features[0];

        final geometry = feature['geometry'];
        final coordinates = geometry['coordinates'] as List;

        final properties = feature['properties'];
        final placeName =
            properties['full_address'] ?? properties['name'] ?? "Lieu inconnu";

        return GeocodeResult(
          longitude: (coordinates[0] as num).toDouble(),
          latitude: (coordinates[1] as num).toDouble(),
          placeName: placeName,
        );
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

class GeocodeResult {
  final double longitude;
  final double latitude;
  final String placeName;

  GeocodeResult({
    required this.longitude,
    required this.latitude,
    required this.placeName,
  });
}
