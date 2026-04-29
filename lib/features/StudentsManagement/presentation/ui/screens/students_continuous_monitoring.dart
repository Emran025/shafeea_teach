import 'package:flutter/material.dart';
import 'package:shafeea/core/models/monitoring_filter.dart';
import 'package:shafeea/shared/themes/app_theme.dart';
import 'package:shafeea/core/models/report_frequency.dart';
import 'package:shafeea/shared/func/date_format.dart';

import 'package:shafeea/shared/widgets/frequency_selector.dart';
import 'package:shafeea/shared/widgets/horizontal_calendar_date_picker.dart';

import '../widgets/student_list_card_with_options.dart';

/// صفحة المراقبة المستمرة للطلاب.
///
/// تُظهر هذه الصفحة قائمة الطلاب المجدول لهم رفع تقاريرهم في التاريخ
/// المحدد بناءً على تكرار خطة المتابعة الخاصة بكل طالب، مع تصنيفهم إلى:
///   - المتوقع : طلاب يفترض رفع تقريرهم في هذا اليوم (بحسب الخطة).
///   - المرسل  : طلاب رفعوا التقرير فعلاً.
///   - المتبقي : طلاب لم يُرفع تقريرهم بعد رغم حلول موعده.
class StudentsContinuousMonitoring extends StatefulWidget {
  const StudentsContinuousMonitoring({super.key});

  @override
  State<StudentsContinuousMonitoring> createState() =>
      _StudentsContinuousMonitoringState();
}

class _StudentsContinuousMonitoringState
    extends State<StudentsContinuousMonitoring>
    with TickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  Frequency _freq = Frequency.daily;

  late TabController _tabController;

  // أعداد الطلاب لكل تبويب — تُحدَّث عند تغيير الفلتر.
  int _expectedCount = 0;
  int _sentCount = 0;
  int _remainingCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;

    return Column(
        children: [
          const SizedBox(height: 8),

          // ── مُحدِّد التكرار (يومي / أسبوعي / ...) ──
          Selector(
            items: Frequency.values.map((e) => e.labelAr).toList(),
            selected: _freq.labelAr,
            onChanged: (freqId) {
              // freqId هو الـ index+1 (أي id للـ Frequency)
              setState(() {
                _freq = Frequency.fromId(freqId);
              });
            },
          ),

          // ── منتقي التاريخ الأفقي ──
          HorizontalCalendarDatePicker(
            startDate: DateTime.now().subtract(const Duration(days: 60)),
            endDate: DateTime.now().add(const Duration(days: 60)),
            initialDate: DateTime.now(),
            onDateSelected: (date) {
              setState(() => selectedDate = date);
            },
          ),

          Expanded(
            child: CustomScrollView(
              physics: const NeverScrollableScrollPhysics(),
              slivers: [
                // ── عنوان التقرير ──
                SliverToBoxAdapter(
                  child: _buildSectionHeader(
                    'تقرير ${_freq.labelAr} المفترض رفعه يوم ${formatDate(selectedDate)}',
                  ),
                ),

                // ── التبويبات مع الأعداد الحيّة ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: accent,
                      dividerColor: Colors.black12,
                      unselectedLabelColor: AppColors.lightCream54,
                      padding: const EdgeInsets.only(top: 16.0),
                      tabs: [
                        _buildTab(
                          icon: Icons.schedule,
                          label: 'المتوقع',
                          count: _expectedCount,
                          filter: MonitoringFilter.expected,
                        ),
                        _buildTab(
                          icon: Icons.upload_rounded,
                          label: 'المرسل',
                          count: _sentCount,
                          filter: MonitoringFilter.sent,
                        ),
                        _buildTab(
                          icon: Icons.person_off_outlined,
                          label: 'المتبقي',
                          count: _remainingCount,
                          filter: MonitoringFilter.remaining,
                        ),
                      ],
                    ),
                  ),
                ),

                // ── محتوى التبويبات ──
                SliverFillRemaining(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 5,
                    ),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // المتوقع
                        _MonitoringTabView(
                          trackDate: selectedDate,
                          frequencyCode: _freq,
                          monitoringFilter: MonitoringFilter.expected,
                          onCountUpdated: (c) =>
                              setState(() => _expectedCount = c),
                        ),
                        // المرسل
                        _MonitoringTabView(
                          trackDate: selectedDate,
                          frequencyCode: _freq,
                          monitoringFilter: MonitoringFilter.sent,
                          onCountUpdated: (c) => setState(() => _sentCount = c),
                        ),
                        // المتبقي
                        _MonitoringTabView(
                          trackDate: selectedDate,
                          frequencyCode: _freq,
                          monitoringFilter: MonitoringFilter.remaining,
                          onCountUpdated: (c) =>
                              setState(() => _remainingCount = c),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
  }

  // ── helpers ───────────────────────────────────────────────────────────────

  Widget _buildTab({
    required IconData icon,
    required String label,
    required int count,
    required MonitoringFilter filter,
  }) {
    return Tab(
      icon: Icon(icon, color: AppColors.accent),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge!),
          const SizedBox(width: 6),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              '($count)',
              key: ValueKey(count),
              style: Theme.of(context).textTheme.bodyLarge!,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, left: 8, right: 8),
      child: Text(text, style: Theme.of(context).textTheme.bodyLarge!),
    );
  }
}

// =============================================================================
// _MonitoringTabView — واجهة منعزلة لكل تبويب مع BLoC خاص بها
// =============================================================================

/// تبويب منعزل يمتلك BLoC خاصاً به حتى لا يتشارك الحالة مع التبويبات الأخرى.
///
/// عند الانتهاء من تحميل البيانات، يُخطر الـ callback [onCountUpdated] بالعدد
/// الجديد ليُعرض في التبويب.
class _MonitoringTabView extends StatelessWidget {
  final DateTime trackDate;
  final Frequency frequencyCode;
  final MonitoringFilter monitoringFilter;
  final void Function(int count) onCountUpdated;

  const _MonitoringTabView({
    required this.trackDate,
    required this.frequencyCode,
    required this.monitoringFilter,
    required this.onCountUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return StudentListCardWithOptions(
      trackDate: trackDate,
      frequencyCode: frequencyCode,
      monitoringFilter: monitoringFilter,
      onCountUpdated: onCountUpdated,
    );
  }
}
