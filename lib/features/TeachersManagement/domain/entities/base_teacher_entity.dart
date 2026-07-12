// import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';
import 'package:shafeea/core/models/active_status.dart';

import '../../../../core/models/gender.dart';

/// The base abstract entity for a Teacher.
///
/// It contains the core properties shared between the list view and the
/// detailed view. Using [Equatable] for value-based equality.
///
/// [maxHalaqas] — maximum number of circles the teacher can be assigned to.
/// [currentHalaqas] — how many circles the teacher currently runs.
/// Together they are used to filter teachers with remaining capacity when
/// assigning a new halaqa.
import 'package:flutter/material.dart';

@immutable
abstract class BaseTeacherEntity extends Equatable {
  final String id;
  final String name;
  final Gender gender;
  final String country;
  final String city;
  final String avatar;
  final ActiveStatus status;

  /// Maximum circles this teacher can handle. Defaults to 0 (no limit set).
  final int maxHalaqas;

  /// Current number of circles assigned to this teacher.
  final int currentHalaqas;

  /// Whether this teacher still has capacity for at least one more halaqa.
  bool get hasCapacity =>
      maxHalaqas <= 0 || currentHalaqas < maxHalaqas;

  const BaseTeacherEntity({
    required this.id,
    required this.name,
    required this.gender,
    required this.country,
    required this.city,
    required this.avatar,
    required this.status,
    this.maxHalaqas = 0,
    this.currentHalaqas = 0,
  });

  @override
  List<Object?> get props => [id, name, avatar, status, maxHalaqas, currentHalaqas];
}
