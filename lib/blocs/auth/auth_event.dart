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
  final String? firstName;
  VerifyOtp({required this.phone, this.firstName});
  @override
  List<Object?> get props => [phone, firstName ?? ''];
}

class Logout extends AuthEvent {}
