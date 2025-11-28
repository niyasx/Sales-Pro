import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/sale_detail.dart';
import '../repositories/sale_repository.dart';

class GetSaleDetails implements UseCase<List<SaleDetail>, String> {
  final SaleRepository repository;

  GetSaleDetails(this.repository);

  @override
  Future<Either<Failure, List<SaleDetail>>> call(String params) async {
    return await repository.getSaleDetails(params);
  }
}