import '../../domain/entities/mosque_need.dart';

class MockMosqueNeeds {
  const MockMosqueNeeds._();

  static const List<MosqueNeed> all = [
    MosqueNeed(
      id: 'need_001',
      mosqueId: 'mosque_001',
      categoryId: 'air_conditioning',
      itemId: 'poor_cooling',
      quantity: 3,
      status: 'new',
    ),
    MosqueNeed(
      id: 'need_002',
      mosqueId: 'mosque_001',
      categoryId: 'air_conditioning',
      itemId: 'water_leak',
      quantity: 1,
      status: 'in_progress',
    ),
    MosqueNeed(
      id: 'need_003',
      mosqueId: 'mosque_002',
      categoryId: 'air_conditioning',
      itemId: 'poor_cooling',
      quantity: 2,
      status: 'approved',
    ),
    MosqueNeed(
      id: 'need_004',
      mosqueId: 'mosque_003',
      categoryId: 'air_conditioning',
      itemId: 'noise',
      quantity: 1,
      status: 'completed',
    ),
    MosqueNeed(
      id: 'need_005',
      mosqueId: 'mosque_002',
      categoryId: 'electrical',
      itemId: 'indoor_lighting',
      quantity: 5,
      status: 'new',
    ),
    MosqueNeed(
      id: 'need_006',
      mosqueId: 'mosque_003',
      categoryId: 'plumbing',
      itemId: 'faucets',
      quantity: 2,
      status: 'in_progress',
    ),
    MosqueNeed(
      id: 'need_007',
      mosqueId: 'mosque_004',
      categoryId: 'carpets',
      itemId: 'carpet_washing',
      quantity: 1,
      status: 'new',
    ),
  ];
}
