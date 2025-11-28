import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/create_sale.dart';
import '../../domain/usecases/delete_sale.dart';
import '../../domain/usecases/generate_invoice_number.dart';
import '../../domain/usecases/get_sale_details.dart';
import '../../domain/usecases/get_sales.dart';
import 'sale_event.dart';
import 'sale_state.dart';

class SaleBloc extends Bloc<SaleEvent, SaleState> {
  final GetSales getSales;
  final GetSaleDetails getSaleDetails;
  final CreateSale createSale;
  final DeleteSale deleteSale;
  final GenerateInvoiceNumber generateInvoiceNumber;

  SaleBloc({
    required this.getSales,
    required this.getSaleDetails,
    required this.createSale,
    required this.deleteSale,
    required this.generateInvoiceNumber,
  }) : super(const SaleInitial()) {
    on<LoadSalesEvent>(_onLoadSales);
    on<LoadSaleDetailsEvent>(_onLoadSaleDetails);
    on<CreateSaleEvent>(_onCreateSale);
    on<DeleteSaleEvent>(_onDeleteSale);
    on<GenerateInvoiceNumberEvent>(_onGenerateInvoiceNumber);
  }

  Future<void> _onLoadSales(
    LoadSalesEvent event,
    Emitter<SaleState> emit,
  ) async {
    debugPrint('[SaleBloc] LoadSalesEvent triggered');
    emit(const SaleLoading());

    final result = await getSales(const NoParams());

    emit(
      result.fold(
        (failure) {
          debugPrint('[SaleBloc] Failed to load sales: ${failure.message}');
          return SaleError(failure.message);
        },
        (sales) {
          debugPrint('[SaleBloc] Sales loaded successfully: ${sales.length}');
          return SalesLoaded(sales);
        },
      ),
    );
  }

  Future<void> _onLoadSaleDetails(
    LoadSaleDetailsEvent event,
    Emitter<SaleState> emit,
  ) async {
    debugPrint('[SaleBloc] LoadSaleDetailsEvent triggered for: ${event.saleId}');
    emit(const SaleLoading());

    // Get the specific sale first
    final salesResult = await getSales(const NoParams());
    
    await salesResult.fold(
      (failure) async {
        debugPrint('[SaleBloc] Failed to load sales: ${failure.message}');
        emit(SaleError(failure.message));
      },
      (sales) async {
        try {
          final sale = sales.firstWhere((s) => s.id == event.saleId);
          
          // Get sale details
          final detailsResult = await getSaleDetails(event.saleId);
          
          emit(
            detailsResult.fold(
              (failure) {
                debugPrint('[SaleBloc] Failed to load details: ${failure.message}');
                return SaleError(failure.message);
              },
              (details) {
                debugPrint('[SaleBloc] Sale details loaded: ${details.length} items');
                return SaleDetailsLoaded(sale, details);
              },
            ),
          );
        } catch (e) {
          debugPrint('[SaleBloc] Sale not found: ${event.saleId}');
          emit(const SaleError('Sale not found'));
        }
      },
    );
  }

  Future<void> _onCreateSale(
    CreateSaleEvent event,
    Emitter<SaleState> emit,
  ) async {
    debugPrint('[SaleBloc] CreateSaleEvent triggered');
    emit(const SaleLoading());

    final result = await createSale(event.sale, event.items);

    await result.fold(
      (failure) async {
        debugPrint('[SaleBloc] Failed to create sale: ${failure.message}');
        emit(SaleError(failure.message));
      },
      (_) async {
        debugPrint('[SaleBloc] Sale created successfully');
        emit(const SaleOperationSuccess('Sale created successfully'));
        // Reload sales list
        final salesResult = await getSales(const NoParams());
        salesResult.fold(
          (failure) => emit(SaleError(failure.message)),
          (sales) => emit(SalesLoaded(sales)),
        );
      },
    );
  }

  Future<void> _onDeleteSale(
    DeleteSaleEvent event,
    Emitter<SaleState> emit,
  ) async {
    debugPrint('[SaleBloc] DeleteSaleEvent triggered');
    emit(const SaleLoading());

    final result = await deleteSale(event.saleId);

    await result.fold(
      (failure) async {
        debugPrint('[SaleBloc] Failed to delete sale: ${failure.message}');
        emit(SaleError(failure.message));
      },
      (_) async {
        debugPrint('[SaleBloc] Sale deleted successfully');
        emit(const SaleOperationSuccess('Sale deleted successfully'));
        // Reload sales list
        final salesResult = await getSales(const NoParams());
        salesResult.fold(
          (failure) => emit(SaleError(failure.message)),
          (sales) => emit(SalesLoaded(sales)),
        );
      },
    );
  }

  Future<void> _onGenerateInvoiceNumber(
    GenerateInvoiceNumberEvent event,
    Emitter<SaleState> emit,
  ) async {
    debugPrint('[SaleBloc] GenerateInvoiceNumberEvent triggered');

    final result = await generateInvoiceNumber(const NoParams());

    result.fold(
      (failure) {
        debugPrint('[SaleBloc] Failed to generate invoice: ${failure.message}');
        emit(SaleError(failure.message));
      },
      (invoiceNumber) {
        debugPrint('[SaleBloc] Invoice number generated: $invoiceNumber');
        emit(InvoiceNumberGenerated(invoiceNumber));
      },
    );
  }
}