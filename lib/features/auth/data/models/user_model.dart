import '../../../../core/models/user_role.dart';
import '../../domain/entities/user_entity.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? avatar;
  final UserRole role;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, UserRole role) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      avatar: json['avatar'],
      role: role,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
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
    );
  }
}
