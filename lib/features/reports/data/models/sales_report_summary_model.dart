import '../../domain/entities/sales_report_summary.dart';
import 'sales_report_item_model.dart';

class SalesReportSummaryModel extends SalesReportSummary {
  const SalesReportSummaryModel({
    required super.items,
    required super.totalQuantity,
    required super.totalAmount,
    super.fromDate,
    super.toDate,
    required super.categoryTotals,
  });

  factory SalesReportSummaryModel.fromItems(
    List<SalesReportItemModel> items, {
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    double totalQty = 0;
    double totalAmt = 0;
    Map<String, double> catTotals = {};

    for (var item in items) {
      totalQty += item.quantity;
      totalAmt += item.amount;
      catTotals[item.categoryName] = (catTotals[item.categoryName] ?? 0) + item.amount;
    }

    return SalesReportSummaryModel(
      items: items.map((e) => e.toEntity()).toList(),
      totalQuantity: totalQty,
      totalAmount: totalAmt,
      fromDate: fromDate,
      toDate: toDate,
      categoryTotals: catTotals,
    );
  }

  SalesReportSummary toEntity() {
    return SalesReportSummary(
      items: items,
      totalQuantity: totalQuantity,
      totalAmount: totalAmount,
      fromDate: fromDate,
      toDate: toDate,
      categoryTotals: categoryTotals,
    );
  }
}