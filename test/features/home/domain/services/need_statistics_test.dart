import 'package:flutter_test/flutter_test.dart';
import 'package:mosque_care_app/features/home/data/mock/mock_mosque_needs.dart';
import 'package:mosque_care_app/features/home/domain/services/need_statistics.dart';

void main() {
  group('NeedStatistics', () {
    final needs = MockMosqueNeeds.all;

    test('counts unique mosques in a category', () {
      final result = NeedStatistics.countMosquesByCategory(
        needs,
        'air_conditioning',
      );

      expect(result, 2);
    });

    test('counts unique mosques for each item', () {
      expect(
        NeedStatistics.countMosquesByItem(
          needs,
          'air_conditioning',
          'poor_cooling',
        ),
        2,
      );

      expect(
        NeedStatistics.countMosquesByItem(
          needs,
          'air_conditioning',
          'water_leak',
        ),
        1,
      );
    });

    test('excludes completed needs', () {
      final result = NeedStatistics.countMosquesByItem(
        needs,
        'air_conditioning',
        'noise',
      );

      expect(result, 0);
    });

    test('counts other categories independently', () {
      expect(NeedStatistics.countMosquesByCategory(needs, 'electrical'), 1);

      expect(NeedStatistics.countMosquesByCategory(needs, 'plumbing'), 1);

      expect(NeedStatistics.countMosquesByCategory(needs, 'carpets'), 1);
    });
  });
}
