import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/product_model.dart';
import '../models/product_brand_model.dart';
import '../models/product_category_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(String id);
  Future<void> createProduct(ProductModel product, File? imageFile);
  Future<void> updateProduct(ProductModel product, File? imageFile);
  Future<void> deleteProduct(String id);
  Future<List<ProductBrandModel>> getProductBrands();
  Future<List<ProductCategoryModel>> getProductCategories();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final FirebaseFirestore firestore;

  ProductRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      debugPrint('🔍 Fetching products from Firestore...');
      
      final snapshot = await firestore
          .collection('products')
          .orderBy('createdAt', descending: true)
          .get();

      debugPrint('📦 Products snapshot received. Documents: ${snapshot.docs.length}');

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return ProductModel.fromJson(data);
      }).toList();
    } catch (e) {
      debugPrint('❌ Error fetching products: $e');
      throw ServerException('Failed to fetch products: ${e.toString()}');
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    try {
      final doc = await firestore.collection('products').doc(id).get();

      if (!doc.exists) {
        throw ServerException('Product not found');
      }

      final data = doc.data()!;
      data['id'] = doc.id;
      return ProductModel.fromJson(data);
    } catch (e) {
      throw ServerException('Failed to fetch product: ${e.toString()}');
    }
  }

  @override
  Future<void> createProduct(ProductModel product, File? imageFile) async {
    try {
      debugPrint('📝 Creating new product...');
      
      final docRef = firestore.collection('products').doc();
      String? imageBase64;

      // Convert image to base64 if provided
      if (imageFile != null) {
        debugPrint('📤 Converting image to base64...');
        imageBase64 = await _convertImageToBase64(imageFile);
        debugPrint('✅ Image converted to base64');
      }

      final data = product.toJson();
      data['id'] = docRef.id;
      data['imageUrl'] = imageBase64; // Store as base64
      data['createdAt'] = DateTime.now().toIso8601String();

      await docRef.set(data);
      debugPrint('✅ Product created successfully');
    } catch (e) {
      debugPrint('❌ Error creating product: $e');
      throw ServerException('Failed to create product: ${e.toString()}');
    }
  }

  @override
  Future<void> updateProduct(ProductModel product, File? imageFile) async {
    try {
      debugPrint('📝 Updating product: ${product.id}');
      
      String? imageBase64 = product.imageUrl;

      // Convert new image to base64 if provided
      if (imageFile != null) {
        debugPrint('📤 Converting new image to base64...');
        imageBase64 = await _convertImageToBase64(imageFile);
        debugPrint('✅ New image converted to base64');
      }

      final data = product.toJson();
      data['imageUrl'] = imageBase64;

      await firestore.collection('products').doc(product.id).update(data);
      debugPrint('✅ Product updated successfully');
    } catch (e) {
      debugPrint('❌ Error updating product: $e');
      throw ServerException('Failed to update product: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      debugPrint('🗑️ Deleting product: $id');
      await firestore.collection('products').doc(id).delete();
      debugPrint('✅ Product deleted successfully');
    } catch (e) {
      debugPrint('❌ Error deleting product: $e');
      throw ServerException('Failed to delete product: ${e.toString()}');
    }
  }

  @override
  Future<List<ProductBrandModel>> getProductBrands() async {
    try {
      debugPrint('🔍 Fetching product brands from Firestore...');
      
      final snapshot = await firestore
          .collection('productBrands')
          .orderBy('name')
          .get();

      debugPrint('📦 Brands snapshot received. Documents: ${snapshot.docs.length}');

      return snapshot.docs
          .map((doc) => ProductBrandModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint('❌ Error fetching product brands: $e');
      throw ServerException('Failed to fetch product brands: ${e.toString()}');
    }
  }

  @override
  Future<List<ProductCategoryModel>> getProductCategories() async {
    try {
      debugPrint('🔍 Fetching product categories from Firestore...');
      
      final snapshot = await firestore
          .collection('productCategories')
          .orderBy('name')
          .get();

      debugPrint('📦 Categories snapshot received. Documents: ${snapshot.docs.length}');

      return snapshot.docs
          .map((doc) => ProductCategoryModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint('❌ Error fetching product categories: $e');
      throw ServerException('Failed to fetch product categories: ${e.toString()}');
    }
  }

  // Helper method to convert image to base64
  Future<String> _convertImageToBase64(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64String = base64Encode(bytes);
      return 'data:image/jpeg;base64,$base64String';
    } catch (e) {
      throw ServerException('Failed to convert image: ${e.toString()}');
    }
  }
}