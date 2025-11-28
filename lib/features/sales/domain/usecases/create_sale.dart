import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/sale.dart';
import '../entities/sale_item.dart';
import '../repositories/sale_repository.dart';

class CreateSale {
  final SaleRepository repository;

  CreateSale(this.repository);

  Future<Either<Failure, void>> call(Sale sale, List<SaleItem> items) async {
    return await repository.createSale(sale, items);
  }
}