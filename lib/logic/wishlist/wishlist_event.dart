import 'package:equatable/equatable.dart';

abstract class WishlistEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class WishlistFetchRequested extends WishlistEvent {}

class WishlistToggleRequested extends WishlistEvent {
  final int productId;
  WishlistToggleRequested(this.productId);
  @override
  List<Object?> get props => [productId];
}
