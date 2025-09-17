import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zybomart/repositories/auth_repositories.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    // Step 1: Request OTP
    on<RequestOtp>((event, emit) async {
      emit(AuthLoading());
      debugPrint('AuthBloc: RequestOtp event for ${event.phone}');
      try {
        // Call API
        final verifyResult = await authRepository.isUserExists(event.phone);

        final exists = verifyResult['exists']; // whether user exists
        final otp = verifyResult['otp'] ?? '1234'; // mock fallback

        debugPrint('AuthBloc: User exists? $exists');
        debugPrint('AuthBloc: OTP is $otp');

        emit(OtpSent(
          phone: event.phone,
          userExists: exists,
          otp: otp,
        ));
      } catch (e) {
        debugPrint('AuthBloc: Error - $e');
        emit(AuthError(e.toString()));
      }
    });

    // Step 2: Verify OTP (mock check)
    on<VerifyOtp>((event, emit) async {
      emit(AuthLoading());
      try {
        // ✅ Check OTP entered
        if (event.otp != "1234") {
          emit(AuthError("Invalid OTP. Please enter 1234."));
          return;
        }

        // ✅ Proceed with login/register
        final token = await authRepository.loginOrRegister(
          event.phone,
          firstName: event.firstName, // only for new users
        );

        // ✅ Fetch profile to get actual name
        final profile = await authRepository.fetchProfile(token);
        final userName = profile['first_name'] ?? event.firstName ?? "User";

        emit(
          Authenticated(token: token, userName: userName, phone: event.phone),
        );
      } catch (e) {
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
