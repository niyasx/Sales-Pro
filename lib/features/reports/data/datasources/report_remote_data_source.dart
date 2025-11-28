import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/sales_report_filter.dart';
import '../models/sales_report_item_model.dart';
import '../models/sales_report_summary_model.dart';

abstract class ReportRemoteDataSource {
  Future<SalesReportSummaryModel> getSalesReport(SalesReportFilter filter);
  Future<List<Map<String, dynamic>>> getProductCategories();
  Future<List<Map<String, dynamic>>> getCustomers();
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  final FirebaseFirestore firestore;

  ReportRemoteDataSourceImpl({required this.firestore});

  @override
  Future<SalesReportSummaryModel> getSalesReport(SalesReportFilter filter) async {
    try {
      debugPrint('[ReportDataSource] Fetching sales report');

      // First, fetch all products to get category info
      final productsSnapshot = await firestore.collection('products').get();
      final Map<String, Map<String, dynamic>> productsMap = {};
      
      for (var doc in productsSnapshot.docs) {
        productsMap[doc.id] = {
          'categoryId': doc.data()['categoryId']?.toString() ?? '',
          'categoryName': doc.data()['categoryName']?.toString() ?? 'Uncategorized',
        };
      }
      debugPrint('[ReportDataSource] Loaded ${productsMap.length} products with categories');

      // Get all sales
      Query<Map<String, dynamic>> salesQuery = firestore.collection('sales');

      // Apply date filters
      if (filter.fromDate != null) {
        salesQuery = salesQuery.where(
          'date',
          isGreaterThanOrEqualTo: filter.fromDate!.toIso8601String(),
        );
      }
      if (filter.toDate != null) {
        final endDate = DateTime(
          filter.toDate!.year,
          filter.toDate!.month,
          filter.toDate!.day,
          23,
          59,
          59,
        );
        salesQuery = salesQuery.where(
          'date',
          isLessThanOrEqualTo: endDate.toIso8601String(),
        );
      }

      final salesSnapshot = await salesQuery.get();
      debugPrint('[ReportDataSource] Found ${salesSnapshot.docs.length} sales');

      List<SalesReportItemModel> reportItems = [];

      // For each sale, get the items from subcollection
      for (var saleDoc in salesSnapshot.docs) {
        final saleData = saleDoc.data();
        final saleId = saleDoc.id;

        // Apply customer filter
        if (filter.customerId != null &&
            filter.customerId!.isNotEmpty &&
            saleData['customerId'] != filter.customerId) {
          continue;
        }

        // Get sale items
        final itemsSnapshot = await firestore
            .collection('sales')
            .doc(saleId)
            .collection('items')
            .get();

        debugPrint('[ReportDataSource] Sale $saleId has ${itemsSnapshot.docs.length} items');

        for (var itemDoc in itemsSnapshot.docs) {
          final itemData = itemDoc.data();
          
          // Get productId and lookup category from products map
          final String productId = itemData['productId']?.toString() ?? '';
          final productInfo = productsMap[productId];
          
          final String categoryId = productInfo?['categoryId'] ?? '';
          final String categoryName = productInfo?['categoryName'] ?? 'Uncategorized';

          debugPrint('[ReportDataSource] Item: ${itemData['productName']}, CategoryId: $categoryId, CategoryName: $categoryName');

          // Apply category filter
          if (filter.categoryIds.isNotEmpty && !filter.categoryIds.contains(categoryId)) {
            debugPrint('[ReportDataSource] Skipping - category not in filter');
            continue;
          }

          reportItems.add(SalesReportItemModel(
            id: itemDoc.id,
            invoiceNo: saleData['invoiceNo']?.toString() ?? '',
            date: DateTime.parse(saleData['date']),
            customerId: saleData['customerId']?.toString() ?? '',
            customerName: saleData['customerName']?.toString() ?? '',
            productId: productId,
            productName: itemData['productName']?.toString() ?? '',
            categoryId: categoryId,
            categoryName: categoryName,
            quantity: (itemData['quantity'] as num?)?.toDouble() ?? 0,
            rate: (itemData['rate'] as num?)?.toDouble() ?? 0,
            discount: (itemData['discount'] as num?)?.toDouble() ?? 0,
            amount: (itemData['amount'] as num?)?.toDouble() ?? 0,
          ));
        }
      }

      debugPrint('[ReportDataSource] Total report items: ${reportItems.length}');

      return SalesReportSummaryModel.fromItems(
        reportItems,
        fromDate: filter.fromDate,
        toDate: filter.toDate,
      );
    } catch (e) {
      debugPrint('[ReportDataSource] Error fetching sales report: $e');
      throw ServerException('Failed to fetch sales report: ${e.toString()}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getProductCategories() async {
    try {
      debugPrint('[ReportDataSource] Fetching product categories');

      final snapshot = await firestore
          .collection('productCategories')
          .orderBy('name')
          .get();

      final categories = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc.data()['name'] ?? '',
        };
      }).toList();

      debugPrint('[ReportDataSource] Found ${categories.length} categories');
      return categories;
    } catch (e) {
      debugPrint('[ReportDataSource] Error fetching categories: $e');
      throw ServerException('Failed to fetch categories: ${e.toString()}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCustomers() async {
    try {
      debugPrint('[ReportDataSource] Fetching customers');

      final snapshot = await firestore
          .collection('customers')
          .orderBy('name')
          .get();

      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc.data()['name'] ?? '',
        };
      }).toList();
    } catch (e) {
      debugPrint('[ReportDataSource] Error fetching customers: $e');
      throw ServerException('Failed to fetch customers: ${e.toString()}');
    }
  }
}