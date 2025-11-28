import 'package:equatable/equatable.dart';
import '../../domain/entities/sale.dart';
import '../../domain/entities/sale_detail.dart';

abstract class SaleState extends Equatable {
  const SaleState();

  @override
  List<Object?> get props => [];
}

class SaleInitial extends SaleState {
  const SaleInitial();
}

class SaleLoading extends SaleState {
  const SaleLoading();
}

class SalesLoaded extends SaleState {
  final List<Sale> sales;

  const SalesLoaded(this.sales);

  @override
  List<Object> get props => [sales];
}

class SaleDetailsLoaded extends SaleState {
  final Sale sale;
  final List<SaleDetail> details;

  const SaleDetailsLoaded(this.sale, this.details);

  @override
  List<Object> get props => [sale, details];
}

class InvoiceNumberGenerated extends SaleState {
  final String invoiceNumber;

  const InvoiceNumberGenerated(this.invoiceNumber);

  @override
  List<Object> get props => [invoiceNumber];
}

class SaleOperationSuccess extends SaleState {
  final String message;

  const SaleOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class SaleError extends SaleState {
  final String message;

  const SaleError(this.message);

  @override
  List<Object> get props => [message];
}