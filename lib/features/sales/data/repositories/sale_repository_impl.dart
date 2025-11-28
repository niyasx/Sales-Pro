import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/sale.dart';
import '../../domain/entities/sale_detail.dart';
import '../../domain/entities/sale_item.dart';
import '../../domain/repositories/sale_repository.dart';
import '../datasources/sale_remote_data_source.dart';
import '../models/sale_model.dart';
import '../models/sale_item_model.dart';

class SaleRepositoryImpl implements SaleRepository {
  final SaleRemoteDataSource remoteDataSource;

  SaleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Sale>>> getSales() async {
    try {
      final sales = await remoteDataSource.getSales();
      return Right(sales.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Sale>> getSaleById(String id) async {
    try {
      final sale = await remoteDataSource.getSaleById(id);
      return Right(sale.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<SaleDetail>>> getSaleDetails(String saleId) async {
    try {
      final details = await remoteDataSource.getSaleDetails(saleId);
      return Right(details.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> createSale(Sale sale, List<SaleItem> items) async {
    try {
      final saleModel = SaleModel.fromEntity(sale);
      final itemModels = items.map((item) => SaleItemModel.fromEntity(item)).toList();
      await remoteDataSource.createSale(saleModel, itemModels);
      return Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSale(String id) async {
    try {
      await remoteDataSource.deleteSale(id);
      return Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> generateInvoiceNumber() async {
    try {
      final invoiceNo = await remoteDataSource.generateInvoiceNumber();
      return Right(invoiceNo);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }
}