part of 'wishlist_bloc.dart';

abstract class WishlistEvent {}

class FetchWishlist extends WishlistEvent {}

class ToggleWishlist extends WishlistEvent {
  final int productId;
  ToggleWishlist(this.productId);
}
