import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    required this.refreshToken,
    this.mobileNumber = '',
    this.gender = 'MALE',
    this.preferredLanguage = 'en',
    this.mobileNumberVerified = 'N',
    this.emailVerified = 'N',
    this.userProfileId = '',
  });

  final int id;
  final String name;
  final String email;
  final String token;
  final String refreshToken;
  final String mobileNumber;
  final String gender;
  final String preferredLanguage;
  final String mobileNumberVerified;
  final String emailVerified;
  final String userProfileId;

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? token,
    String? refreshToken,
    String? mobileNumber,
    String? gender,
    String? preferredLanguage,
    String? mobileNumberVerified,
    String? emailVerified,
    String? userProfileId,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      gender: gender ?? this.gender,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      mobileNumberVerified: mobileNumberVerified ?? this.mobileNumberVerified,
      emailVerified: emailVerified ?? this.emailVerified,
      userProfileId: userProfileId ?? this.userProfileId,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        id,
        name,
        email,
        token,
        refreshToken,
        mobileNumber,
        gender,
        preferredLanguage,
        mobileNumberVerified,
        emailVerified,
        userProfileId,
      ];
}
