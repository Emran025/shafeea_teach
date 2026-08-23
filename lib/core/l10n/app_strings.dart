import 'app_strings_base.dart';
import 'app_strings_ar.dart';
import 'app_strings_en.dart';

class AppStrings {
  static AppStringsBase i = AppStringsAr();
  static String languageCode = 'ar';

  static void setLocale(String languageCode) {
    AppStrings.languageCode = languageCode;
    if (languageCode == 'en') {
      i = AppStringsEn();
    } else {
      i = AppStringsAr();
    }
  }

  static String get appName => i.appName;
  static String get supervisorDashboard => i.supervisorDashboard;
  static String get studentsList => i.studentsList;
  static String get teachersList => i.teachersList;
  static String get halaqahManagement => i.halaqahManagement;
  static String get reports => i.reports;
  static String get accept => i.accept;
  static String get reject => i.reject;
  static String get incomingCall => i.incomingCall;
  static String get markError => i.markError;
  static String get endSession => i.endSession;
}
