import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zybomart/core/storage/token_storage.dart';
import 'package:zybomart/data/repositories/auth_repository.dart';
import 'package:zybomart/logic/auth/auth_event.dart';
import 'package:zybomart/logic/auth/auth_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onCheck);
    on<AuthLoginRequested>(_onLogin);
    on<AuthLoggedOut>(_onLogout);
  }

  Future<void> _onCheck(AuthCheckRequested e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final token = await TokenStorage.getToken();
    if (token != null && token.isNotEmpty) {
      emit(Authenticated(token));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLogin(AuthLoginRequested e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final token = await authRepository.loginRegister(e.phone, firstName: e.firstName);
      if (token != null) {
        emit(Authenticated(token));
      } else {
        emit(Unauthenticated("Failed to login"));
      }
    } catch (err) {
      emit(Unauthenticated(err.toString()));
    }
  }

  Future<void> _onLogout(AuthLoggedOut e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await authRepository.logout();
    emit(Unauthenticated());
  }
}
