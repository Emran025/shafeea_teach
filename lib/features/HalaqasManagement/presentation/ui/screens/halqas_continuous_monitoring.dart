import 'package:flutter/material.dart';
import 'package:shafeea/core/models/monitoring_filter.dart';
import 'package:shafeea/core/models/report_frequency.dart';
import 'package:shafeea/shared/func/date_format.dart';
import 'package:shafeea/shared/themes/app_theme.dart';
import 'package:shafeea/shared/widgets/frequency_selector.dart';
import 'package:shafeea/shared/widgets/horizontal_calendar_date_picker.dart';

import '../widgets/halaqa_list_card_with_options.dart';

/// صفحة المراقبة المستمرة للحلقات.
///
/// تُظهر الحلقات مُصنَّفةً إلى ثلاث فئات بناءً على التاريخ المحدد:
///   - المتوقع : حلقات تحتوي طالباً واحداً على الأقل مجدول تقريره اليوم.
///   - المرسل  : حلقات رُفع تقرير أحد طلابها فعلاً.
///   - المتبقي : حلقات يوجد فيها طالب مجدول ولم يُرفع تقريره بعد.
class HalaqasContinuousMonitoring extends StatefulWidget {
  const HalaqasContinuousMonitoring({super.key});

  @override
  State<HalaqasContinuousMonitoring> createState() =>
      _HalaqasContinuousMonitoringState();
}

class _HalaqasContinuousMonitoringState
    extends State<HalaqasContinuousMonitoring>
    with TickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  Frequency _freq = Frequency.daily;

  late TabController _tabController;

  // أعداد الحلقات لكل تبويب — تُحدَّث عند انتهاء تحميل البيانات.
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
            setState(() => _freq = Frequency.fromId(freqId));
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
                      ),
                      _buildTab(
                        icon: Icons.upload_rounded,
                        label: 'المرسل',
                        count: _sentCount,
                      ),
                      _buildTab(
                        icon: Icons.person_off_outlined,
                        label: 'المتبقي',
                        count: _remainingCount,
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
                      HalaqaListCardWithOptions(
                        trackDate: selectedDate,
                        frequencyCode: _freq,
                        monitoringFilter: MonitoringFilter.expected,
                        onCountUpdated: (c) =>
                            setState(() => _expectedCount = c),
                      ),
                      // المرسل
                      HalaqaListCardWithOptions(
                        trackDate: selectedDate,
                        frequencyCode: _freq,
                        monitoringFilter: MonitoringFilter.sent,
                        onCountUpdated: (c) => setState(() => _sentCount = c),
                      ),
                      // المتبقي
                      HalaqaListCardWithOptions(
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
