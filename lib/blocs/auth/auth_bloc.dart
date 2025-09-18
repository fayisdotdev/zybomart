import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zybomart/blocs/auth/auth_event.dart';
import 'package:zybomart/blocs/auth/auth_state.dart';
import 'package:zybomart/repositories/auth_repositories.dart';
import 'package:flutter/material.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    // Step 1: Request OTP
    on<RequestOtp>((event, emit) async {
      emit(AuthLoading());
      try {
        final result = await authRepository.isUserExists(event.phone);
        final exists = result['userExists'] as bool;
        final otp = result['otp'] as String;
        emit(OtpSent(phone: event.phone, userExists: exists, otp: otp));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    // Step 2: Verify OTP
on<VerifyOtp>((event, emit) async {
  emit(AuthLoading());
  try {
    debugPrint('=== VerifyOtp pressed ===');

    // 1️⃣ Login/Register
    final result = await authRepository.loginOrRegister(
      event.phone,
      firstName: event.firstName,
    );
    debugPrint('Login/Register response: $result');

    final token = result['token'] as String?;
    final userName = result['name']?.toString().isNotEmpty == true
        ? result['name']
        : (event.firstName ?? 'User');
    final phone = result['phone'] ?? event.phone;

    if (token == null || token.isEmpty) {
      throw Exception('Token is null or empty');
    }

    debugPrint('Final token: $token, userName: $userName, phone: $phone');

    emit(Authenticated(token: token, name: userName, phone: phone));
  } catch (e, st) {
    debugPrint('Error in VerifyOtp: $e');
    debugPrint('StackTrace: $st');
    emit(AuthError(e.toString()));
  }
});


    // Step 3: Logout
    on<Logout>((event, emit) async {
      await authRepository.logout();
      emit(AuthInitial());
    });
  }
}
