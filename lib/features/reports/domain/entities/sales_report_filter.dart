import 'package:equatable/equatable.dart';

class SalesReportFilter extends Equatable {
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? customerId;
  final String? customerName;
  final List<String> categoryIds;

  const SalesReportFilter({
    this.fromDate,
    this.toDate,
    this.customerId,
    this.customerName,
    this.categoryIds = const [],
  });

  SalesReportFilter copyWith({
    DateTime? fromDate,
    DateTime? toDate,
    String? customerId,
    String? customerName,
    List<String>? categoryIds,
    bool clearFromDate = false,
    bool clearToDate = false,
    bool clearCustomerId = false,
    bool clearCustomerName = false,
  }) {
    return SalesReportFilter(
      fromDate: clearFromDate ? null : (fromDate ?? this.fromDate),
      toDate: clearToDate ? null : (toDate ?? this.toDate),
      customerId: clearCustomerId ? null : (customerId ?? this.customerId),
      customerName: clearCustomerName ? null : (customerName ?? this.customerName),
      categoryIds: categoryIds ?? this.categoryIds,
    );
  }

  @override
  List<Object?> get props => [fromDate, toDate, customerId, customerName, categoryIds];
}