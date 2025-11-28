import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_brand.dart';
import '../../domain/entities/product_category.dart';
import '../../domain/usecases/create_product.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/get_product_brands.dart';
import '../../domain/usecases/get_product_categories.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/update_product.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts getProducts;
  final CreateProduct createProduct;
  final UpdateProduct updateProduct;
  final DeleteProduct deleteProduct;
  final GetProductBrands getProductBrands;
  final GetProductCategories getProductCategories;

  List<Product> _products = [];
  List<ProductBrand> _brands = [];
  List<ProductCategory> _categories = [];

  ProductBloc({
    required this.getProducts,
    required this.createProduct,
    required this.updateProduct,
    required this.deleteProduct,
    required this.getProductBrands,
    required this.getProductCategories,
  }) : super(const ProductInitial()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<LoadProductBrandsEvent>(_onLoadProductBrands);
    on<LoadProductCategoriesEvent>(_onLoadProductCategories);
    on<CreateProductEvent>(_onCreateProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    debugPrint('🎯 LoadProductsEvent triggered');
    emit(const ProductLoading());

    final result = await getProducts(const NoParams());

    emit(
      result.fold(
        (failure) {
          debugPrint('❌ Failed to load products: ${failure.message}');
          return ProductError(failure.message);
        },
        (products) {
          debugPrint('✅ Products loaded successfully: ${products.length}');
          _products = products;
          return ProductsLoaded(
            products: _products,
            brands: _brands,
            categories: _categories,
          );
        },
      ),
    );
  }

  Future<void> _onLoadProductBrands(
    LoadProductBrandsEvent event,
    Emitter<ProductState> emit,
  ) async {
    debugPrint('🎯 LoadProductBrandsEvent triggered');
    
    final result = await getProductBrands(const NoParams());

    result.fold(
      (failure) {
        debugPrint('❌ Failed to load brands: ${failure.message}');
        emit(ProductError(failure.message));
      },
      (brands) {
        debugPrint('✅ Brands loaded successfully: ${brands.length}');
        _brands = brands;
        if (state is ProductsLoaded) {
          emit((state as ProductsLoaded).copyWith(brands: _brands));
        }
      },
    );
  }

  Future<void> _onLoadProductCategories(
    LoadProductCategoriesEvent event,
    Emitter<ProductState> emit,
  ) async {
    debugPrint('🎯 LoadProductCategoriesEvent triggered');
    
    final result = await getProductCategories(const NoParams());

    result.fold(
      (failure) {
        debugPrint('❌ Failed to load categories: ${failure.message}');
        emit(ProductError(failure.message));
      },
      (categories) {
        debugPrint('✅ Categories loaded successfully: ${categories.length}');
        _categories = categories;
        if (state is ProductsLoaded) {
          emit((state as ProductsLoaded).copyWith(categories: _categories));
        }
      },
    );
  }

  Future<void> _onCreateProduct(
    CreateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    debugPrint('🎯 CreateProductEvent triggered');
    emit(const ProductLoading());

    final result = await createProduct(event.product, event.imageFile);

    await result.fold(
      (failure) async {
        debugPrint('❌ Failed to create product: ${failure.message}');
        emit(ProductError(failure.message));
      },
      (_) async {
        debugPrint('✅ Product created successfully');
        emit(const ProductOperationSuccess('Product created successfully'));
        add(const LoadProductsEvent());
      },
    );
  }

  Future<void> _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    debugPrint('🎯 UpdateProductEvent triggered');
    emit(const ProductLoading());

    final result = await updateProduct(event.product, event.imageFile);

    await result.fold(
      (failure) async {
        debugPrint('❌ Failed to update product: ${failure.message}');
        emit(ProductError(failure.message));
      },
      (_) async {
        debugPrint('✅ Product updated successfully');
        emit(const ProductOperationSuccess('Product updated successfully'));
        add(const LoadProductsEvent());
      },
    );
  }

  Future<void> _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    debugPrint('🎯 DeleteProductEvent triggered');
    emit(const ProductLoading());

    final result = await deleteProduct(event.productId);

    await result.fold(
      (failure) async {
        debugPrint('❌ Failed to delete product: ${failure.message}');
        emit(ProductError(failure.message));
      },
      (_) async {
        debugPrint('✅ Product deleted successfully');
        emit(const ProductOperationSuccess('Product deleted successfully'));
        add(const LoadProductsEvent());
      },
    );
  }
}