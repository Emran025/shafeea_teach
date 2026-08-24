import 'package:shafeea/core/l10n/app_strings.dart' as L10nStrings;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shafeea/shared/themes/app_theme.dart';
import 'package:shafeea/features/StudentsManagement/presentation/ui/screens/students_management_screen.dart';
import 'package:shafeea/features/TeachersManagement/presentation/ui/screens/teachers_management_screen.dart';
import 'package:shafeea/features/supervisor_dashboard/presentation/ui/screens/modern_dashboard_screen.dart';
import 'package:shafeea/features/supervisor_dashboard/presentation/ui/screens/supervisor_monitoring_screen.dart';
import 'package:shafeea/shared/widgets/avatar.dart';
import 'package:shafeea/shared/widgets/recitation_mode_sidebar.dart';

import '../../../../../core/models/user_role.dart';
import '../../../../HalaqasManagement/presentation/ui/screens/halaqas_management_screen.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../auth/presentation/ui/widgets/log_out_dialog.dart';
import '../../../../settings/presentation/screens/settings_screen.dart';


class SupervisorDashboard extends StatefulWidget {
  SupervisorDashboard({super.key});

  @override
  State<SupervisorDashboard> createState() => _SupervisorDashboardState();
}

class _SupervisorDashboardState extends State<SupervisorDashboard> {
  int _currentIndex = 0;
  
  // These will be dynamically populated based on roles
  List<Widget> _tabs = [];
  List<String> headers = [];
  List<BottomNavigationBarItem> _navItems = [];

  @override
  void initState() {
    super.initState();
    _buildTabsBasedOnRoles();
  }

  void _buildTabsBasedOnRoles() {
    final authState = context.read<AuthBloc>().state;
    final roles = authState.user?.roles ?? [];

    // Everyone gets the dashboard
    _tabs.add(ModernDashboardScreen(role: UserRole.supervisor));
    headers.add(L10nStrings.AppStrings.home);
    _navItems.add(BottomNavigationBarItem(
      icon: Icon(Icons.dashboard_outlined),
      label: L10nStrings.AppStrings.home,
    ));

    // School Admin or Teachers Supervisor
    if (roles.contains('school_admin') || roles.contains('teachers_supervisor')) {
      _tabs.add(TeachersManagementScreen());
      headers.add(L10nStrings.AppStrings.manageTeachers);
      _navItems.add(BottomNavigationBarItem(
        icon: Icon(Icons.school_outlined),
        label: L10nStrings.AppStrings.teachers,
      ));
    }

    // School Admin or Students Supervisor
    if (roles.contains('school_admin') || roles.contains('students_supervisor')) {
      _tabs.add(StudentsManagementScreen());
      headers.add(L10nStrings.AppStrings.manageStudents);
      _navItems.add(BottomNavigationBarItem(
        icon: Icon(Icons.group_outlined),
        label: L10nStrings.AppStrings.students,
      ));
    }

    // School Admin or Halaqah Supervisor
    if (roles.contains('school_admin') || roles.contains('halaqah_supervisor')) {
      _tabs.add(HalaqaManagementScreen());
      headers.add(L10nStrings.AppStrings.manageCircles);
      _navItems.add(BottomNavigationBarItem(
        icon: Icon(Icons.book_outlined),
        label: L10nStrings.AppStrings.halaqasLabel,
      ));
    }

    // School Admin or Reports Supervisor
    if (roles.contains('school_admin') || roles.contains('reports_supervisor')) {
      _tabs.add(MonitoringScreen());
      headers.add(L10nStrings.AppStrings.comprehensiveMonitoring);
      _navItems.add(BottomNavigationBarItem(
        icon: Icon(Icons.analytics_outlined),
        label: L10nStrings.AppStrings.followUp,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            headers[_currentIndex],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications_active_outlined, size: 30),
              onPressed: () {},
            ),
          ],
        ),

        drawer: RecitationModeSideBar(
          title: L10nStrings.AppStrings.helloImran,
          avatar: Avatar(size: Size(100, 100)),
          items: [
            CustomModeIconButton(
              icon: Icons.person,
              label: L10nStrings.AppStrings.myProfile,
              isSelected: false,
              onTap: () {},
            ),
            CustomModeIconButton(
              icon: Icons.settings,
              label: L10nStrings.AppStrings.settings,
              isSelected: false,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return SettingsScreen();
                    },
                  ),
                );
              },
            ),
            CustomModeIconButton(
              icon: Icons.security,
              label: " إدارة الصلاحيات",
              isSelected: false,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            CustomModeIconButton(
              icon: Icons.logout,
              label: L10nStrings.AppStrings.logOut,
              isSelected: false,
              onTap: () {
                Navigator.pop(context);
                // _showLoginDialog();
                _showLogoutDialog();
              },
            ),
          ],
        ),

        body: Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(child: _tabs[_currentIndex]),
        ),
        bottomNavigationBar: _navItems.length > 1 ? Container(
          padding: EdgeInsets.only(bottom: 5, top: 5),
          decoration: BoxDecoration(
            color: AppColors.mediumDark,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: AppColors.lightCream,
            unselectedItemColor: AppColors.lightCream54,
            showUnselectedLabels: true,
            onTap: (index) => setState(() => _currentIndex = index),
            items: _navItems,
          ),
        ) : null,
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: context.read<AuthBloc>(),
        child: LogoutConfirmationDialog(),
      ),
    );
  }
}
