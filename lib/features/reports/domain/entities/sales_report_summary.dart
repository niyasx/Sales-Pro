import 'package:equatable/equatable.dart';
import 'sales_report_item.dart';

class SalesReportSummary extends Equatable {
  final List<SalesReportItem> items;
  final double totalQuantity;
  final double totalAmount;
  final DateTime? fromDate;
  final DateTime? toDate;
  final Map<String, double> categoryTotals;

  const SalesReportSummary({
    required this.items,
    required this.totalQuantity,
    required this.totalAmount,
    this.fromDate,
    this.toDate,
    required this.categoryTotals,
  });

  @override
  List<Object?> get props => [
        items,
        totalQuantity,
        totalAmount,
        fromDate,
        toDate,
        categoryTotals,
      ];
}