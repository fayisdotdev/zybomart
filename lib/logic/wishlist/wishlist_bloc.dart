import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zybomart/data/repositories/wishlist_repository.dart';
import 'package:zybomart/logic/wishlist/wishlist_event.dart';
import 'package:zybomart/logic/wishlist/wishlist_state.dart';


class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistRepository wishlistRepository;
  WishlistBloc({required this.wishlistRepository}) : super(WishlistInitial()) {
    on<WishlistFetchRequested>(_onFetch);
    on<WishlistToggleRequested>(_onToggle);
  }

  Future<void> _onFetch(WishlistFetchRequested e, Emitter<WishlistState> emit) async {
    emit(WishlistLoading());
    try {
      final items = await wishlistRepository.fetchWishlist();
      emit(WishlistLoaded(items));
    } catch (err) {
      emit(WishlistError(err.toString()));
    }
  }

  Future<void> _onToggle(WishlistToggleRequested e, Emitter<WishlistState> emit) async {
    try {
      final ok = await wishlistRepository.addRemove(e.productId);
      if (ok) add(WishlistFetchRequested());
    } catch (err) {
      emit(WishlistError(err.toString()));
    }
  }
}
