import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product.dart';
import '../entities/product_brand.dart';
import '../entities/product_category.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, Product>> getProductById(String id);
  Future<Either<Failure, void>> createProduct(Product product, File? imageFile);
  Future<Either<Failure, void>> updateProduct(Product product, File? imageFile);
  Future<Either<Failure, void>> deleteProduct(String id);
  Future<Either<Failure, List<ProductBrand>>> getProductBrands();
  Future<Either<Failure, List<ProductCategory>>> getProductCategories();
}