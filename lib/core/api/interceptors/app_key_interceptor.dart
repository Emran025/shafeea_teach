import 'package:dio/dio.dart';
import 'package:shafeea/core/config/app_config.dart';

/// AppKeyInterceptor
///
/// Injects the `X-App-Key` header into every outgoing API request when the
/// application is running in School-Locked Mode.
///
/// See the student app's version for full documentation.
/// Behaviour is identical in both apps.
final class AppKeyInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (AppConfig.isSchoolLocked) {
      options.headers['X-App-Key'] = AppConfig.appKey;
    }

    return handler.next(options);
  }
}
