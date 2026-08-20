import 'package:flutter/cupertino.dart';
import 'package:frontend/core/enums/site_status.dart';

@immutable
class SiteModel {
  final String id;
  final String name;
  final String code;
  final String address;
  final String city;
  final String state;
  final SiteStatus status;
  final DateTime updatedAt;

  const SiteModel({
    required this.id,
    required this.name,
    required this.code,
    required this.address,
    required this.city,
    required this.state,
    required this.status,
    required this.updatedAt,
  });

  factory SiteModel.fromJson(Map<String, dynamic> json) {
    return SiteModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      address: json['address'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      status: SiteStatus.fromString(json['status'] as String?),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'address': address,
      'city': city,
      'state': state,
      'status': status.toJson(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  SiteModel copyWith({
    String? id,
    String? name,
    String? code,
    String? address,
    String? city,
    String? state,
    SiteStatus? status,
    DateTime? updatedAt,
  }) {
    return SiteModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
