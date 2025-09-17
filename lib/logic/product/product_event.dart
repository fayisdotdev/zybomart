import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductFetchRequested extends ProductEvent {}

class ProductSearchRequested extends ProductEvent {
  final String query;
  ProductSearchRequested(this.query);
  @override
  List<Object?> get props => [query];
}
