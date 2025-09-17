import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zybomart/repositories/auth_repositories.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<RequestOtp>((event, emit) async {
      emit(AuthLoading());
      debugPrint('AuthBloc: RequestOtp event for ${event.phone}');
      try {
        final exists = await authRepository.isUserExists(event.phone);
        debugPrint('AuthBloc: User exists? $exists');
        emit(OtpSent(phone: event.phone, userExists: exists));
      } catch (e) {
        debugPrint('AuthBloc: Error - $e');
        emit(AuthError(e.toString()));
      }
    });

    on<VerifyOtp>((event, emit) async {
      emit(AuthLoading());
      try {
        final token = await authRepository.loginOrRegister(
          event.phone,
          firstName: event.firstName,
        );
        emit(Authenticated(token));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<Logout>((event, emit) async {
      await authRepository.logout();
      emit(AuthInitial());
    });
  }
}
