import 'package:flutter_app/features/auth/domain/entities/register_user_request.dart';

class RegisterUserRequestModel extends RegisterUserRequest {
  const RegisterUserRequestModel({
    required super.username,
    required super.email,
    required super.password,
    required super.firstName,
    required super.lastName,
    required super.mobileNumber,
    required super.preferredLanguage,
    required super.gender,
  });

  factory RegisterUserRequestModel.fromEntity(RegisterUserRequest request) {
    return RegisterUserRequestModel(
      username: request.username,
      email: request.email,
      password: request.password,
      firstName: request.firstName,
      lastName: request.lastName,
      mobileNumber: request.mobileNumber,
      preferredLanguage: request.preferredLanguage,
      gender: request.gender,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'username': username,
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'mobileNumber': mobileNumber,
      'preferredLanguage': preferredLanguage,
      'gender': gender,
    };
  }
}
