import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zybomart/repositories/profile_repository.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Map<String, dynamic> profile;
  ProfileLoaded(this.profile);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

abstract class ProfileEvent {}

class FetchProfile extends ProfileEvent {}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;
  final FlutterSecureStorage storage;

  ProfileBloc({required this.profileRepository, required this.storage})
    : super(ProfileInitial()) {
    on<FetchProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final token = await storage.read(key: 'jwt_token');
        if (token == null || token.isEmpty) {
          emit(ProfileError('No token found. Please login again.'));
          return;
        }
        final profile = await profileRepository.fetchProfile(token: token);
        emit(ProfileLoaded(profile));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}
