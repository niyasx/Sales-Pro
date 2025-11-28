import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_brand.dart';
import '../../domain/entities/product_category.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoading extends ProductState {
  const ProductLoading();
}

class ProductsLoaded extends ProductState {
  final List<Product> products;
  final List<ProductBrand> brands;
  final List<ProductCategory> categories;

  const ProductsLoaded({
    required this.products,
    required this.brands,
    required this.categories,
  });

  @override
  List<Object> get props => [products, brands, categories];

  ProductsLoaded copyWith({
    List<Product>? products,
    List<ProductBrand>? brands,
    List<ProductCategory>? categories,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      brands: brands ?? this.brands,
      categories: categories ?? this.categories,
    );
  }
}

class ProductOperationSuccess extends ProductState {
  final String message;

  const ProductOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object> get props => [message];
}