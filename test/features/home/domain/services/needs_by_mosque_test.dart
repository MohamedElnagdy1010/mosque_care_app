import 'package:flutter_test/flutter_test.dart';
import 'package:mosque_care_app/features/home/data/mock/mock_mosque_needs.dart';
import 'package:mosque_care_app/features/home/domain/services/needs_by_mosque.dart';

void main() {
  group('NeedsByMosque', () {
    final needs = MockMosqueNeeds.all;

    test('groups active needs by unique mosque', () {
      final result = NeedsByMosque.group(needs, 'air_conditioning');

      expect(result.length, 2);
      expect(result['mosque_001']?.length, 2);
      expect(result['mosque_002']?.length, 1);
    });

    test('excludes completed needs', () {
      final result = NeedsByMosque.group(needs, 'air_conditioning');

      expect(result.containsKey('mosque_003'), false);
    });

    test('keeps quantities and item IDs', () {
      final result = NeedsByMosque.group(needs, 'air_conditioning');

      final firstMosqueNeeds = result['mosque_001']!;

      expect(
        firstMosqueNeeds.any(
          (need) => need.itemId == 'poor_cooling' && need.quantity == 3,
        ),
        true,
      );

      expect(
        firstMosqueNeeds.any(
          (need) => need.itemId == 'water_leak' && need.quantity == 1,
        ),
        true,
      );
    });

    test('does not mix different categories', () {
      final result = NeedsByMosque.group(needs, 'electrical');

      expect(result.length, 1);
      expect(result.containsKey('mosque_002'), true);
    });
  });
}
