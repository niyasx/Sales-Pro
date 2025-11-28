import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/sale_model.dart';
import '../models/sale_detail_model.dart';
import '../models/sale_item_model.dart';

abstract class SaleRemoteDataSource {
  Future<List<SaleModel>> getSales();
  Future<SaleModel> getSaleById(String id);
  Future<List<SaleDetailModel>> getSaleDetails(String saleId);
  Future<void> createSale(SaleModel sale, List<SaleItemModel> items);
  Future<void> deleteSale(String id);
  Future<String> generateInvoiceNumber();
}

class SaleRemoteDataSourceImpl implements SaleRemoteDataSource {
  final FirebaseFirestore firestore;

  SaleRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<SaleModel>> getSales() async {
    try {
      debugPrint('[SaleDataSource] Fetching sales from Firestore');

      final snapshot = await firestore
          .collection('sales')
          .orderBy('date', descending: true)
          .get();

      debugPrint('[SaleDataSource] Sales snapshot received. Documents: ${snapshot.docs.length}');

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return SaleModel.fromJson(data);
      }).toList();
    } catch (e) {
      debugPrint('[SaleDataSource] Error fetching sales: $e');
      throw ServerException('Failed to fetch sales: ${e.toString()}');
    }
  }

  @override
  Future<SaleModel> getSaleById(String id) async {
    try {
      final doc = await firestore.collection('sales').doc(id).get();

      if (!doc.exists) {
        throw ServerException('Sale not found');
      }

      final data = doc.data()!;
      data['id'] = doc.id;
      return SaleModel.fromJson(data);
    } catch (e) {
      throw ServerException('Failed to fetch sale: ${e.toString()}');
    }
  }

  @override
  Future<List<SaleDetailModel>> getSaleDetails(String saleId) async {
    try {
      debugPrint('[SaleDataSource] Fetching sale details for sale: $saleId');

      final snapshot = await firestore
          .collection('sales')
          .doc(saleId)
          .collection('items')
          .orderBy('serialNo')
          .get();

      debugPrint('[SaleDataSource] Sale details received. Documents: ${snapshot.docs.length}');

      return snapshot.docs
          .map((doc) => SaleDetailModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint('[SaleDataSource] Error fetching sale details: $e');
      throw ServerException('Failed to fetch sale details: ${e.toString()}');
    }
  }

  @override
  Future<void> createSale(SaleModel sale, List<SaleItemModel> items) async {
    try {
      debugPrint('[SaleDataSource] Creating new sale');

      final saleRef = firestore.collection('sales').doc();

      // Create sale header
      final saleData = sale.toJson();
      saleData['id'] = saleRef.id;
      saleData['createdAt'] = DateTime.now().toIso8601String();

      await saleRef.set(saleData);
      debugPrint('[SaleDataSource] Sale header created');

      // Create sale items in subcollection
      final batch = firestore.batch();
      for (int i = 0; i < items.length; i++) {
        final itemRef = saleRef.collection('items').doc();
        final itemData = items[i].toJson();
        itemData['saleId'] = saleRef.id;
        itemData['serialNo'] = i + 1;
        batch.set(itemRef, itemData);
      }

      await batch.commit();
      debugPrint('[SaleDataSource] Sale items created: ${items.length}');
      debugPrint('[SaleDataSource] Sale created successfully');
    } catch (e) {
      debugPrint('[SaleDataSource] Error creating sale: $e');
      throw ServerException('Failed to create sale: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteSale(String id) async {
    try {
      debugPrint('[SaleDataSource] Deleting sale: $id');

      // Delete sale items first
      final itemsSnapshot = await firestore
          .collection('sales')
          .doc(id)
          .collection('items')
          .get();

      final batch = firestore.batch();
      for (var doc in itemsSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Delete sale header
      batch.delete(firestore.collection('sales').doc(id));

      await batch.commit();
      debugPrint('[SaleDataSource] Sale deleted successfully');
    } catch (e) {
      debugPrint('[SaleDataSource] Error deleting sale: $e');
      throw ServerException('Failed to delete sale: ${e.toString()}');
    }
  }

  @override
  Future<String> generateInvoiceNumber() async {
    try {
      debugPrint('[SaleDataSource] Generating invoice number');

      final now = DateTime.now();
      final yearMonth = '${now.year}${now.month.toString().padLeft(2, '0')}';

      // Get last invoice for this month
      final snapshot = await firestore
          .collection('sales')
          .where('invoiceNo', isGreaterThanOrEqualTo: 'INV-$yearMonth-')
          .orderBy('invoiceNo', descending: true)
          .limit(1)
          .get();

      int nextNumber = 1;
      if (snapshot.docs.isNotEmpty) {
        final lastInvoice = snapshot.docs.first.data()['invoiceNo'] as String;
        final lastNumber = int.tryParse(lastInvoice.split('-').last) ?? 0;
        nextNumber = lastNumber + 1;
      }

      final invoiceNo = 'INV-$yearMonth-${nextNumber.toString().padLeft(4, '0')}';
      debugPrint('[SaleDataSource] Generated invoice number: $invoiceNo');

      return invoiceNo;
    } catch (e) {
      debugPrint('[SaleDataSource] Error generating invoice number: $e');
      throw ServerException('Failed to generate invoice number: ${e.toString()}');
    }
  }
}