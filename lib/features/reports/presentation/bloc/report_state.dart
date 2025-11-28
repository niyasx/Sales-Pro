import 'package:equatable/equatable.dart';
import '../../domain/entities/sales_report_filter.dart';
import '../../domain/entities/sales_report_summary.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object?> get props => [];
}

class ReportInitial extends ReportState {
  const ReportInitial();
}

class ReportLoading extends ReportState {
  const ReportLoading();
}

class ReportDataLoaded extends ReportState {
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> customers;
  final SalesReportFilter filter;

  const ReportDataLoaded({
    required this.categories,
    required this.customers,
    required this.filter,
  });

  @override
  List<Object?> get props => [categories, customers, filter];
}

class ReportGenerated extends ReportState {
  final SalesReportSummary report;
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> customers;
  final SalesReportFilter filter;

  const ReportGenerated({
    required this.report,
    required this.categories,
    required this.customers,
    required this.filter,
  });

  @override
  List<Object?> get props => [report, categories, customers, filter];
}

class ReportError extends ReportState {
  final String message;

  const ReportError(this.message);

  @override
  List<Object> get props => [message];
}