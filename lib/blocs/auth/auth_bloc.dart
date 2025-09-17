import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zybomart/repositories/auth_repositories.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<RequestOtp>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.requestOtp(event.phone);
        emit(OtpSent(event.phone));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<VerifyOtp>((event, emit) async {
      emit(AuthLoading());
      try {
        final token = await authRepository.verifyOtp(event.phone, event.otp);
        emit(Authenticated(token));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<LoginSuccess>((event, emit) {
      // Temporary mock token
      emit(Authenticated("mock_jwt_token"));
    });

    on<Logout>((event, emit) async {
      await authRepository.logout();
      emit(Unauthenticated());
    });
  }
}
