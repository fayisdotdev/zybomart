abstract class WishlistState {}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

// New state that keeps track of all wishlisted product IDs
class WishlistLoaded extends WishlistState {
  final Set<int> wishlistIds;
  WishlistLoaded({required this.wishlistIds});
}

class WishlistError extends WishlistState {
  final String message;
  WishlistError(this.message);
}
