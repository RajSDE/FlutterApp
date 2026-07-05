import 'package:flutter_app/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.token,
    required super.refreshToken,
    super.mobileNumber = '',
    super.gender = 'MALE',
    super.preferredLanguage = 'en',
    super.mobileNumberVerified = 'N',
    super.emailVerified = 'N',
    super.userProfileId = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userProfileId = json['userProfileId'] as String? ?? '';
    final firstName = json['firstName'] as String? ?? '';
    final lastName = json['lastName'] as String? ?? '';
    final fullName = json['fullName'] as String? ??
        (firstName.isNotEmpty || lastName.isNotEmpty
            ? '$firstName $lastName'.trim()
            : '');

    return UserModel(
      id: json['id'] as int? ?? userProfileId.hashCode,
      name: json['name'] as String? ??
          json['username'] as String? ??
          (fullName.isNotEmpty ? fullName : 'User'),
      email: json['email'] as String? ?? '',
      token: json['token'] as String? ?? json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      mobileNumber: json['mobileNumber'] as String? ?? '',
      gender: json['gender'] as String? ?? 'MALE',
      preferredLanguage: json['preferredLanguage'] as String? ?? 'en',
      mobileNumberVerified: json['mobileNumberVerified'] as String? ?? 'N',
      emailVerified: json['emailVerified'] as String? ?? 'N',
      userProfileId: userProfileId,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'token': token,
      'refreshToken': refreshToken,
    };
  }
}
