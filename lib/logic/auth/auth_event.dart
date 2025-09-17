import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoggedOut extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String phone;
  final String? firstName;
  AuthLoginRequested({required this.phone, this.firstName});
}
