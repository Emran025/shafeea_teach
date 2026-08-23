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
  static String get addStudentsToHalaqah => i.addStudentsToHalaqah;
  static String get showOnlyUnenrolledStudents => i.showOnlyUnenrolledStudents;
  static String get searchForStudent => i.searchForStudent;
  static String get loadingStudents => i.loadingStudents;
  static String get noUnenrolledStudents => i.noUnenrolledStudents;
  static String get cancel => i.cancel;
  static String get confirm => i.confirm;
  static String get addStudents => i.addStudents;
  static String get halaqahName => i.halaqahName;
  static String get gender => i.gender;
  static String get capacity => i.capacity;
  static String get country => i.country;
  static String get availableTime => i.availableTime;
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
