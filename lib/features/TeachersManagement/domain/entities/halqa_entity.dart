import 'package:flutter/foundation.dart';

@immutable
class AssignedHalaqasEntity {
  final String id;
  final String name;
  final String avatar;
  final int? students;
  final String enrolledAt;
  const AssignedHalaqasEntity({
    this.id = '0',
    this.name = 'النور',
    this.students,
    this.avatar = 'assets/images/logo2.png',
    this.enrolledAt = '2025-07-08 22:21:36',
  });
}
