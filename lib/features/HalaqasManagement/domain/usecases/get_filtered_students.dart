// lib/features/students/domain/usecases/get_student_by_id.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/models/active_status.dart';
import '../../../../core/models/monitoring_filter.dart';
import '../../../../core/models/report_frequency.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/halaqa_list_item_entity.dart';
import '../repositories/halaqa_repository.dart';


@lazySingleton
class FetchFilteredHalaqasUseCase extends UseCase<List<HalaqaListItemEntity>, GetFilteredHalaqasParams> {
  final HalaqaRepository repository;

  FetchFilteredHalaqasUseCase(this.repository);

  @override
  Future<Either<Failure, List<HalaqaListItemEntity>>> call(
    GetFilteredHalaqasParams params,
  ) async {
    return await repository.getHalaqasByStudentCriteria(
      studentStatus: params.status,
      trackDate: params.trackDate,
      frequencyCode: params.frequencyCode,
      monitoringFilter: params.monitoringFilter,
    );
  }
}


class GetFilteredHalaqasParams extends Equatable {
 final ActiveStatus? status;
 final DateTime? trackDate;
 final Frequency? frequencyCode;
 final MonitoringFilter monitoringFilter;

  const GetFilteredHalaqasParams({
    this.status,
    this.trackDate,
    this.frequencyCode,
    this.monitoringFilter = MonitoringFilter.all,
  });

  @override
  List<Object?> get props => [status, trackDate, frequencyCode, monitoringFilter];
}
