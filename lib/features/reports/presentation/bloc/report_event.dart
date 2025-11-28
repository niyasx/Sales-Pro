import 'package:equatable/equatable.dart';
import '../../domain/entities/sales_report_filter.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object?> get props => [];
}

class LoadReportDataEvent extends ReportEvent {
  const LoadReportDataEvent();
}

class GenerateReportEvent extends ReportEvent {
  final SalesReportFilter filter;

  const GenerateReportEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}

class UpdateFilterEvent extends ReportEvent {
  final SalesReportFilter filter;

  const UpdateFilterEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}

class ClearReportEvent extends ReportEvent {
  const ClearReportEvent();
}