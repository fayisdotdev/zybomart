import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zybomart/data/repositories/product_repository.dart';
import 'package:zybomart/logic/product/product_event.dart';
import 'package:zybomart/logic/product/product_state.dart';


class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc({required this.productRepository}) : super(ProductInitial()) {
    on<ProductFetchRequested>(_onFetch);
    on<ProductSearchRequested>(_onSearch);
  }

  Future<void> _onFetch(ProductFetchRequested e, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final items = await productRepository.fetchProducts();
      emit(ProductLoaded(items));
    } catch (err) {
      emit(ProductError(err.toString()));
    }
  }

  Future<void> _onSearch(ProductSearchRequested e, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final items = await productRepository.search(e.query);
      emit(ProductLoaded(items));
    } catch (err) {
      emit(ProductError(err.toString()));
    }
  }
}
