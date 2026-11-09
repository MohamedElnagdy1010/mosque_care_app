class NeedCategory {
  const NeedCategory({
    required this.id,
    required this.name,
    required this.items,
  });

  final String id;
  final String name;
  final List<NeedItem> items;
}

class NeedItem {
  const NeedItem({required this.id, required this.name});

  final String id;
  final String name;
}
