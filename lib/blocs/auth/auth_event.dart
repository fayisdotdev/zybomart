import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RequestOtp extends AuthEvent {
  final String phone;

  RequestOtp(this.phone);

  @override
  List<Object?> get props => [phone];
}

class VerifyOtp extends AuthEvent {
  final String phone;
  final String otp;

  VerifyOtp({required this.phone, required this.otp});

  @override
  List<Object?> get props => [phone, otp];
}

class LoginSuccess extends AuthEvent {}

class Logout extends AuthEvent {}
