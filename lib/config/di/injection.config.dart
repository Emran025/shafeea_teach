// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:device_info_plus/device_info_plus.dart' as _i833;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as _i161;
import 'package:shafeea/config/di/injection.dart' as _i31;
import 'package:shafeea/config/di/register_module.dart' as _i644;
import 'package:shafeea/core/api/api_consumer.dart' as _i733;
import 'package:shafeea/core/background/background_job_service.dart' as _i752;
import 'package:shafeea/core/background/workmanager_job_service_impl.dart'
    as _i54;
import 'package:shafeea/core/database/app_database.dart' as _i396;
import 'package:shafeea/core/network/network_info.dart' as _i672;
import 'package:shafeea/core/network/network_info_impl.dart' as _i428;
import 'package:shafeea/core/services/device_info_service.dart' as _i222;
import 'package:shafeea/core/services/dummy_push_notification_service_impl.dart'
    as _i975;
import 'package:shafeea/core/services/push_notification_service.dart' as _i228;
import 'package:shafeea/features/app/cubit/app_setup_cubit.dart' as _i478;
import 'package:shafeea/features/auth/data/datasources/auth_local_data_source.dart'
    as _i234;
import 'package:shafeea/features/auth/data/datasources/auth_local_data_source_impl.dart'
    as _i1018;
import 'package:shafeea/features/auth/data/datasources/auth_remote_data_source.dart'
    as _i672;
import 'package:shafeea/features/auth/data/datasources/auth_remote_data_source_impl.dart'
    as _i287;
import 'package:shafeea/features/auth/data/repositories_impl/auth_repository_impl.dart'
    as _i950;
import 'package:shafeea/features/auth/domain/repositories/auth_repository.dart'
    as _i424;
import 'package:shafeea/features/auth/domain/usecases/change_password_usecase.dart'
    as _i960;
import 'package:shafeea/features/auth/domain/usecases/check_login_usecase.dart'
    as _i186;
import 'package:shafeea/features/auth/domain/usecases/forget_password_usecase.dart'
    as _i426;
import 'package:shafeea/features/auth/domain/usecases/get_all_users_use_case.dart'
    as _i1045;
import 'package:shafeea/features/auth/domain/usecases/login_usecase.dart'
    as _i250;
import 'package:shafeea/features/auth/domain/usecases/logout_usecase.dart'
    as _i871;
import 'package:shafeea/features/auth/domain/usecases/resend_verification_usecase.dart'
    as _i334;
import 'package:shafeea/features/auth/domain/usecases/switch_user_usecase.dart'
    as _i741;
import 'package:shafeea/features/auth/presentation/bloc/auth_bloc.dart'
    as _i708;
import 'package:shafeea/features/daily_tracking/data/datasources/quran_local_data_source.dart'
    as _i750;
import 'package:shafeea/features/daily_tracking/data/datasources/quran_local_data_source_impl.dart'
    as _i117;
import 'package:shafeea/features/daily_tracking/data/datasources/tracking_local_data_source.dart'
    as _i1022;
import 'package:shafeea/features/daily_tracking/data/datasources/tracking_local_data_source_impl.dart'
    as _i348;
import 'package:shafeea/features/daily_tracking/data/datasources/tracking_remote_data_source.dart'
    as _i239;
import 'package:shafeea/features/daily_tracking/data/datasources/tracking_remote_data_source_impl.dart'
    as _i46;
import 'package:shafeea/features/daily_tracking/data/repositories/quran_repository_impl.dart'
    as _i210;
import 'package:shafeea/features/daily_tracking/data/repositories/tracking_repository_impl.dart'
    as _i431;
import 'package:shafeea/features/daily_tracking/data/services/halaqa_sync_service_impl.dart'
    as _i567;
import 'package:shafeea/features/daily_tracking/data/services/tracking_sync_service.dart'
    as _i1014;
import 'package:shafeea/features/daily_tracking/domain/repositories/quran_repository.dart'
    as _i611;
import 'package:shafeea/features/daily_tracking/domain/repositories/tracking_repository.dart'
    as _i341;
import 'package:shafeea/features/daily_tracking/domain/usecases/finalize_session.dart'
    as _i780;
import 'package:shafeea/features/daily_tracking/domain/usecases/get_all_mistakes.dart'
    as _i500;
import 'package:shafeea/features/daily_tracking/domain/usecases/get_error_analysis_chart_data.dart'
    as _i618;
import 'package:shafeea/features/daily_tracking/domain/usecases/get_mistakes_ayahs.dart'
    as _i1010;
import 'package:shafeea/features/daily_tracking/domain/usecases/get_or_create_today_tracking.dart'
    as _i949;
import 'package:shafeea/features/daily_tracking/domain/usecases/get_page_data.dart'
    as _i331;
import 'package:shafeea/features/daily_tracking/domain/usecases/get_surahs_list.dart'
    as _i359;
import 'package:shafeea/features/daily_tracking/domain/usecases/save_task_progress.dart'
    as _i587;
import 'package:shafeea/features/daily_tracking/presentation/bloc/error_analysis_chart_bloc.dart'
    as _i2;
import 'package:shafeea/features/daily_tracking/presentation/bloc/quran_reader_bloc.dart'
    as _i8;
import 'package:shafeea/features/daily_tracking/presentation/bloc/tracking_session_bloc.dart'
    as _i820;
import 'package:shafeea/features/HalaqasManagement/data/datasources/halaqa_local_data_source.dart'
    as _i796;
import 'package:shafeea/features/HalaqasManagement/data/datasources/halaqa_local_data_source_impl.dart'
    as _i533;
import 'package:shafeea/features/HalaqasManagement/data/datasources/halaqa_remote_data_source.dart'
    as _i166;
import 'package:shafeea/features/HalaqasManagement/data/datasources/halaqa_remote_data_source_impl.dart'
    as _i132;
import 'package:shafeea/features/HalaqasManagement/data/repositories_impl/halaqa_repository_impl.dart'
    as _i53;
import 'package:shafeea/features/HalaqasManagement/data/services/halaqa_sync_service.dart'
    as _i679;
import 'package:shafeea/features/HalaqasManagement/data/services/halaqa_sync_service_impl.dart'
    as _i964;
import 'package:shafeea/features/HalaqasManagement/domain/repositories/halaqa_repository.dart'
    as _i673;
import 'package:shafeea/features/HalaqasManagement/domain/usecases/fetch_more_halaqas_usecase.dart'
    as _i249;
import 'package:shafeea/features/HalaqasManagement/domain/usecases/get_filtered_students.dart'
    as _i465;
import 'package:shafeea/features/HalaqasManagement/domain/usecases/get_halaqa_by_id.dart'
    as _i951;
import 'package:shafeea/features/HalaqasManagement/domain/usecases/get_halaqas.dart'
    as _i268;
import 'package:shafeea/features/HalaqasManagement/domain/usecases/halaqa_halaqa_usecase.dart'
    as _i871;
import 'package:shafeea/features/HalaqasManagement/domain/usecases/set_halaqa_status_params.dart'
    as _i948;
import 'package:shafeea/features/HalaqasManagement/domain/usecases/upsert_halaqa_usecase.dart'
    as _i478;
import 'package:shafeea/features/HalaqasManagement/presentation/bloc/halaqa_bloc.dart'
    as _i728;
import 'package:shafeea/features/settings/data/datasources/core_data_local_data_source.dart'
    as _i391;
import 'package:shafeea/features/settings/data/datasources/core_data_local_data_source_impl.dart'
    as _i120;
import 'package:shafeea/features/settings/data/datasources/settings_local_data_source.dart'
    as _i950;
import 'package:shafeea/features/settings/data/datasources/settings_local_data_source_impl.dart'
    as _i854;
import 'package:shafeea/features/settings/data/datasources/settings_remote_data_source.dart'
    as _i38;
import 'package:shafeea/features/settings/data/datasources/settings_remote_data_source_impl.dart'
    as _i825;
import 'package:shafeea/features/settings/data/repositories_impl/settings_repository_impl.dart'
    as _i900;
import 'package:shafeea/features/settings/domain/repositories/settings_repository.dart'
    as _i844;
import 'package:shafeea/features/settings/domain/usecases/export_data_usecase.dart'
    as _i273;
import 'package:shafeea/features/settings/domain/usecases/export_follow_up_reports_usecase.dart'
    as _i42;
import 'package:shafeea/features/settings/domain/usecases/get_faqs_usecase.dart'
    as _i1001;
import 'package:shafeea/features/settings/domain/usecases/get_latest_policy_usecase.dart'
    as _i356;
import 'package:shafeea/features/settings/domain/usecases/get_settings.dart'
    as _i24;
import 'package:shafeea/features/settings/domain/usecases/get_terms_of_use_usecase.dart'
    as _i830;
import 'package:shafeea/features/settings/domain/usecases/get_user_profile.dart'
    as _i117;
import 'package:shafeea/features/settings/domain/usecases/import_data_usecase.dart'
    as _i710;
import 'package:shafeea/features/settings/domain/usecases/import_follow_up_reports_usecase.dart'
    as _i204;
import 'package:shafeea/features/settings/domain/usecases/save_theme.dart'
    as _i1062;
import 'package:shafeea/features/settings/domain/usecases/set_analytics_preference.dart'
    as _i892;
import 'package:shafeea/features/settings/domain/usecases/set_notifications_preference.dart'
    as _i256;
import 'package:shafeea/features/settings/domain/usecases/submit_support_ticket_usecase.dart'
    as _i402;
import 'package:shafeea/features/settings/domain/usecases/update_user_profile.dart'
    as _i957;
import 'package:shafeea/features/settings/presentation/bloc/settings_bloc.dart'
    as _i790;
import 'package:shafeea/features/StudentsManagement/data/datasources/student_local_data_source.dart'
    as _i176;
import 'package:shafeea/features/StudentsManagement/data/datasources/student_local_data_source_impl.dart'
    as _i362;
import 'package:shafeea/features/StudentsManagement/data/datasources/student_remote_data_source.dart'
    as _i1047;
import 'package:shafeea/features/StudentsManagement/data/datasources/student_remote_data_source_impl.dart'
    as _i410;
import 'package:shafeea/features/StudentsManagement/data/repositories_impl/student_repository_impl.dart'
    as _i971;
import 'package:shafeea/features/StudentsManagement/data/services/student_sync_service.dart'
    as _i963;
import 'package:shafeea/features/StudentsManagement/data/services/student_sync_service_impl.dart'
    as _i691;
import 'package:shafeea/features/StudentsManagement/domain/repositories/student_repository.dart'
    as _i344;
import 'package:shafeea/features/StudentsManagement/domain/usecases/delete_student_usecase.dart'
    as _i532;
import 'package:shafeea/features/StudentsManagement/domain/usecases/fetch_more_student_usecase.dart'
    as _i956;
import 'package:shafeea/features/StudentsManagement/domain/usecases/generate_follow_up_report_use_case.dart'
    as _i298;
import 'package:shafeea/features/StudentsManagement/domain/usecases/get_filtered_students.dart'
    as _i1039;
import 'package:shafeea/features/StudentsManagement/domain/usecases/get_student_by_id.dart'
    as _i843;
import 'package:shafeea/features/StudentsManagement/domain/usecases/get_students.dart'
    as _i578;
import 'package:shafeea/features/StudentsManagement/domain/usecases/set_student_status_params.dart'
    as _i581;
import 'package:shafeea/features/StudentsManagement/domain/usecases/upsert_student_usecase.dart'
    as _i41;
import 'package:shafeea/features/StudentsManagement/presentation/bloc/student_bloc.dart'
    as _i73;
import 'package:shafeea/features/StudentsManagement/presentation/view_models/factories/follow_up_report_factory.dart'
    as _i981;
import 'package:shafeea/features/supervisor_dashboard/data/datasources/supervisor_local_data_source.dart'
    as _i510;
import 'package:shafeea/features/supervisor_dashboard/data/datasources/supervisor_local_data_source_impl.dart'
    as _i1017;
import 'package:shafeea/features/supervisor_dashboard/data/datasources/supervisor_remote_data_source.dart'
    as _i945;
import 'package:shafeea/features/supervisor_dashboard/data/datasources/supervisor_remote_data_source_impl.dart'
    as _i175;
import 'package:shafeea/features/supervisor_dashboard/data/repositories_impl/repository_impl.dart'
    as _i10;
import 'package:shafeea/features/supervisor_dashboard/data/service/timeline_builder_impl.dart'
    as _i651;
import 'package:shafeea/features/supervisor_dashboard/domain/repositories/repository.dart'
    as _i421;
import 'package:shafeea/features/supervisor_dashboard/domain/usecases/applicants_use_case.dart'
    as _i257;
import 'package:shafeea/features/supervisor_dashboard/domain/usecases/approve_applicant_usecase.dart'
    as _i447;
import 'package:shafeea/features/supervisor_dashboard/domain/usecases/get_applicant_profile_usecase.dart'
    as _i345;
import 'package:shafeea/features/supervisor_dashboard/domain/usecases/get_date_range_use_case.dart'
    as _i67;
import 'package:shafeea/features/supervisor_dashboard/domain/usecases/get_entities_counts_use_case.dart'
    as _i494;
import 'package:shafeea/features/supervisor_dashboard/domain/usecases/get_timeline_use_case.dart'
    as _i171;
import 'package:shafeea/features/supervisor_dashboard/domain/usecases/reject_applicant_usecase.dart'
    as _i178;
import 'package:shafeea/features/supervisor_dashboard/presentation/bloc/supervisor_bloc.dart'
    as _i234;
import 'package:shafeea/features/TeachersManagement/data/datasources/teacher_local_data_source.dart'
    as _i109;
import 'package:shafeea/features/TeachersManagement/data/datasources/teacher_local_data_source_impl.dart'
    as _i630;
import 'package:shafeea/features/TeachersManagement/data/datasources/teacher_remote_data_source.dart'
    as _i270;
import 'package:shafeea/features/TeachersManagement/data/datasources/teacher_remote_data_source_impl.dart'
    as _i145;
import 'package:shafeea/features/TeachersManagement/data/repositories_impl/teacher_repository_impl.dart'
    as _i576;
import 'package:shafeea/features/TeachersManagement/data/services/teacher_sync_service.dart'
    as _i387;
import 'package:shafeea/features/TeachersManagement/data/services/teacher_sync_service_impl.dart'
    as _i976;
import 'package:shafeea/features/TeachersManagement/domain/repositories/teacher_repository.dart'
    as _i622;
import 'package:shafeea/features/TeachersManagement/domain/usecases/delete_teacher_usecase.dart'
    as _i708;
import 'package:shafeea/features/TeachersManagement/domain/usecases/fetch_more_teachers_usecase.dart'
    as _i974;
import 'package:shafeea/features/TeachersManagement/domain/usecases/get_teacher_by_id.dart'
    as _i156;
import 'package:shafeea/features/TeachersManagement/domain/usecases/get_teachers.dart'
    as _i82;
import 'package:shafeea/features/TeachersManagement/domain/usecases/set_teacher_status_params.dart'
    as _i281;
import 'package:shafeea/features/TeachersManagement/domain/usecases/upsert_teacher_usecase.dart'
    as _i691;
import 'package:shafeea/features/TeachersManagement/presentation/bloc/teacher_bloc.dart'
    as _i639;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:sqflite/sqflite.dart' as _i779;
import 'package:workmanager/workmanager.dart' as _i500;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final blocModule = _$BlocModule();
    final registerModule = _$RegisterModule();
    gh.factory<_i478.AppSetupCubit>(() => blocModule.appSetupCubit());
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.factory<_i981.FollowUpReportFactory>(
      () => _i981.FollowUpReportFactory(),
    );
    gh.lazySingleton<_i396.AppDatabase>(() => registerModule.appDatabase);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.lazySingleton<_i161.InternetConnection>(
      () => registerModule.connectionChecker,
    );
    gh.lazySingleton<_i833.DeviceInfoPlugin>(
      () => registerModule.deviceInfoPlugin,
    );
    gh.lazySingleton<_i500.Workmanager>(() => registerModule.workmanager);
    gh.lazySingleton<_i752.BackgroundJobService>(
      () => _i54.WorkmanagerJobServiceImpl(),
    );
    gh.factory<_i268.WatchHalaqasParams>(
      () => _i268.WatchHalaqasParams(forceRefresh: gh<bool>()),
    );
    gh.factory<_i82.WatchTeachersParams>(
      () => _i82.WatchTeachersParams(forceRefresh: gh<bool>()),
    );
    gh.lazySingleton<_i750.QuranLocalDataSource>(
      () => _i117.QuranLocalDataSourceImpl(),
    );
    gh.lazySingleton<_i361.Dio>(
      () => registerModule.dioForTokenRefreshInstance(),
      instanceName: 'DioForTokenRefresh',
    );
    gh.lazySingleton<_i228.PushNotificationService>(
      () => _i975.DummyPushNotificationServiceImpl(),
    );
    gh.lazySingleton<_i611.QuranRepository>(
      () => _i210.QuranRepositoryImpl(
        localDataSource: gh<_i750.QuranLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i234.AuthLocalDataSource>(
      () => _i1018.AuthLocalDataSourceImpl(
        sharedPreferences: gh<_i460.SharedPreferences>(),
        secureStorage: gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.lazySingleton<_i950.SettingsLocalDataSource>(
      () => _i854.SettingsLocalDataSourceImpl(
        sharedPreferences: gh<_i460.SharedPreferences>(),
        appDatabase: gh<_i396.AppDatabase>(),
      ),
    );
    gh.lazySingleton<_i361.Dio>(
      () => registerModule.dio(
        gh<_i558.FlutterSecureStorage>(),
        gh<_i361.Dio>(instanceName: 'DioForTokenRefresh'),
      ),
    );
    gh.lazySingleton<_i222.DeviceInfoService>(
      () => _i222.DeviceInfoServiceImpl(
        deviceInfoPlugin: gh<_i833.DeviceInfoPlugin>(),
        pushNotificationService: gh<_i228.PushNotificationService>(),
      ),
    );
    await gh.factoryAsync<_i779.Database>(
      () => registerModule.database(gh<_i396.AppDatabase>()),
      preResolve: true,
    );
    gh.lazySingleton<_i1010.GetMistakesAyahs>(
      () => _i1010.GetMistakesAyahs(repository: gh<_i611.QuranRepository>()),
    );
    gh.lazySingleton<_i331.GetPageData>(
      () => _i331.GetPageData(repository: gh<_i611.QuranRepository>()),
    );
    gh.lazySingleton<_i359.GetSurahsList>(
      () => _i359.GetSurahsList(repository: gh<_i611.QuranRepository>()),
    );
    gh.lazySingleton<_i672.NetworkInfo>(
      () => _i428.NetworkInfoImpl(
        connectionChecker: gh<_i161.InternetConnection>(),
      ),
    );
    gh.lazySingleton<_i796.HalaqaLocalDataSource>(
      () => _i533.HalaqaLocalDataSourceImpl(
        database: gh<_i779.Database>(),
        authLocalDataSource: gh<_i234.AuthLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i391.CoreDataLocalDataSource>(
      () => _i120.CoreDataLocalDataSourceImpl(
        database: gh<_i779.Database>(),
        authLocalDataSource: gh<_i234.AuthLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i109.TeacherLocalDataSource>(
      () => _i630.TeacherLocalDataSourceImpl(
        database: gh<_i779.Database>(),
        authLocalDataSource: gh<_i234.AuthLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i176.StudentLocalDataSource>(
      () => _i362.StudentLocalDataSourceImpl(
        database: gh<_i779.Database>(),
        authLocalDataSource: gh<_i234.AuthLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i733.ApiConsumer>(
      () => registerModule.apiConsumer(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i38.SettingsRemoteDataSource>(
      () => _i825.SettingsRemoteDataSourceImpl(api: gh<_i733.ApiConsumer>()),
    );
    gh.factory<_i8.QuranReaderBloc>(
      () => blocModule.quranReaderBloc(
        gh<_i359.GetSurahsList>(),
        gh<_i1010.GetMistakesAyahs>(),
        gh<_i331.GetPageData>(),
      ),
    );
    gh.lazySingleton<_i510.SupervisorLocalDataSource>(
      () => _i1017.SupervisorLocalDataSourceImpl(
        database: gh<_i779.Database>(),
        authLocalDataSource: gh<_i234.AuthLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i1022.TrackingLocalDataSource>(
      () => _i348.TrackingLocalDataSourceImpl(
        gh<_i396.AppDatabase>(),
        gh<_i750.QuranLocalDataSource>(),
        gh<_i234.AuthLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i239.TrackingRemoteDataSource>(
      () => _i46.TrackingRemoteDataSourceImpl(
        apiConsumer: gh<_i733.ApiConsumer>(),
      ),
    );
    gh.factory<_i651.TimelineBuilderImpl>(
      () => _i651.TimelineBuilderImpl(
        localDataSource: gh<_i510.SupervisorLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i166.HalaqaRemoteDataSource>(
      () => _i132.HalaqaRemoteDataSourceImpl(
        apiConsumer: gh<_i733.ApiConsumer>(),
      ),
    );
    gh.lazySingleton<_i1047.StudentRemoteDataSource>(
      () => _i410.StudentRemoteDataSourceImpl(
        apiConsumer: gh<_i733.ApiConsumer>(),
      ),
    );
    gh.lazySingleton<_i341.TrackingRepository>(
      () => _i431.TrackingRepositoryImpl(
        localDataSource: gh<_i1022.TrackingLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i270.TeacherRemoteDataSource>(
      () => _i145.TeacherRemoteDataSourceImpl(
        apiConsumer: gh<_i733.ApiConsumer>(),
      ),
    );
    gh.lazySingleton<_i1014.TrackingSyncService>(
      () => _i567.TrackingSyncServiceImpl(
        remoteDataSource: gh<_i239.TrackingRemoteDataSource>(),
        localDataSource: gh<_i1022.TrackingLocalDataSource>(),
        studentLocalDataSource: gh<_i176.StudentLocalDataSource>(),
        networkInfo: gh<_i672.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i672.AuthRemoteDataSource>(
      () => _i287.AuthRemoteDataSourceImpl(gh<_i733.ApiConsumer>()),
    );
    gh.lazySingleton<_i387.TeacherSyncService>(
      () => _i976.TeacherSyncServiceImpl(
        remoteDataSource: gh<_i270.TeacherRemoteDataSource>(),
        localDataSource: gh<_i109.TeacherLocalDataSource>(),
        networkInfo: gh<_i672.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i945.SupervisorRemoteDataSource>(
      () => _i175.SupervisorRemoteDataSourceImpl(
        apiConsumer: gh<_i733.ApiConsumer>(),
      ),
    );
    gh.lazySingleton<_i844.SettingsRepository>(
      () => _i900.SettingsRepositoryImpl(
        localDataSource: gh<_i950.SettingsLocalDataSource>(),
        remoteDataSource: gh<_i38.SettingsRemoteDataSource>(),
        coreDataSource: gh<_i391.CoreDataLocalDataSource>(),
        networkInfo: gh<_i672.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i273.ExportDataUseCase>(
      () => _i273.ExportDataUseCase(gh<_i844.SettingsRepository>()),
    );
    gh.lazySingleton<_i1001.GetFaqsUseCase>(
      () => _i1001.GetFaqsUseCase(gh<_i844.SettingsRepository>()),
    );
    gh.lazySingleton<_i830.GetTermsOfUseUseCase>(
      () => _i830.GetTermsOfUseUseCase(gh<_i844.SettingsRepository>()),
    );
    gh.lazySingleton<_i710.ImportDataUseCase>(
      () => _i710.ImportDataUseCase(gh<_i844.SettingsRepository>()),
    );
    gh.lazySingleton<_i402.SubmitSupportTicketUseCase>(
      () => _i402.SubmitSupportTicketUseCase(gh<_i844.SettingsRepository>()),
    );
    gh.lazySingleton<_i780.FinalizeSession>(
      () => _i780.FinalizeSession(gh<_i341.TrackingRepository>()),
    );
    gh.lazySingleton<_i500.GetAllMistakes>(
      () => _i500.GetAllMistakes(gh<_i341.TrackingRepository>()),
    );
    gh.lazySingleton<_i618.GetErrorAnalysisChartData>(
      () => _i618.GetErrorAnalysisChartData(gh<_i341.TrackingRepository>()),
    );
    gh.lazySingleton<_i949.GetOrCreateTodayTrackingDetails>(
      () =>
          _i949.GetOrCreateTodayTrackingDetails(gh<_i341.TrackingRepository>()),
    );
    gh.lazySingleton<_i587.SaveTaskProgress>(
      () => _i587.SaveTaskProgress(gh<_i341.TrackingRepository>()),
    );
    gh.factory<_i820.TrackingSessionBloc>(
      () => blocModule.trackingSession(
        gh<_i949.GetOrCreateTodayTrackingDetails>(),
        gh<_i587.SaveTaskProgress>(),
        gh<_i780.FinalizeSession>(),
        gh<_i500.GetAllMistakes>(),
      ),
    );
    gh.lazySingleton<_i356.GetLatestPolicyUseCase>(
      () => _i356.GetLatestPolicyUseCase(gh<_i844.SettingsRepository>()),
    );
    gh.lazySingleton<_i24.GetSettings>(
      () => _i24.GetSettings(gh<_i844.SettingsRepository>()),
    );
    gh.lazySingleton<_i117.GetUserProfile>(
      () => _i117.GetUserProfile(gh<_i844.SettingsRepository>()),
    );
    gh.lazySingleton<_i1062.SaveTheme>(
      () => _i1062.SaveTheme(gh<_i844.SettingsRepository>()),
    );
    gh.lazySingleton<_i892.SetAnalyticsPreference>(
      () => _i892.SetAnalyticsPreference(gh<_i844.SettingsRepository>()),
    );
    gh.lazySingleton<_i256.SetNotificationsPreference>(
      () => _i256.SetNotificationsPreference(gh<_i844.SettingsRepository>()),
    );
    gh.lazySingleton<_i957.UpdateUserProfile>(
      () => _i957.UpdateUserProfile(gh<_i844.SettingsRepository>()),
    );
    gh.lazySingleton<_i424.AuthRepository>(
      () => _i950.AuthRepositoryImpl(
        remoteDataSource: gh<_i672.AuthRemoteDataSource>(),
        localDataSource: gh<_i234.AuthLocalDataSource>(),
        deviceInfoService: gh<_i222.DeviceInfoService>(),
        networkInfo: gh<_i672.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i679.HalaqaSyncService>(
      () => _i964.HalaqaSyncServiceImpl(
        remoteDataSource: gh<_i166.HalaqaRemoteDataSource>(),
        localDataSource: gh<_i796.HalaqaLocalDataSource>(),
        networkInfo: gh<_i672.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i963.StudentSyncService>(
      () => _i691.StudentSyncServiceImpl(
        remoteDataSource: gh<_i1047.StudentRemoteDataSource>(),
        localDataSource: gh<_i176.StudentLocalDataSource>(),
        networkInfo: gh<_i672.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i673.HalaqaRepository>(
      () => _i53.HalaqaRepositoryImpl(
        localDataSource: gh<_i796.HalaqaLocalDataSource>(),
        syncService: gh<_i679.HalaqaSyncService>(),
      ),
    );
    gh.lazySingleton<_i622.TeacherRepository>(
      () => _i576.TeacherRepositoryImpl(
        localDataSource: gh<_i109.TeacherLocalDataSource>(),
        syncService: gh<_i387.TeacherSyncService>(),
      ),
    );
    gh.lazySingleton<_i281.SetTeacherStatusUseCase>(
      () => _i281.SetTeacherStatusUseCase(gh<_i622.TeacherRepository>()),
    );
    gh.lazySingleton<_i1045.GetAllUsersUseCase>(
      () => _i1045.GetAllUsersUseCase(gh<_i424.AuthRepository>()),
    );
    gh.lazySingleton<_i741.SwitchUserUseCase>(
      () => _i741.SwitchUserUseCase(gh<_i424.AuthRepository>()),
    );
    gh.factory<_i426.ForgetPasswordUseCase>(
      () => _i426.ForgetPasswordUseCase(gh<_i424.AuthRepository>()),
    );
    gh.factory<_i250.LogInUseCase>(
      () => _i250.LogInUseCase(gh<_i424.AuthRepository>()),
    );
    gh.factory<_i871.LogOutUseCase>(
      () => _i871.LogOutUseCase(gh<_i424.AuthRepository>()),
    );
    gh.lazySingleton<_i960.ChangePasswordUseCase>(
      () => _i960.ChangePasswordUseCase(gh<_i424.AuthRepository>()),
    );
    gh.lazySingleton<_i186.CheckLogInUseCase>(
      () => _i186.CheckLogInUseCase(gh<_i424.AuthRepository>()),
    );
    gh.lazySingleton<_i334.ResendVerificationEmailUseCase>(
      () => _i334.ResendVerificationEmailUseCase(gh<_i424.AuthRepository>()),
    );
    gh.factory<_i2.ErrorAnalysisChartBloc>(
      () => blocModule.errorAnalysisChartBloc(
        gh<_i618.GetErrorAnalysisChartData>(),
      ),
    );
    gh.lazySingleton<_i708.DeleteTeacherUseCase>(
      () => _i708.DeleteTeacherUseCase(gh<_i622.TeacherRepository>()),
    );
    gh.lazySingleton<_i974.FetchMoreTeachersUseCase>(
      () => _i974.FetchMoreTeachersUseCase(gh<_i622.TeacherRepository>()),
    );
    gh.lazySingleton<_i156.GetTeacherById>(
      () => _i156.GetTeacherById(gh<_i622.TeacherRepository>()),
    );
    gh.lazySingleton<_i691.UpsertTeacher>(
      () => _i691.UpsertTeacher(gh<_i622.TeacherRepository>()),
    );
    gh.lazySingleton<_i421.SupervisorRepository>(
      () => _i10.SupervisorRepositoryImpl(
        localDataSource: gh<_i510.SupervisorLocalDataSource>(),
        remoteDataSource: gh<_i945.SupervisorRemoteDataSource>(),
        timelineBuilder: gh<_i651.TimelineBuilderImpl>(),
      ),
    );
    gh.lazySingleton<_i344.StudentRepository>(
      () => _i971.StudentRepositoryImpl(
        localDataSource: gh<_i176.StudentLocalDataSource>(),
        remoteDataSource: gh<_i1047.StudentRemoteDataSource>(),
        syncService: gh<_i963.StudentSyncService>(),
      ),
    );
    gh.factory<_i708.AuthBloc>(
      () => blocModule.authBloc(
        gh<_i250.LogInUseCase>(),
        gh<_i186.CheckLogInUseCase>(),
        gh<_i871.LogOutUseCase>(),
        gh<_i426.ForgetPasswordUseCase>(),
        gh<_i960.ChangePasswordUseCase>(),
        gh<_i1045.GetAllUsersUseCase>(),
        gh<_i741.SwitchUserUseCase>(),
        gh<_i334.ResendVerificationEmailUseCase>(),
      ),
    );
    gh.lazySingleton<_i67.GetDateRangeUseCase>(
      () => _i67.GetDateRangeUseCase(
        repository: gh<_i421.SupervisorRepository>(),
      ),
    );
    gh.lazySingleton<_i494.GetEntitiesCountsUseCase>(
      () => _i494.GetEntitiesCountsUseCase(
        repository: gh<_i421.SupervisorRepository>(),
      ),
    );
    gh.lazySingleton<_i171.GetTimelineUseCase>(
      () => _i171.GetTimelineUseCase(
        repository: gh<_i421.SupervisorRepository>(),
      ),
    );
    gh.lazySingleton<_i948.SetHalaqaStatusUseCase>(
      () => _i948.SetHalaqaStatusUseCase(gh<_i673.HalaqaRepository>()),
    );
    gh.factory<_i42.ExportFollowUpReportsUseCase>(
      () => _i42.ExportFollowUpReportsUseCase(gh<_i344.StudentRepository>()),
    );
    gh.factory<_i204.ImportFollowUpReportsUseCase>(
      () => _i204.ImportFollowUpReportsUseCase(gh<_i344.StudentRepository>()),
    );
    gh.lazySingleton<_i532.DeleteStudentUseCase>(
      () => _i532.DeleteStudentUseCase(gh<_i344.StudentRepository>()),
    );
    gh.lazySingleton<_i956.FetchMoreStudentsUseCase>(
      () => _i956.FetchMoreStudentsUseCase(gh<_i344.StudentRepository>()),
    );
    gh.lazySingleton<_i1039.FetchFilteredStudentsUseCase>(
      () => _i1039.FetchFilteredStudentsUseCase(gh<_i344.StudentRepository>()),
    );
    gh.lazySingleton<_i843.GetStudentById>(
      () => _i843.GetStudentById(gh<_i344.StudentRepository>()),
    );
    gh.lazySingleton<_i41.UpsertStudent>(
      () => _i41.UpsertStudent(gh<_i344.StudentRepository>()),
    );
    gh.lazySingleton<_i268.WatchHalaqasUseCase>(
      () => _i268.WatchHalaqasUseCase(repository: gh<_i673.HalaqaRepository>()),
    );
    gh.lazySingleton<_i82.WatchTeachersUseCase>(
      () =>
          _i82.WatchTeachersUseCase(repository: gh<_i622.TeacherRepository>()),
    );
    gh.lazySingleton<_i249.FetchMoreHalaqasUseCase>(
      () => _i249.FetchMoreHalaqasUseCase(gh<_i673.HalaqaRepository>()),
    );
    gh.lazySingleton<_i465.FetchFilteredHalaqasUseCase>(
      () => _i465.FetchFilteredHalaqasUseCase(gh<_i673.HalaqaRepository>()),
    );
    gh.lazySingleton<_i951.GetHalaqaById>(
      () => _i951.GetHalaqaById(gh<_i673.HalaqaRepository>()),
    );
    gh.lazySingleton<_i871.DeleteHalaqaUseCase>(
      () => _i871.DeleteHalaqaUseCase(gh<_i673.HalaqaRepository>()),
    );
    gh.lazySingleton<_i478.UpsertHalaqa>(
      () => _i478.UpsertHalaqa(gh<_i673.HalaqaRepository>()),
    );
    gh.lazySingleton<_i581.SetStudentStatusUseCase>(
      () => _i581.SetStudentStatusUseCase(gh<_i344.StudentRepository>()),
    );
    gh.factory<_i447.ApproveApplicantUseCase>(
      () => _i447.ApproveApplicantUseCase(gh<_i421.SupervisorRepository>()),
    );
    gh.factory<_i345.GetApplicantProfileUseCase>(
      () => _i345.GetApplicantProfileUseCase(gh<_i421.SupervisorRepository>()),
    );
    gh.factory<_i178.RejectApplicantUseCase>(
      () => _i178.RejectApplicantUseCase(gh<_i421.SupervisorRepository>()),
    );
    gh.lazySingleton<_i578.WatchStudentsUseCase>(
      () =>
          _i578.WatchStudentsUseCase(repository: gh<_i344.StudentRepository>()),
    );
    gh.factory<_i257.GetApplicantsUseCase>(
      () => _i257.GetApplicantsUseCase(gh<_i421.SupervisorRepository>()),
    );
    gh.factory<_i790.SettingsBloc>(
      () => blocModule.settingsBloc(
        gh<_i24.GetSettings>(),
        gh<_i1062.SaveTheme>(),
        gh<_i256.SetNotificationsPreference>(),
        gh<_i892.SetAnalyticsPreference>(),
        gh<_i117.GetUserProfile>(),
        gh<_i957.UpdateUserProfile>(),
        gh<_i356.GetLatestPolicyUseCase>(),
        gh<_i710.ImportDataUseCase>(),
        gh<_i273.ExportDataUseCase>(),
        gh<_i1001.GetFaqsUseCase>(),
        gh<_i402.SubmitSupportTicketUseCase>(),
        gh<_i830.GetTermsOfUseUseCase>(),
        gh<_i42.ExportFollowUpReportsUseCase>(),
        gh<_i204.ImportFollowUpReportsUseCase>(),
      ),
    );
    gh.lazySingleton<_i298.GenerateFollowUpReportUseCase>(
      () => _i298.GenerateFollowUpReportUseCase(
        gh<_i344.StudentRepository>(),
        gh<_i981.FollowUpReportFactory>(),
      ),
    );
    gh.factory<_i639.TeacherBloc>(
      () => blocModule.teacherBloc(
        gh<_i82.WatchTeachersUseCase>(),
        gh<_i974.FetchMoreTeachersUseCase>(),
        gh<_i691.UpsertTeacher>(),
        gh<_i708.DeleteTeacherUseCase>(),
        gh<_i156.GetTeacherById>(),
        gh<_i281.SetTeacherStatusUseCase>(),
      ),
    );
    gh.factory<_i728.HalaqaBloc>(
      () => blocModule.halaqaBloc(
        gh<_i268.WatchHalaqasUseCase>(),
        gh<_i249.FetchMoreHalaqasUseCase>(),
        gh<_i465.FetchFilteredHalaqasUseCase>(),
        gh<_i478.UpsertHalaqa>(),
        gh<_i871.DeleteHalaqaUseCase>(),
        gh<_i951.GetHalaqaById>(),
        gh<_i948.SetHalaqaStatusUseCase>(),
      ),
    );
    gh.factory<_i234.SupervisorBloc>(
      () => blocModule.supervisorBloc(
        gh<_i171.GetTimelineUseCase>(),
        gh<_i67.GetDateRangeUseCase>(),
        gh<_i494.GetEntitiesCountsUseCase>(),
        gh<_i257.GetApplicantsUseCase>(),
        gh<_i345.GetApplicantProfileUseCase>(),
        gh<_i447.ApproveApplicantUseCase>(),
        gh<_i178.RejectApplicantUseCase>(),
      ),
    );
    gh.factory<_i73.StudentBloc>(
      () => blocModule.studentBloc(
        gh<_i578.WatchStudentsUseCase>(),
        gh<_i956.FetchMoreStudentsUseCase>(),
        gh<_i1039.FetchFilteredStudentsUseCase>(),
        gh<_i41.UpsertStudent>(),
        gh<_i532.DeleteStudentUseCase>(),
        gh<_i843.GetStudentById>(),
        gh<_i581.SetStudentStatusUseCase>(),
        gh<_i298.GenerateFollowUpReportUseCase>(),
      ),
    );
    return this;
  }
}

class _$BlocModule extends _i31.BlocModule {}

class _$RegisterModule extends _i644.RegisterModule {}
