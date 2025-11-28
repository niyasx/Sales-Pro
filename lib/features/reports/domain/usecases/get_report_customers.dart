import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/report_repository.dart';

class GetReportCustomers implements UseCase<List<Map<String, dynamic>>, NoParams> {
  final ReportRepository repository;

  GetReportCustomers(this.repository);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> call(NoParams params) {
    return repository.getCustomers();
  }
}