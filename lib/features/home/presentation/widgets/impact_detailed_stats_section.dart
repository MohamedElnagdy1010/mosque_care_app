import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ImpactDetailedStatsSection extends StatelessWidget {
  const ImpactDetailedStatsSection({super.key, this.values = const []});

  final List<double> values;
  static const categories = [
    'التكييف',
    'الكهرباء',
    'السباكة',
    'الصوتيات',
    'الفرش',
    'الأبواب',
    'الترميم',
    'النظافة',
    'المياه',
    'المرافق',
  ];

  static const demoValues = <double>[45, 32, 28, 18, 25, 14, 22, 60, 35, 16];
  @override
  Widget build(BuildContext context) {
    final chartValues = values.isEmpty ? demoValues : values;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'أثر الخدمات',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xFF604326),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            height: 240,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFAF2),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFD6A343)),
            ),
            child: chartValues.isEmpty
                ? const Center(
                    child: Text(
                      'ستظهر إحصائيات الخدمات عند توفر البيانات',
                      textAlign: TextAlign.center,
                    ),
                  )
                : BarChart(
                    BarChartData(
                      barGroups: [
                        for (var i = 0; i < chartValues.length; i++)
                          BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: chartValues[i],
                                width: 20,
                                color: const Color(0xFFB58A4A),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ],
                          ),
                      ],
                      borderData: FlBorderData(show: false),
                      gridData: const FlGridData(show: false),
                      titlesData: FlTitlesData(
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 48,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();

                              if (index < 0 || index >= categories.length) {
                                return const SizedBox.shrink();
                              }

                              return SideTitleWidget(
                                meta: meta,
                                child: RotatedBox(
                                  quarterTurns: 3,
                                  child: Text(
                                    categories[index],
                                    maxLines: 1,
                                    softWrap: false,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF79532E),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
