import 'package:equatable/equatable.dart';

class RegisterUserRequest extends Equatable {
  const RegisterUserRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    required this.preferredLanguage,
    required this.gender,
  });

  final String username;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String mobileNumber;
  final String preferredLanguage;
  final String gender;

  @override
  List<Object?> get props {
    return <Object?>[
      username,
      email,
      password,
      firstName,
      lastName,
      mobileNumber,
      preferredLanguage,
      gender,
    ];
  }
}
