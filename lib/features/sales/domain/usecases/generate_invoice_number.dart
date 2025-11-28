import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/sale_repository.dart';

class GenerateInvoiceNumber implements UseCase<String, NoParams> {
  final SaleRepository repository;

  GenerateInvoiceNumber(this.repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await repository.generateInvoiceNumber();
  }
}