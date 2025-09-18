import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class OtpSent extends AuthState {
  final String phone;
  final bool userExists;
  final String otp;

  OtpSent({
    required this.phone,
    required this.userExists,
    required this.otp,
  });

  @override
  List<Object?> get props => [phone, userExists, otp];
}

class Authenticated extends AuthState {
  final String token;
  final String phone;
  final String name;

  Authenticated({
    required this.token,
    required this.phone,
    required this.name,
  });

  @override
  List<Object?> get props => [token, phone, name];
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
