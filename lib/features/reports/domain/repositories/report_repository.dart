import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/sales_report_filter.dart';
import '../entities/sales_report_summary.dart';

abstract class ReportRepository {
  Future<Either<Failure, SalesReportSummary>> getSalesReport(SalesReportFilter filter);
  Future<Either<Failure, List<Map<String, dynamic>>>> getProductCategories();
  Future<Either<Failure, List<Map<String, dynamic>>>> getCustomers();
}