import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/customer_area.dart';
import '../repositories/customer_repository.dart';

class GetCustomerAreas implements UseCase<List<CustomerArea>, NoParams> {
  final CustomerRepository repository;

  GetCustomerAreas(this.repository);

  @override
  Future<Either<Failure, List<CustomerArea>>> call(NoParams params) async {
    return await repository.getCustomerAreas();
  }
}