import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/sales_report_filter.dart';
import '../entities/sales_report_summary.dart';
import '../repositories/report_repository.dart';

class GetSalesReport {
  final ReportRepository repository;

  GetSalesReport(this.repository);

  Future<Either<Failure, SalesReportSummary>> call(SalesReportFilter filter) {
    return repository.getSalesReport(filter);
  }
}