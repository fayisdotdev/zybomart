import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zybomart/blocs/wishlist/wishlist_state.dart';
import 'package:zybomart/repositories/wishlist_repository.dart';

part 'wishlist_event.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistRepository wishlistRepository;
  final FlutterSecureStorage storage;

  // Keep track of all wishlisted IDs
  final Set<int> _wishlistIds = {};

  WishlistBloc({required this.wishlistRepository, required this.storage})
    : super(WishlistInitial()) {
    on<FetchWishlist>((event, emit) async {
      emit(WishlistLoading());
      try {
        final token = await storage.read(key: 'jwt_token');
        if (token == null || token.isEmpty) {
          emit(WishlistError("No token found. Please login again."));
          return;
        }
        final ids = await wishlistRepository.fetchWishlist(token: token);
        _wishlistIds
          ..clear()
          ..addAll(ids);
        emit(WishlistLoaded(wishlistIds: Set.from(_wishlistIds)));
      } catch (e) {
        emit(WishlistError(e.toString()));
      }
    });

    on<ToggleWishlist>((event, emit) async {
      // Update local state instantly for UI responsiveness
      if (_wishlistIds.contains(event.productId)) {
        _wishlistIds.remove(event.productId);
      } else {
        _wishlistIds.add(event.productId);
      }
      emit(WishlistLoaded(wishlistIds: Set.from(_wishlistIds)));

      // Sync with backend
      try {
        final token = await storage.read(key: 'jwt_token');
        if (token == null || token.isEmpty) {
          emit(WishlistError("No token found. Please login again."));
          return;
        }
        await wishlistRepository.toggleWishlist(
          productId: event.productId,
          token: token,
        );
        // After toggling, fetch the updated wishlist from API
        final ids = await wishlistRepository.fetchWishlist(token: token);
        _wishlistIds
          ..clear()
          ..addAll(ids);
        emit(WishlistLoaded(wishlistIds: Set.from(_wishlistIds)));
      } catch (e) {
        emit(WishlistError(e.toString()));
      }
    });
  }
}
