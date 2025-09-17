import 'package:equatable/equatable.dart';
import 'package:zybomart/data/models/product_model.dart';


abstract class WishlistState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<ProductModel> items;
  WishlistLoaded(this.items);
  @override
  List<Object?> get props => [items];
}

class WishlistError extends WishlistState {
  final String message;
  WishlistError(this.message);
  @override
  List<Object?> get props => [message];
}
