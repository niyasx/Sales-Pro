import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/customer_model.dart';
import '../models/customer_area_model.dart';
import '../models/customer_category_model.dart';

abstract class CustomerRemoteDataSource {
  Future<List<CustomerModel>> getCustomers();
  Future<CustomerModel> getCustomerById(String id);
  Future<void> createCustomer(CustomerModel customer);
  Future<void> updateCustomer(CustomerModel customer);
  Future<void> deleteCustomer(String id);
  Future<List<CustomerAreaModel>> getCustomerAreas();
  Future<List<CustomerCategoryModel>> getCustomerCategories();
}

class CustomerRemoteDataSourceImpl implements CustomerRemoteDataSource {
  final FirebaseFirestore firestore;

  CustomerRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<CustomerModel>> getCustomers() async {
    try {
      final snapshot = await firestore
          .collection('customers')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return CustomerModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw ServerException('Failed to fetch customers: ${e.toString()}');
    }
  }

  @override
  Future<CustomerModel> getCustomerById(String id) async {
    try {
      final doc = await firestore.collection('customers').doc(id).get();

      if (!doc.exists) {
        throw ServerException('Customer not found');
      }

      final data = doc.data()!;
      data['id'] = doc.id;
      return CustomerModel.fromJson(data);
    } catch (e) {
      throw ServerException('Failed to fetch customer: ${e.toString()}');
    }
  }

  @override
  Future<void> createCustomer(CustomerModel customer) async {
    try {
      final docRef = firestore.collection('customers').doc();
      final data = customer.toJson();
      data['id'] = docRef.id;
      data['createdAt'] = DateTime.now().toIso8601String();

      await docRef.set(data);
    } catch (e) {
      throw ServerException('Failed to create customer: ${e.toString()}');
    }
  }

  @override
  Future<void> updateCustomer(CustomerModel customer) async {
    try {
      await firestore
          .collection('customers')
          .doc(customer.id)
          .update(customer.toJson());
    } catch (e) {
      throw ServerException('Failed to update customer: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteCustomer(String id) async {
    try {
      await firestore.collection('customers').doc(id).delete();
    } catch (e) {
      throw ServerException('Failed to delete customer: ${e.toString()}');
    }
  }
@override
Future<List<CustomerAreaModel>> getCustomerAreas() async {
  try {
    debugPrint('🔍 Fetching customer areas from Firestore...');
    
    final snapshot = await firestore
        .collection('customerAreas')
        .orderBy('name')
        .get();

    debugPrint('📦 Snapshot received. Documents: ${snapshot.docs.length}');
    
    final areas = snapshot.docs
        .map((doc) {
          debugPrint('📄 Area Document ID: ${doc.id}, Data: ${doc.data()}');
          return CustomerAreaModel.fromJson(doc.data(), doc.id);
        })
        .toList();
    
    debugPrint('✅ Successfully loaded ${areas.length} areas');
    return areas;
  } catch (e) {
    debugPrint('❌ Error fetching customer areas: $e');
    throw ServerException('Failed to fetch customer areas: ${e.toString()}');
  }
}

@override
Future<List<CustomerCategoryModel>> getCustomerCategories() async {
  try {
    debugPrint('🔍 Fetching customer categories from Firestore...');
    
    final snapshot = await firestore
        .collection('customerCategories')
        .orderBy('name')
        .get();

    debugPrint('📦 Snapshot received. Documents: ${snapshot.docs.length}');
    
    final categories = snapshot.docs
        .map((doc) {
          debugPrint('📄 Category Document ID: ${doc.id}, Data: ${doc.data()}');
          return CustomerCategoryModel.fromJson(doc.data(), doc.id);
        })
        .toList();
    
    debugPrint('✅ Successfully loaded ${categories.length} categories');
    return categories;
  } catch (e) {
    debugPrint('❌ Error fetching customer categories: $e');
    throw ServerException('Failed to fetch customer categories: ${e.toString()}');
  }
}
}