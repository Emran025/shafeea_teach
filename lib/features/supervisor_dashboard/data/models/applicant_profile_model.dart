import 'package:shafeea/features/supervisor_dashboard/domain/entities/applicant_profile_entity.dart';
import '../../../TeachersManagement/data/models/document_model.dart';

class ApplicantProfileModel extends ApplicantProfileEntity {
  const ApplicantProfileModel({
    required super.id,
    required super.userId,
    required super.schoolId,
    required super.applicationType,
    required super.status,
    required super.bio,
    required super.qualifications,
    required super.rejectionReason,
    required super.submittedAt,
    required super.createdAt,
    required super.updatedAt,
    required super.user,
    super.documents,
  });

  factory ApplicantProfileModel.fromJson(Map<String, dynamic> json) {
    return ApplicantProfileModel(
      id: json['id'],
      userId: json['userId'],
      schoolId: json['schoolId'],
      applicationType: json['applicationType'],
      status: json['status'],
      bio: json['bio'],
      qualifications: json['qualifications'],
      rejectionReason: json['rejectionReason'],
      submittedAt: json['submittedAt'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      user: UserModel.fromJson(json['user']),
      documents: ((json['documents'] as List<dynamic>?) ?? [])
          .map((d) => DocumentModel.fromJson(d as Map<String, dynamic>).toEntity())
          .toList(),
    );
  }
}

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.emailVerifiedAt,
    required super.avatar,
    required super.phone,
    required super.phoneZone,
    required super.whatsapp,
    required super.whatsappZone,
    required super.gender,
    required super.birthDate,
    required super.country,
    required super.city,
    required super.residence,
    required super.status,
    required super.schoolId,
    required super.createdAt,
    required super.updatedAt,
    required super.deletedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['emailVerifiedAt'],
      avatar: json['avatar'],
      phone: json['phone'],
      phoneZone: json['phoneZone'],
      whatsapp: json['whatsapp'],
      whatsappZone: json['whatsappZone'],
      gender: json['gender'],
      birthDate: json['birthDate'],
      country: json['country'],
      city: json['city'],
      residence: json['residence'],
      status: json['status'],
      schoolId: json['schoolId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
    );
  }
}
