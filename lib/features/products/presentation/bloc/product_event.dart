import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductsEvent extends ProductEvent {
  const LoadProductsEvent();
}

class LoadProductBrandsEvent extends ProductEvent {
  const LoadProductBrandsEvent();
}

class LoadProductCategoriesEvent extends ProductEvent {
  const LoadProductCategoriesEvent();
}

class CreateProductEvent extends ProductEvent {
  final Product product;
  final File? imageFile;

  const CreateProductEvent(this.product, this.imageFile);

  @override
  List<Object?> get props => [product, imageFile];
}

class UpdateProductEvent extends ProductEvent {
  final Product product;
  final File? imageFile;

  const UpdateProductEvent(this.product, this.imageFile);

  @override
  List<Object?> get props => [product, imageFile];
}

class DeleteProductEvent extends ProductEvent {
  final String productId;

  const DeleteProductEvent(this.productId);

  @override
  List<Object> get props => [productId];
}