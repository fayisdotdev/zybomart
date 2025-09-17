import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class OtpSent extends AuthState {
  final String phone;
  final bool userExists; // true if user exists, false → show register
  OtpSent({required this.phone, required this.userExists});
  @override
  List<Object?> get props => [phone, userExists];
}

class Authenticated extends AuthState {
  final String token;
  Authenticated(this.token);
  @override
  List<Object?> get props => [token];
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
  @override
  List<Object?> get props => [message];
}
