import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    required this.refreshToken,
  });

  final int id;
  final String name;
  final String email;
  final String token;
  final String refreshToken;

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? token,
    String? refreshToken,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  @override
  List<Object?> get props => <Object?>[id, name, email, token, refreshToken];
}
