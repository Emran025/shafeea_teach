import '../../../../core/models/user_role.dart';
import '../../domain/entities/user_entity.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? avatar;
  final UserRole role;
  final bool isEmailVerified;
  final String genderScope;
  final List<String> roles;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.avatar,
    this.isEmailVerified = false,
    this.genderScope = 'all',
    this.roles = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json, UserRole role) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      avatar: json['avatar'],
      role: role,
      isEmailVerified: json['is_email_verified'] ?? false,
      genderScope: json['gender_scope'] ?? 'all',
      roles: json['roles'] != null ? List<String>.from(json['roles']) : [],
    );
  }

  /// Factory constructor لإنشاء نسخة UserModel من Map قادم من قاعدة البيانات المحلية
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? 'Unknown',
      email: map['email'] ?? '',
      avatar: map['avatar'],
      phone: map['phone'] ?? '',
      role: UserRole.fromId(map['roleId'] ?? 0),
      isEmailVerified: (map['is_email_verified'] ?? 0) == 1,
      genderScope: map['gender_scope'] ?? 'all',
      roles: map['roles'] != null ? map['roles'].toString().split(',') : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'is_email_verified': isEmailVerified,
      'gender_scope': genderScope,
      'roles': roles,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'roleId': role.id,
      'is_email_verified': isEmailVerified ? 1 : 0,
      'gender_scope': genderScope,
      'roles': roles.join(','),
    };
  }

  UserEntity toUserEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      phone: phone,
      avatar: avatar,
      role: role,
      isEmailVerified: isEmailVerified,
      genderScope: genderScope,
      roles: roles,
    );
  }
}
