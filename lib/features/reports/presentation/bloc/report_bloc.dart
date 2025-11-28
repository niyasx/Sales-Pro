import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/sales_report_filter.dart';
import '../../domain/usecases/get_report_categories.dart';
import '../../domain/usecases/get_report_customers.dart';
import '../../domain/usecases/get_sales_report.dart';
import 'report_event.dart';
import 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final GetSalesReport getSalesReport;
  final GetReportCategories getReportCategories;
  final GetReportCustomers getReportCustomers;

  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _customers = [];
  SalesReportFilter _currentFilter = const SalesReportFilter();

  ReportBloc({
    required this.getSalesReport,
    required this.getReportCategories,
    required this.getReportCustomers,
  }) : super(const ReportInitial()) {
    on<LoadReportDataEvent>(_onLoadReportData);
    on<GenerateReportEvent>(_onGenerateReport);
    on<UpdateFilterEvent>(_onUpdateFilter);
    on<ClearReportEvent>(_onClearReport);
  }

  Future<void> _onLoadReportData(
    LoadReportDataEvent event,
    Emitter<ReportState> emit,
  ) async {
    debugPrint('[ReportBloc] LoadReportDataEvent triggered');
    emit(const ReportLoading());

    final categoriesResult = await getReportCategories(const NoParams());
    final customersResult = await getReportCustomers(const NoParams());

    String? errorMessage;

    categoriesResult.fold(
      (failure) => errorMessage = failure.message,
      (categories) => _categories = categories,
    );

    customersResult.fold(
      (failure) => errorMessage ??= failure.message,
      (customers) => _customers = customers,
    );

    if (errorMessage != null) {
      debugPrint('[ReportBloc] Error loading data: $errorMessage');
      emit(ReportError(errorMessage!));
      return;
    }

    debugPrint('[ReportBloc] Data loaded: ${_categories.length} categories, ${_customers.length} customers');
    emit(ReportDataLoaded(
      categories: _categories,
      customers: _customers,
      filter: _currentFilter,
    ));
  }

  Future<void> _onGenerateReport(
    GenerateReportEvent event,
    Emitter<ReportState> emit,
  ) async {
    debugPrint('[ReportBloc] GenerateReportEvent triggered');
    emit(const ReportLoading());

    _currentFilter = event.filter;

    final result = await getSalesReport(event.filter);

    emit(
      result.fold(
        (failure) {
          debugPrint('[ReportBloc] Error generating report: ${failure.message}');
          return ReportError(failure.message);
        },
        (report) {
          debugPrint('[ReportBloc] Report generated: ${report.items.length} items');
          return ReportGenerated(
            report: report,
            categories: _categories,
            customers: _customers,
            filter: _currentFilter,
          );
        },
      ),
    );
  }

  Future<void> _onUpdateFilter(
    UpdateFilterEvent event,
    Emitter<ReportState> emit,
  ) async {
    debugPrint('[ReportBloc] UpdateFilterEvent triggered');
    _currentFilter = event.filter;

    emit(ReportDataLoaded(
      categories: _categories,
      customers: _customers,
      filter: _currentFilter,
    ));
  }

  Future<void> _onClearReport(
    ClearReportEvent event,
    Emitter<ReportState> emit,
  ) async {
    debugPrint('[ReportBloc] ClearReportEvent triggered');
    _currentFilter = const SalesReportFilter();

    emit(ReportDataLoaded(
      categories: _categories,
      customers: _customers,
      filter: _currentFilter,
    ));
  }
}