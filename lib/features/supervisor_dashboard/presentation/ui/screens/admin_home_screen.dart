import 'package:shafeea_teach/core/l10n/app_strings.dart';
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

import 'package:shafeea/core/constants/constants.dart';

class SupervisorDashboard extends StatefulWidget {
  const SupervisorDashboard({super.key});

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
    headers.add(AppStrings.str_teach_rem_348_f98d);
    _navItems.add(const BottomNavigationBarItem(
      icon: Icon(Icons.dashboard_outlined),
      label: AppStrings.str_teach_rem_348_f98d,
    ));

    // School Admin or Teachers Supervisor
    if (roles.contains('school_admin') || roles.contains('teachers_supervisor')) {
      _tabs.add(TeachersManagementScreen());
      headers.add(AppStrings.str_teach_rem_349_ca37);
      _navItems.add(const BottomNavigationBarItem(
        icon: Icon(Icons.school_outlined),
        label: AppStrings.str_teach_rem_4_faa1,
      ));
    }

    // School Admin or Students Supervisor
    if (roles.contains('school_admin') || roles.contains('students_supervisor')) {
      _tabs.add(StudentsManagementScreen());
      headers.add(AppStrings.str_teach_rem_350_78f1);
      _navItems.add(const BottomNavigationBarItem(
        icon: Icon(Icons.group_outlined),
        label: AppStrings.str_teach_rem_6_36bc,
      ));
    }

    // School Admin or Halaqah Supervisor
    if (roles.contains('school_admin') || roles.contains('halaqah_supervisor')) {
      _tabs.add(HalaqaManagementScreen());
      headers.add(AppStrings.str_teach_rem_351_7511);
      _navItems.add(const BottomNavigationBarItem(
        icon: Icon(Icons.book_outlined),
        label: AppStrings.str_teach_rem_5_f960,
      ));
    }

    // School Admin or Reports Supervisor
    if (roles.contains('school_admin') || roles.contains('reports_supervisor')) {
      _tabs.add(MonitoringScreen());
      headers.add(AppStrings.str_teach_rem_352_2e3b);
      _navItems.add(const BottomNavigationBarItem(
        icon: Icon(Icons.analytics_outlined),
        label: AppStrings.str_teach_rem_132_5859,
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
          title: AppStrings.str_teach_rem_263_5f0f,
          avatar: Avatar(size: Size(100, 100)),
          items: [
            CustomModeIconButton(
              icon: Icons.person,
              label: AppStrings.str_teach_rem_353_8eda,
              isSelected: false,
              onTap: () {},
            ),
            CustomModeIconButton(
              icon: Icons.settings,
              label: AppStrings.str_teach_rem_307_af46,
              isSelected: false,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const SettingsScreen();
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
              label: AppStrings.str_teach_rem_200_ca2d,
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
        child: const LogoutConfirmationDialog(),
      ),
    );
  }
}
