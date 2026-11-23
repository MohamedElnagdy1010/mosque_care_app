class ServiceCatalogItem {
  const ServiceCatalogItem({required this.key, required this.name});

  final String key;
  final String name;
}

class ServiceCatalogCategory {
  const ServiceCatalogCategory({
    required this.key,
    required this.name,
    required this.items,
  });

  final String key;
  final String name;
  final List<ServiceCatalogItem> items;
}

class ServiceCatalogModel {
  const ServiceCatalogModel({required this.categories});

  final List<ServiceCatalogCategory> categories;

  factory ServiceCatalogModel.fromJson(Map<String, dynamic> json) {
    final categories = <ServiceCatalogCategory>[];

    for (final entry in json.entries) {
      final categoryData = entry.value;

      if (categoryData is! Map) {
        throw const FormatException('بيانات قسم الخدمة غير صالحة.');
      }

      final rawItems = categoryData['items'];

      if (rawItems is! Map) {
        throw const FormatException('عناصر قسم الخدمة غير صالحة.');
      }

      final items = <ServiceCatalogItem>[];

      for (final item in rawItems.entries) {
        if (item.value is! String) {
          throw const FormatException('اسم عنصر الخدمة غير صالح.');
        }

        items.add(
          ServiceCatalogItem(
            key: item.key.toString(),
            name: item.value as String,
          ),
        );
      }

      categories.add(
        ServiceCatalogCategory(
          key: entry.key,
          name: _categoryName(entry.key),
          items: items,
        ),
      );
    }

    return ServiceCatalogModel(categories: categories);
  }

  static String _categoryName(String key) {
    const names = <String, String>{
      'maintenance_electrical': 'الكهرباء',
      'maintenance_hvac': 'التكييف',
      'maintenance_plumbing': 'السباكة',
      'maintenance_doorsWindows': 'الأبواب والنوافذ',
      'maintenance_paintingRestoration': 'الدهانات والترميم',
      'cleaning': 'النظافة',
      'furnishing': 'الفرش',
      'audio': 'الصوتيات',
      'facilities': 'المرافق والتجهيزات',
    };

    return names[key] ?? key;
  }
}
