import 'package:equatable/equatable.dart';

class VerificationResult extends Equatable {
  const VerificationResult({
    required this.uniqueId,
    required this.message,
  });

  final String uniqueId;
  final String message;

  @override
  List<Object?> get props => <Object?>[uniqueId, message];
}
