import 'package:e_tantana/core/utils/typedef/typedefs.dart';
import 'package:e_tantana/features/map/domain/entity/map_entity.dart';

class MapModel extends MapEntity {
  MapModel({
    required super.id,
    required super.location,
    super.latitude,
    super.longitude,
    required super.status,
    required super.date,
    required super.price,
  });

  factory MapModel.fromMap(MapData map) {
    return MapModel(
      id: map['id'] as String,
      location: map['location'] as String,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      status: map['status'] as String,
      date: DateTime.parse(map['date'] as String),
      price: (map['price'] as num).toDouble(),
    );
  }

  factory MapModel.fromMapbox(
    MapData json,
    String originalLocation,
    double price,
  ) {
    final properties = json['properties'] as Map<String, dynamic>;
    final geometry = json['geometry'] as Map<String, dynamic>;
    final coordinates = geometry['coordinates'] as List<dynamic>;

    return MapModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      location:
          properties['full_address'] ?? properties['name'] ?? originalLocation,
      latitude: (coordinates[1] as num).toDouble(),
      longitude: (coordinates[0] as num).toDouble(),
      status: 'pending',
      date: DateTime.now(),
      price: price,
    );
  }

  MapData toMap() {
    return {
      'id': id,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'date': date.toIso8601String(),
      'price': price,
    };
  }

  factory MapModel.fromEntity(MapEntity entity) {
    return MapModel(
      id: entity.id,
      location: entity.location,
      latitude: entity.latitude,
      longitude: entity.longitude,
      status: entity.status,
      date: entity.date,
      price: entity.price,
    );
  }
}
