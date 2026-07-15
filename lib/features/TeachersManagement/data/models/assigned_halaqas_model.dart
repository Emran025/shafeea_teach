import 'package:flutter/material.dart';

import '../../../TeachersManagement/domain/entities/halqa_entity.dart';

@immutable
final class AssignedHalaqasModel {
  final String id;
  final String name;
  final String? avatar;
  final int? students;
  final String? enrolledAt;

  const AssignedHalaqasModel({
    required this.id,
    required this.name,
    this.avatar,
    this.students,
    this.enrolledAt,
  });

  factory AssignedHalaqasModel.fromJson(Map<String, dynamic> json) {
    return AssignedHalaqasModel(
      id: (json['id'] as int).toString(),
      name: json['name'] as String? ?? 'Unnamed Halqa',
      avatar: json['avatar'] as String?,
      enrolledAt: json['enrolledAt'] as String?,
    );
  }

  factory AssignedHalaqasModel.fromMap(Map<String, dynamic> json) {
    return AssignedHalaqasModel(
      id: (json['id'] as int).toString(),
      name: json['name'] as String? ?? 'Unnamed Halqa',
      avatar: json['avatar'] as String?,
      students: json['students'] as int? ?? 0,
      enrolledAt: json['enrolledAt'] as String?,
    );
  }

  AssignedHalaqasEntity toEntity() {
    return AssignedHalaqasEntity(
      id: id,
      name: name,
      avatar: avatar ?? '',
      enrolledAt: enrolledAt ?? "2025-07-08 22:21:36",
    );
  }
}
