import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zybomart/data/repositories/banner_repository.dart';
import 'package:zybomart/logic/banner/banner_event.dart';
import 'package:zybomart/logic/banner/banner_state.dart';


class BannerBloc extends Bloc<BannerEvent, BannerState> {
  final BannerRepository bannerRepository;
  BannerBloc({required this.bannerRepository}) : super(BannerInitial()) {
    on<BannerFetchRequested>(_onFetch);
  }

  Future<void> _onFetch(BannerFetchRequested e, Emitter<BannerState> emit) async {
    emit(BannerLoading());
    try {
      final list = await bannerRepository.fetchBanners();
      emit(BannerLoaded(list));
    } catch (err) {
      emit(BannerError(err.toString()));
    }
  }
}
