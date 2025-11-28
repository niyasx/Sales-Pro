import 'package:equatable/equatable.dart';
import '../../domain/entities/sale.dart';
import '../../domain/entities/sale_item.dart';

abstract class SaleEvent extends Equatable {
  const SaleEvent();

  @override
  List<Object?> get props => [];
}

class LoadSalesEvent extends SaleEvent {
  const LoadSalesEvent();
}

class LoadSaleDetailsEvent extends SaleEvent {
  final String saleId;

  const LoadSaleDetailsEvent(this.saleId);

  @override
  List<Object> get props => [saleId];
}

class CreateSaleEvent extends SaleEvent {
  final Sale sale;
  final List<SaleItem> items;

  const CreateSaleEvent(this.sale, this.items);

  @override
  List<Object> get props => [sale, items];
}

class DeleteSaleEvent extends SaleEvent {
  final String saleId;

  const DeleteSaleEvent(this.saleId);

  @override
  List<Object> get props => [saleId];
}

class GenerateInvoiceNumberEvent extends SaleEvent {
  const GenerateInvoiceNumberEvent();
}