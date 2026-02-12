import 'dart:convert';

import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/map/data/model/map_model.dart';

abstract class MapRemoteDataSource {
  Future<MapModel?> getCoordinatesFromAddress(String address);
}

class MapRemoteDataSourceImpl implements MapRemoteDataSource {
  final String accessToken;
  final dynamic client;

  MapRemoteDataSourceImpl({required this.client, required this.accessToken});

  @override
  Future<MapModel?> getCoordinatesFromAddress(String address) async {
    print("Entrée ici ============ <<<");
    try {
      final uri = Uri.https('api.mapbox.com', '/search/geocode/v6/forward', {
        'q': address,
        'access_token': accessToken,
        'limit': '1',
        'country': 'mg',
      });

      final response = await client.get(uri);
      print("response status code = ${response.statusCode}");

      if (response.statusCode == 200) {
        final dynamic decodedData = jsonDecode(response.body);
        final Map<String, dynamic> json = Map<String, dynamic>.from(
          decodedData,
        );

        final List features = json['features'] ?? [];
        if (features.isEmpty) return null;

        print('Feature trouvé: ${features[0]}');

        return MapModel.fromMapbox(features[0], address, 0.0);
      } else {
        throw Exception("Erreur Mapbox: ${response.statusCode}");
      }
    } catch (e) {
      print(' Erreur geocoding: $e');
      rethrow;
    }
  }
}
