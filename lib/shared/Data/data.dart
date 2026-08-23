import 'package:shafeea_teach/core/l10n/app_strings.dart';
import 'package:shafeea/features/supervisor_dashboard/data/models/bar_chart_datas.dart';
import 'package:shafeea/features/supervisor_dashboard/data/models/chart_data_point.dart';
import 'package:shafeea/features/supervisor_dashboard/data/models/composite_performance_data.dart';
import 'package:shafeea/features/supervisor_dashboard/data/models/line_chart_data.dart';
import 'package:shafeea/features/supervisor_dashboard/data/models/line_chart_datas.dart';

import '../../core/models/mistake_type.dart';

/// بيانات وهمية (Mock Data) لتشغيل واختبار المخططات البيانية.

// =============================================================================
// 1. بيانات مخطط تحليل الأخطاء (Bar Chart)
//    (يستخدم في StudentErrorAnalysisChart)
// =============================================================================

final List<ChartDataPoint> mockErrorData = const [
  ChartDataPoint(value: 15, label: AppStrings.str_teach_rem_382_7bbe),
  ChartDataPoint(value: 25, label: AppStrings.str_teach_36_c74e),
  ChartDataPoint(value: 10, label: AppStrings.str_teach_rem_383_7fa0),
  ChartDataPoint(value: 5, label: AppStrings.str_teach_rem_384_1a37),
  ChartDataPoint(value: 18, label: AppStrings.str_teach_rem_385_2cef),
  ChartDataPoint(value: 12, label: AppStrings.str_teach_rem_386_cb16),
];

// =============================================================================
// 2. بيانات مخطط التقدم مقابل الخطة (Line Chart)
//    (يستخدم في StudentProgressChart)
// =============================================================================

final LineChartDatas mockProgressData = LineChartDatas(
  xAxisLabel: AppStrings.str_teach_rem_387_63d0,
  yAxisLabel: AppStrings.str_teach_rem_388_751c,
  maxY: 100,
  plannedData: const [
    ChartDataPoint(value: 10, label: AppStrings.str_teach_rem_389_0887),
    ChartDataPoint(value: 20, label: AppStrings.str_teach_rem_390_f398),
    ChartDataPoint(value: 30, label: AppStrings.str_teach_rem_391_d2cb),
    ChartDataPoint(value: 40, label: AppStrings.str_teach_rem_392_0456),
    ChartDataPoint(value: 50, label: AppStrings.str_teach_rem_393_598e),
    ChartDataPoint(value: 60, label: AppStrings.str_teach_rem_394_6059),
  ],
  actualData: const [
    ChartDataPoint(value: 8, label: AppStrings.str_teach_rem_389_0887),
    ChartDataPoint(value: 25, label: AppStrings.str_teach_rem_390_f398),
    ChartDataPoint(value: 28, label: AppStrings.str_teach_rem_391_d2cb),
    ChartDataPoint(value: 35, label: AppStrings.str_teach_rem_392_0456),
    ChartDataPoint(value: 55, label: AppStrings.str_teach_rem_393_598e),
    ChartDataPoint(value: 62, label: AppStrings.str_teach_rem_394_6059),
  ],
);

// =============================================================================
// 3. بيانات مخطط تقييم جودة الإتقان (Composite Performance Chart)
//    (يستخدم في StudentQualityAssessmentChart)
// =============================================================================

final CompositePerformanceData mockQualityData = CompositePerformanceData(
  // title: 'تقييم جودة الإتقان (شهري)',
  xAxisLabel: AppStrings.str_teach_rem_395_20ad,
  yAxisLabel: AppStrings.str_teach_rem_396_fccb,
  maxY: 100,
  performanceScores: const [
    ChartDataPoint(value: 85, label: AppStrings.str_teach_rem_397_3c78),
    ChartDataPoint(value: 92, label: AppStrings.str_teach_rem_398_3ba5),
    ChartDataPoint(value: 78, label: AppStrings.str_teach_rem_399_50db),
    ChartDataPoint(value: 95, label: AppStrings.str_teach_rem_400_8b7f),
    ChartDataPoint(value: 88, label: AppStrings.str_teach_rem_401_78b4),
    ChartDataPoint(value: 90, label: AppStrings.str_teach_rem_402_9e95),
  ],
);

// =============================================================================
// 4. بيانات مخطط الأداء العام المركب (Composite Performance Chart)
//    (يستخدم في مخطط StudentOverallPerformanceChart - لم يتم إنشاؤه بعد)
// =============================================================================

final CompositePerformanceData mockOverallPerformanceData =
    CompositePerformanceData(
      // title: 'مؤشر الأداء العام المركب (ربع سنوي)',
      xAxisLabel: AppStrings.str_teach_rem_403_2de0,
      yAxisLabel: AppStrings.str_teach_rem_404_8631,
      maxY: 100,
      performanceScores: const [
        ChartDataPoint(value: 75, label: AppStrings.str_teach_rem_405_3983),
        ChartDataPoint(value: 82, label: AppStrings.str_teach_rem_406_74bc),
        ChartDataPoint(value: 88, label: AppStrings.str_teach_rem_407_3309),
        ChartDataPoint(value: 91, label: AppStrings.str_teach_rem_408_1fd6),
      ],
    );

// =============================================================================
// 5. بيانات مخطط عدد الحفاظ (Bar Chart)
//    (يستخدم في HalqaGraduatesChart - لم يتم إنشاؤه بعد)
// =============================================================================

final BarChartDatas mockGraduatesData = BarChartDatas(
  // title: 'عدد الحفاظ المتخرجين (سنوي)',
  xAxisLabel: AppStrings.str_teach_rem_409_c96d,
  yAxisLabel: AppStrings.str_teach_rem_91_569f,
  maxY: 50,
  data: const [
    ChartDataPoint(value: 15, label: '2021'),
    ChartDataPoint(value: 22, label: '2022'),
    ChartDataPoint(value: 30, label: '2023'),
    ChartDataPoint(value: 45, label: '2024'),
  ],
);

/// بيانات وهمية (Mock Data) لتشغيل واختبار المخططات البيانية
/// توفر 12 فترة زمنية (شهر) من البيانات لكل مخطط

// =============================================================================
// دالة مساعدة لإنشاء تاريخ الفترة الزمنية
// =============================================================================

DateTime _getPeriodDate(int monthsAgo) {
  final now = DateTime.now();
  return DateTime(now.year, now.month - monthsAgo, 1);
}

// =============================================================================
// 1. بيانات مخطط تحليل الأخطاء (12 فترة شهرية)
// =============================================================================

final List<BarChartDatas> mockErrorDataPeriods = List.generate(
  12,
  (index) => BarChartDatas(
    data: [
      ChartDataPoint(
        value: 25 - (index * 1),
        label: MistakeType.pronunciation.labelAr,
      ),
      ChartDataPoint(
        value: 15 + (index * 2),
        label: MistakeType.timing.labelAr,
      ),
      ChartDataPoint(
        value: 5 + (index * 0.5),
        label: MistakeType.grammar.labelAr,
      ),
      ChartDataPoint(
        value: 18 - (index * 0.8),
        label: MistakeType.memory.labelAr,
      ),
    ],
    xAxisLabel: AppStrings.str_teach_rem_410_1829,
    yAxisLabel: AppStrings.str_teach_rem_411_aeaf,
    maxY: 50,
    periodDate: _getPeriodDate(11 - index), // من الشهر الأقدم إلى الأحدث
  ),
);

// =============================================================================
// 2. بيانات مخطط التقدم مقابل الخطة (12 فترة شهرية)
// =============================================================================

final List<LineChartData> mockProgressDataPeriods = List.generate(
  12,
  (index) => LineChartData(
    xAxisLabel: AppStrings.str_teach_rem_387_63d0,
    yAxisLabel: AppStrings.str_teach_rem_388_751c,
    maxY: 100,
    plannedData: const [
      ChartDataPoint(value: 10, label: AppStrings.str_teach_rem_389_0887),
      ChartDataPoint(value: 20, label: AppStrings.str_teach_rem_390_f398),
      ChartDataPoint(value: 30, label: AppStrings.str_teach_rem_391_d2cb),
      ChartDataPoint(value: 40, label: AppStrings.str_teach_rem_392_0456),
    ],
    actualData: [
      ChartDataPoint(value: 8 + (index * 0.5), label: AppStrings.str_teach_rem_389_0887),
      ChartDataPoint(value: 25 + (index * 0.3), label: AppStrings.str_teach_rem_390_f398),
      ChartDataPoint(value: 28 + (index * 0.8), label: AppStrings.str_teach_rem_391_d2cb),
      ChartDataPoint(value: 35 + (index * 1.2), label: AppStrings.str_teach_rem_392_0456),
    ],
    periodDate: _getPeriodDate(11 - index),
  ),
);

// =============================================================================
// 3. بيانات مخطط تقييم جودة الإتقان (12 فترة شهرية)
// =============================================================================

final List<CompositePerformanceData> mockQualityDataPeriods = List.generate(
  12,
  (index) => CompositePerformanceData(
    // title: AppStrings.str_teach_rem_366_8312,
    xAxisLabel: AppStrings.str_teach_rem_395_20ad,
    yAxisLabel: AppStrings.str_teach_rem_396_fccb,
    maxY: 100,
    performanceScores: [
      ChartDataPoint(value: 85 + (index * 0.5), label: AppStrings.str_teach_rem_397_3c78),
      ChartDataPoint(value: 92 + (index * 0.3), label: AppStrings.str_teach_rem_398_3ba5),
      ChartDataPoint(value: 78 + (index * 1.2), label: AppStrings.str_teach_rem_399_50db),
      ChartDataPoint(value: 95 - (index * 0.2), label: AppStrings.str_teach_rem_400_8b7f),
    ],
    periodDate: _getPeriodDate(11 - index),
  ),
);

// =============================================================================
// بيانات إضافية (اختيارية)
// =============================================================================
