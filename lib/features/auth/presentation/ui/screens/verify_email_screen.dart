import 'package:shafeea/core/l10n/app_strings.dart' as L10nStrings;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shafeea/features/auth/presentation/bloc/auth_bloc.dart';

/// Shown when the authenticated user has not yet verified their email address.
///
/// Provides:
///  - A clear status indicator (pending verification)
///  - A "Resend Email" action that dispatches [ResendVerificationEmailRequested]
///  - A "Check Again" action that refreshes auth state (in case user verified in browser)
///  - A logout action
class VerifyEmailScreen extends StatefulWidget {
  VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _resendEmail() {
    context.read<AuthBloc>().add(ResendVerificationEmailRequested());
  }

  void _checkVerificationStatus() {
    context.read<AuthBloc>().add(CheckVerificationStatusRequested());
  }

  void _logout() {
    context.read<AuthBloc>().add(
      LogOutRequested(message: 'User logout', deleteCredentials: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.verificationStatus == VerificationStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(L10nStrings.AppStrings.activationLinkResent)),
          );
        }
        if (state.verificationStatus == VerificationStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.verificationFailure?.message ?? L10nStrings.AppStrings.failedToSend,
              ),
            ),
          );
        }
        if (state.authStatus == AuthStatus.unauthenticated) {
          context.go('/login'); // Or welcome screen
        }

        // If user is verified, the router guard (or a listener in the main app)
        // should ideally handle the transition to home.
        if (state.user?.isEmailVerified ?? false) {
          context.go('/home');
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xFF0F172A),
        body: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 32),

                  // ── Animated Email Icon ──
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF0EA5E9).withOpacity(0.4),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.mark_email_unread_rounded,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),

                  SizedBox(height: 32),

                  // ── Title ──
                  Text(
                    L10nStrings.AppStrings.verifyEmailTeacher,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 12),

                  Text(
                    '${L10nStrings.AppStrings.activationLinkSentEmail} ${L10nStrings.AppStrings.clickLinkInEmailToContinue}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                      height: 1.7,
                      fontFamily: 'Cairo',
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 32),

                  // ── Status Card ──
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF0EA5E9).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Color(0xFF0EA5E9).withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: Color(0xFF38BDF8),
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            L10nStrings.AppStrings.awaitingConfirmationCheckInboxSpam,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 13,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32),

                  // ── Resend Button ──
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading =
                          state.verificationStatus ==
                          VerificationStatus.loading;
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: isLoading ? null : _resendEmail,
                          icon: isLoading
                              ? SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(Icons.refresh_rounded),
                          label: Text(
                            isLoading
                                ? L10nStrings.AppStrings.sendingInProgress
                                : L10nStrings.AppStrings.resendActivationLink,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF0EA5E9),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 12),

                  // ── Check Again Button ──
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _checkVerificationStatus,
                      icon: Icon(Icons.sync_rounded, size: 18),
                      label: Text(
                        L10nStrings.AppStrings.verifiedUpdateStatus,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white70,
                        side: BorderSide(color: Colors.white24),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 12),

                  // ── Logout ──
                  TextButton.icon(
                    onPressed: _logout,
                    icon: Icon(
                      Icons.logout_rounded,
                      size: 16,
                      color: Colors.white38,
                    ),
                    label: Text(
                      L10nStrings.AppStrings.logOut,
                      style: TextStyle(
                        color: Colors.white38,
                        fontFamily: 'Cairo',
                        fontSize: 13,
                      ),
                    ),
                  ),

                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
