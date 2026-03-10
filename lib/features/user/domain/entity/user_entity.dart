import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final DateTime? createdAt;
    final String? name;
  final String? profilLink;
  final String? email;
  final int? sixDigitCode;
  // [FIELDS_ANCHOR]

  const UserEntity({
    this.id,
    this.createdAt,
        this.name,
    this.profilLink,
    this.email,
    this.sixDigitCode,
    // [CONSTRUCTOR_ANCHOR]
  });

  UserEntity copyWith({
    String? id,
    DateTime? createdAt,
        String? name,
    String? profilLink,
    String? email,
    int? sixDigitCode,
    // [COPYWITH_PARAMS_ANCHOR]
  }) {
    return UserEntity(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
            name: name ?? this.name,
      profilLink: profilLink ?? this.profilLink,
      email: email ?? this.email,
      sixDigitCode: sixDigitCode ?? this.sixDigitCode,
      // [COPYWITH_RETURN_ANCHOR]
    );
  }

  @override
  List<Object?> get props => [
    id, 
    createdAt,
        name,
    profilLink,
    email,
    sixDigitCode,
    // [PROPS_ANCHOR]
  ];
}