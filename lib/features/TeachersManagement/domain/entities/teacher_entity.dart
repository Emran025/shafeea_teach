// import 'package:flutter/material.dart';

import 'base_teacher_entity.dart';

import 'package:flutter/material.dart';

/// Represents the full, detailed profile of a single teacher.
///
/// This entity includes all available information for a teacher, used when
/// viewing a specific teacher's profile. It inherits core properties and
/// adds detailed fields.

@immutable
class TeacherDetailEntity extends BaseTeacherEntity {
  final String birthDate;
  final String email;
  final String phone;
  final int phoneZone;
  final String whatsAppPhone;
  final int whatsAppZone;
  final String qualification;
  final int experienceYears;

  final String residence;
  final TimeOfDay availableTime;
  final String stopReasons;
  final String bio;
  final String createdAt;
  final String updatedAt;
  final List<dynamic> halqas;

  /// The login username for this teacher.
  ///
  /// When creating a new teacher **without** an internet connection, this is
  /// `null` — the server will auto-assign a username.  When the device is
  /// online the form shows the field so the user can accept the server
  /// suggestion or type a custom value before submission.
  final String? username;

  const TeacherDetailEntity({
    required super.id,
    required super.name,
    required super.avatar,
    required super.status,
    required super.gender,
    required this.birthDate,
    required this.email,
    required this.phone,
    required this.phoneZone,
    required this.whatsAppPhone,
    required this.whatsAppZone,
    required this.qualification,
    required this.experienceYears,
    required super.country,
    required this.residence,
    required super.city,
    required this.availableTime,
    required this.stopReasons,
    required this.bio,
    required this.createdAt,
    required this.updatedAt,
    this.halqas = const [],
    this.username,
  });

  @override
  List<Object?> get props => [...super.props, email, phone, username];
}

