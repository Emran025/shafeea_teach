import 'package:shafeea/core/l10n/app_strings.dart' as L10nStrings;
// path: lib/features/settings/presentation/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shafeea/features/settings/presentation/screens/profile_screen.dart';

import 'data_management_screen.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/modern_setting_tile.dart';
import '../widgets/settings_group_widget.dart';
import '../widgets/theme_switcher_widget.dart';
import 'faq_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_of_use_screen.dart';

/// The main UI screen for the application settings feature.
///
/// This widget is a "dumb" component, meaning it contains no business logic.
/// Its sole responsibility is to render the UI based on the current [SettingsState]
/// and to dispatch [SettingsEvent]s to the [SettingsBloc] in response to
/// user interactions.
class SettingsScreen extends StatefulWidget {
  /// Creates a const instance of the settings screen.
  SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    // Retrieve theme data once for reuse, improving readability.
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        // The user-facing title remains in its original language.
        title: Text(L10nStrings.AppStrings.settings),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        // Using a zero-height bottom to ensure a clean look with CustomScrollView
        bottom: PreferredSize(preferredSize: Size.zero, child: Container()),
      ),
      // BlocBuilder is the core of the reactive UI. It listens to state changes
      // from the SettingsBloc and rebuilds the widget tree accordingly.
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          // State 1: A catastrophic failure occurred while loading initial data.
          // Display a full-screen error message.
          if (state is SettingsLoadFailure) {
            return Center(
              child: Text('خطأ في تحميل الإعدادات: ${state.failure.message}'),
            );
          }

          // State 2: Data is loading (either initial or subsequent).
          // Display a central loading indicator. This covers `SettingsInitial`.
          if (state is! SettingsLoadSuccess) {
            return Center(child: CircularProgressIndicator());
          }

          // State 3: Data has been successfully loaded.
          // Render the main content of the settings screen.
          return _buildSettingsContent(context, state, colorScheme);
        },
      ),
    );
  }

  /// Builds the main scrollable content of the settings screen.
  ///
  /// This private helper method is extracted for clarity and separation of concerns.
  /// It takes the successfully loaded state and constructs the UI accordingly.
  Widget _buildSettingsContent(
    BuildContext context,
    SettingsLoadSuccess state,
    ColorScheme colorScheme,
  ) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SettingsGroup(
            title: L10nStrings.AppStrings.appearance,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ThemeSwitcherWidget(
                  // Data binding: The widget's value is driven by the BLoC state.
                  currentTheme: state.settings.themeType,
                  // Event dispatching: User interactions trigger events to the BLoC.
                  onThemeSelected: (newTheme) {
                    setState(() {
                      context.read<SettingsBloc>().add(ThemeChanged(newTheme));
                    });
                  },
                ),
              ),
            ],
          ),
        ),

        // --- Account Group ---
        SliverToBoxAdapter(
          child: SettingsGroup(
            title: L10nStrings.AppStrings.accountSection,
            children: [
              ModernSettingTile(
                icon: Icons.person_outline,
                iconBackgroundColor: Colors.blue,
                title: L10nStrings.AppStrings.profile,
                subtitle: L10nStrings.AppStrings.viewProfileSessionsEditPassword,
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  context.read<SettingsBloc>().add(LoadUserProfile());
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => ProfileScreen()),
                  );
                },
              ),
            ],
          ),
        ),

        // --- Preferences Group ---
        SliverToBoxAdapter(
          child: SettingsGroup(
            title: L10nStrings.AppStrings.notificationsAndAlerts,
            children: [
              ModernSettingTile(
                icon: Icons.notifications_outlined,
                iconBackgroundColor: Colors.orange,
                title: L10nStrings.AppStrings.enableNotifications,
                subtitle: L10nStrings.AppStrings.receiveLessonAndUpdateAlerts,
                trailing: Switch(
                  value: state.settings.notificationsEnabled,
                  onChanged: (value) {
                    context.read<SettingsBloc>().add(
                      NotificationsPreferenceChanged(value),
                    );
                  },
                  activeColor: colorScheme.primary,
                ),
                // UX Improvement: The entire row is tappable to toggle the switch.
                onTap: () {
                  final currentValue = state.settings.notificationsEnabled;
                  context.read<SettingsBloc>().add(
                    NotificationsPreferenceChanged(!currentValue),
                  );
                },
              ),
            ],
          ),
        ),

        SliverToBoxAdapter(
          child: SettingsGroup(
            title: L10nStrings.AppStrings.dataCenter,
            children: [
              ModernSettingTile(
                icon: Icons.storage_outlined,
                iconBackgroundColor: Colors.indigo,
                title: L10nStrings.AppStrings.dataManagement,
                subtitle: L10nStrings.AppStrings.importExportAppData,
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<SettingsBloc>(context),
                        child: DataManagementScreen(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: SettingsGroup(
            title: L10nStrings.AppStrings.supportAndPrivacy,
            children: [
              ModernSettingTile(
                icon: Icons.analytics_outlined,
                iconBackgroundColor: Colors.purple,
                title: L10nStrings.AppStrings.dataAnalysis,
                subtitle: L10nStrings.AppStrings.contributeToImprovingApp,
                trailing: Switch(
                  value: state.settings.analyticsEnabled,
                  onChanged: (value) {
                    context.read<SettingsBloc>().add(
                      AnalyticsPreferenceChanged(value),
                    );
                  },
                  activeColor: colorScheme.primary,
                ),
                onTap: () {
                  final currentValue = state.settings.analyticsEnabled;
                  context.read<SettingsBloc>().add(
                    AnalyticsPreferenceChanged(!currentValue),
                  );
                },
              ),
              ModernSettingTile(
                icon: Icons.description_outlined,
                iconBackgroundColor: Colors.grey,
                title: L10nStrings.AppStrings.termsOfUse,
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  context.read<SettingsBloc>().add(LoadTermsOfUse());
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<SettingsBloc>(context),
                        child: TermsOfUseScreen(),
                      ),
                    ),
                  );
                },
              ),
              ModernSettingTile(
                icon: Icons.privacy_tip_outlined,
                iconBackgroundColor: Colors.indigoAccent,
                title: L10nStrings.AppStrings.privacyPolicy,
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // --- START OF UPDATED CODE ---

                  // 1. Dispatch the event to tell the BLoC to start fetching the data.
                  context.read<SettingsBloc>().add(LoadPrivacyPolicy());

                  // 2. Immediately navigate to the policy screen.
                  //    The screen itself will handle showing the loading indicator.
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        // Provide the existing BLoC instance to the new screen
                        // so it can listen to the state changes we just triggered.
                        value: BlocProvider.of<SettingsBloc>(context),
                        child: PrivacyPolicyScreen(),
                      ),
                    ),
                  );
                  // --- END OF UPDATED CODE ---
                },
              ),
              Builder(
                builder: (context) {
                  return ModernSettingTile(
                    icon: Icons.help_outline,
                    iconBackgroundColor: Colors.green,
                    title: L10nStrings.AppStrings.helpAndSupport,
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: BlocProvider.of<SettingsBloc>(context),
                            child: FaqScreen(),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        // Provides bottom padding for better visual spacing when scrolled to the end.
        SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}
