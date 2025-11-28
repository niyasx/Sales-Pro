import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/sale.dart';
import '../entities/sale_detail.dart';
import '../entities/sale_item.dart';

abstract class SaleRepository {
  Future<Either<Failure, List<Sale>>> getSales();
  Future<Either<Failure, Sale>> getSaleById(String id);
  Future<Either<Failure, List<SaleDetail>>> getSaleDetails(String saleId);
  Future<Either<Failure, void>> createSale(Sale sale, List<SaleItem> items);
  Future<Either<Failure, void>> deleteSale(String id);
  Future<Either<Failure, String>> generateInvoiceNumber();
}