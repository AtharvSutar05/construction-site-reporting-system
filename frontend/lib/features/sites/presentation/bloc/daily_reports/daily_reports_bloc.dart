import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/features/reports/data/models/daily_reports_query.dart';
import 'package:frontend/features/reports/data/repositories/daily_reports_repository.dart';

import 'daily_reports_event.dart';
import 'daily_reports_state.dart';

class DailyReportsBloc extends Bloc<DailyReportsEvent, DailyReportsState> {
  final String siteId;
  final DailyReportsRepository repository;

  DailyReportsBloc({required this.siteId, required this.repository})
    : super(const DailyReportsInitial()) {
    on<LoadDailyReports>(_onLoadDailyReports);
    on<LoadMoreDailyReports>(_onLoadMoreDailyReports);
    on<FilterDailyReports>(_onFilterDailyReports);
    on<ClearDailyReportFilters>(_onClearFilters);
  }

  Future<void> _onLoadDailyReports(
    LoadDailyReports event,
    Emitter<DailyReportsState> emit,
  ) async {
    emit(const DailyReportsLoading());

    try {
      const query = DailyReportsQuery();

      final response = await repository.getSiteReports(
        siteId: siteId,
        query: query,
      );

      emit(
        DailyReportsLoaded(
          reports: response.reports,
          pagination: response.pagination,
          query: query,
        ),
      );
    } on ApiException catch (e) {
      emit(DailyReportsError(message: e.message));
    } catch (_) {
      emit(const DailyReportsError(message: 'Something went wrong.'));
    }
  }

  Future<void> _onLoadMoreDailyReports(
    LoadMoreDailyReports event,
    Emitter<DailyReportsState> emit,
  ) async {
    final currentState = state;

    if (currentState is! DailyReportsLoaded) {
      return;
    }

    if (currentState.isLoadingMore) {
      return;
    }

    if (!currentState.pagination.hasNextPage) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final nextQuery = currentState.query.copyWith(
        page: currentState.pagination.page + 1,
      );

      final response = await repository.getSiteReports(
        siteId: siteId,
        query: nextQuery,
      );

      emit(
        currentState.copyWith(
          reports: [...currentState.reports, ...response.reports],
          pagination: response.pagination,
          query: nextQuery,
          isLoadingMore: false,
        ),
      );
    } on ApiException catch (_) {
      emit(currentState.copyWith(isLoadingMore: false));
    } catch (_) {
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onFilterDailyReports(
    FilterDailyReports event,
    Emitter<DailyReportsState> emit,
  ) async {
    final currentState = state;

    final currentQuery = currentState is DailyReportsLoaded
        ? currentState.query
        : const DailyReportsQuery();

    final query = DailyReportsQuery(
      fromDate: event.fromDate,
      toDate: event.toDate,
      status: event.status,
      page: 1,
      limit: currentQuery.limit,
    );

    emit(const DailyReportsLoading());

    try {
      final response = await repository.getSiteReports(
        siteId: siteId,
        query: query,
      );

      emit(
        DailyReportsLoaded(
          reports: response.reports,
          pagination: response.pagination,
          query: query,
        ),
      );
    } on ApiException catch (e) {
      emit(DailyReportsError(message: e.message));
    }
  }

  Future<void> _onClearFilters(
    ClearDailyReportFilters event,
    Emitter<DailyReportsState> emit,
  ) async {
    final currentState = state;

    final limit = currentState is DailyReportsLoaded
        ? currentState.query.limit
        : 20;

    final query = DailyReportsQuery(page: 1, limit: limit);

    emit(const DailyReportsLoading());

    try {
      final response = await repository.getSiteReports(
        siteId: siteId,
        query: query,
      );

      emit(
        DailyReportsLoaded(
          reports: response.reports,
          pagination: response.pagination,
          query: query,
        ),
      );
    } on ApiException catch (e) {
      emit(DailyReportsError(message: e.message));
    }
  }
}
