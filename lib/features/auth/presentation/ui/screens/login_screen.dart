import 'package:shafeea/core/l10n/app_strings.dart' as L10nStrings;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shafeea/shared/themes/app_theme.dart';
import 'package:shafeea/features/auth/presentation/ui/screens/forget_password_screen.dart';

import '../../../../../shared/widgets/custom_button.dart';
import '../../bloc/auth_bloc.dart';
// تأكد من مسار الكائن UserEntity
import 'package:shafeea/features/auth/domain/entities/user_entity.dart';

// import '../../../../../core/constants/app_colors.dart';

class LogInScreen extends StatefulWidget {
  LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // جلب قائمة المستخدمين المخزنين عند فتح الشاشة
    context.read<AuthBloc>().add(GetAllUsersRequested());
  }

  void _submitLogIn(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LogInRequested(
          logIn: emailController.text.trim(),
          password: passwordController.text.trim(),
        ),
      );
    }
  }

  // دالة لمعالجة تبديل المستخدم عند الضغط على الأيقونة
  void _onUserTapped(UserEntity user) {
    // يمكنك هنا الاختيار بين أمرين:
    // 1. ملء الحقول فقط (إذا أردت منه إدخال كلمة المرور مرة أخرى).
    // emailController.text = user.email ?? '';

    // 2. أو التبديل المباشر وتسجيل الدخول (وهو ما تم بناء الـ Logic عليه سابقاً)
    // نفترض أن UserEntity يحتوي على حقل id
    // تأكد من أن الـ id موجود، هنا سنفترض أنه String
    // إذا كان الـ id في الـ Entity رقم (int) قم بتحويله: user.id.toString()

    // سنستخدم التبديل المباشر كما طلب في الـ Logic السابق
    context.read<AuthBloc>().add(
      SwitchUserRequested(userId: user.id.toString()),
    );
  }

  InputDecoration _inputDecoration(
    String label,
    IconData icon, {
    bool isPassword = false,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.lightCream70),
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                color: AppColors.lightCream70,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            )
          : null,
      filled: true,
      fillColor: AppColors.lightCream.withOpacity(0.1),
      labelStyle: TextStyle(color: AppColors.lightCream, fontSize: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.lightCream26),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.lightCream),
      ),
      errorStyle: TextStyle(color: Colors.amber),
    );
  }

  // ودجت لعرض قائمة المستخدمين السابقين
  Widget _buildCachedUsersList(BuildContext context, AuthState state) {
    // إذا كانت الحالة تحميل للقائمة، نعرض مؤشر صغير
    if (state.usersListStatus == GetUserStatus.loading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.lightCream,
            ),
          ),
        ),
      );
    }

    // إذا لم يكن هناك مستخدمين، نخفي القسم
    if (state.usersList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 12.0),
            child: Text(
              L10nStrings.AppStrings.changeAccount,
              style: TextStyle(color: AppColors.lightCream70, fontSize: 12),
            ),
          ),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: state.usersList.length,
              separatorBuilder: (c, i) => SizedBox(width: 16),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final user = state.usersList[index];
                final isSelected = state.selectedUser?.id == user.id;

                return GestureDetector(
                  onTap: () => _onUserTapped(user),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2), // Border width
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.accent
                                : AppColors.lightCream26,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 26,
                          backgroundColor: AppColors.lightCream,
                          child: Text(
                            user.name.split('').first,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.mediumDark,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 6),
                      SizedBox(
                        width: 70,
                        child: Text(
                          user.name,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.accent
                                : AppColors.lightCream,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          Divider(
            color: AppColors.lightCream12,
            endIndent: 40,
            indent: 40,
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.ltr, // أو TextDirection.rtl حسب لغة التطبيق
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.accent, AppColors.mediumDark],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 600),
                    curve: Curves.easeOut,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.lightCream12,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.lightCream26),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.darkBackground26,
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Hero(
                            tag: 'logo',
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.lightCream,
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                'assets/images/logo.png',
                                width: size.width * 0.30,
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          Text(
                            L10nStrings.AppStrings.logIn,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.lightCream,
                            ),
                          ),
                          SizedBox(height: 24),

                          // --- إضافة قائمة المستخدمين هنا ---
                          BlocBuilder<AuthBloc, AuthState>(
                            buildWhen: (previous, current) =>
                                previous.usersList != current.usersList ||
                                previous.usersListStatus !=
                                    current.usersListStatus ||
                                previous.selectedUser != current.selectedUser,
                            builder: (context, state) {
                              return _buildCachedUsersList(context, state);
                            },
                          ),

                          // -------------------------------
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.text,
                            style: TextStyle(color: AppColors.lightCream),
                            validator: (val) {
                              final value = val?.trim() ?? '';
                              if (value.isEmpty) {
                                return L10nStrings.AppStrings.enterEmailOrUsername;
                              }
                              if (value.contains('@')) {
                                return value.contains('.')
                                    ? null
                                    : L10nStrings.AppStrings.invalidEmailAddress;
                              }
                              if (value.length >= 3) return null;
                              return L10nStrings.AppStrings.invalidEmailOrUsername;
                            },
                            decoration: _inputDecoration(
                              L10nStrings.AppStrings.emailOrUsername,
                              Icons.person_outline,
                            ),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: passwordController,
                            obscureText: _obscurePassword,
                            style: TextStyle(color: AppColors.lightCream),
                            validator: (val) =>
                                (val != null && val.trim().length >= 6)
                                ? null
                                : L10nStrings.AppStrings.passwordTooShort,
                            decoration: _inputDecoration(
                              L10nStrings.AppStrings.password,
                              Icons.lock,
                              isPassword: true,
                            ),
                          ),

                          SizedBox(height: 24),
                          BlocConsumer<AuthBloc, AuthState>(
                            listener: (context, state) {
                              if (state.status == LogInStatus.success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(L10nStrings.AppStrings.loggedIn),
                                  ),
                                );
                                context.go('/splash');
                              } else if (state.status == LogInStatus.failure) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      state.failure?.message ?? L10nStrings.AppStrings.somethingWentWrong,
                                    ),
                                  ),
                                );
                              }
                            },
                            builder: (context, state) {
                              return state.status == LogInStatus.loading
                                  ? CircularProgressIndicator(
                                      color: AppColors.lightCream,
                                    )
                                  : CustomButton(
                                      text: L10nStrings.AppStrings.logIn,
                                      onPressed: () => _submitLogIn(context),
                                    );
                            },
                          ),

                          SizedBox(height: 12),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ForgetPasswordScreen(),
                                ),
                              );
                            },
                            child: Text(
                              L10nStrings.AppStrings.forgotPasswordQuestion,
                              style: TextStyle(color: AppColors.lightCream70),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
