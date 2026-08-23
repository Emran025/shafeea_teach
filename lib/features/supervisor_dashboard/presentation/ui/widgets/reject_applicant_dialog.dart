import 'package:shafeea/core/l10n/app_strings.dart' as L10nStrings;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shafeea/features/supervisor_dashboard/presentation/bloc/supervisor_bloc.dart';

class RejectApplicantDialog extends StatefulWidget {
  final int applicantId;

  RejectApplicantDialog({super.key, required this.applicantId});

  @override
  State<RejectApplicantDialog> createState() => _RejectApplicantDialogState();
}

class _RejectApplicantDialogState extends State<RejectApplicantDialog> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController(
    text: L10nStrings.AppStrings.applicantRecordNotAligned,
  );

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _rejectApplicant() {
    if (_formKey.currentState!.validate()) {
      context.read<SupervisorBloc>().add(
        RejectApplicant(widget.applicantId, _reasonController.text),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SupervisorBloc, SupervisorState>(
      listener: (context, state) {
        if (state is SupervisorLoaded) {
          if (state.rejectStatus == ActionStatus.success) {
            Navigator.of(context).pop(true);
          } else if (state.rejectStatus == ActionStatus.failure) {
            Navigator.of(context).pop(false);
          }
        }
      },
      child: Dialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    L10nStrings.AppStrings.rejectApplication,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  L10nStrings.AppStrings.reasonForRejection,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onBackground.withOpacity(0.87),
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _reasonController,
                  textInputAction: TextInputAction.done,
                  maxLines: 5,
                  maxLength: 1000,
                  decoration: InputDecoration(
                    hintText: L10nStrings.AppStrings.enterRejectionReason,
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onBackground.withOpacity(0.54),
                    ),
                    prefixIcon: Icon(
                      Icons.message,
                      color: Theme.of(
                        context,
                      ).colorScheme.onBackground.withOpacity(0.54),
                    ),
                    filled: true,
                    fillColor: Theme.of(
                      context,
                    ).colorScheme.surface.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return L10nStrings.AppStrings.pleaseEnterRejectionReason;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                BlocBuilder<SupervisorBloc, SupervisorState>(
                  builder: (context, state) {
                    final isLoading =
                        state is SupervisorLoaded &&
                        state.rejectStatus == ActionStatus.loading;
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _rejectApplicant,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onError,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                L10nStrings.AppStrings.reject,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onError,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(
                        context,
                      ).colorScheme.onBackground,
                      side: BorderSide(
                        color: Theme.of(
                          context,
                        ).colorScheme.onBackground.withOpacity(0.26),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'إلغاء',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
