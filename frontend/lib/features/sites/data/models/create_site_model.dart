import 'package:flutter/cupertino.dart';
import 'package:frontend/core/enums/site_status.dart';

@immutable
class CreateSiteModel {
  final String name;
  final String code;
  final String? description;
  final String address;
  final String city;
  final String state;
  final String country;
  final double? latitude;
  final double? longitude;
  final SiteStatus status;

  const CreateSiteModel({
    required this.name,
    required this.code,
    this.description,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    this.latitude,
    this.longitude,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'description': description,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'status': status.toJson(),
    };
  }

  CreateSiteModel copyWith(
    String? name,
    String? code,
    String? description,
    String? address,
    String? city,
    String? state,
    String? country,
    double? latitude,
    double? longitude,
    SiteStatus? status,
  ) {
    return CreateSiteModel(
      name: name ?? this.name,
      code: code ?? this.code,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      status: status ?? this.status,
    );
  }
}
