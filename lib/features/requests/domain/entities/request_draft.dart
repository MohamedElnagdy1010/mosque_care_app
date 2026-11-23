class RequestNeedDraft {
  const RequestNeedDraft({
    required this.catalogCategory,
    required this.itemKey,
    this.priority = 'medium',
    this.notes = '',
    this.photoId = 0,
  });

  final String catalogCategory;
  final String itemKey;
  final String priority;
  final String notes;
  final int photoId;

  String get selectionKey => '$catalogCategory::$itemKey';

  RequestNeedDraft copyWith({String? priority, String? notes, int? photoId}) {
    return RequestNeedDraft(
      catalogCategory: catalogCategory,
      itemKey: itemKey,
      priority: priority ?? this.priority,
      notes: notes ?? this.notes,
      photoId: photoId ?? this.photoId,
    );
  }

  Map<String, dynamic> toApiJson() {
    final categoryMapping = _mapCategory(catalogCategory);

    return {
      'category': categoryMapping.category,
      'group': categoryMapping.group,
      'item_$catalogCategory': itemKey,
      'priority': priority,
      'notes': notes.trim(),
      'photo': photoId,
    };
  }

  ({String category, String group}) _mapCategory(String key) {
    if (key.startsWith('maintenance_')) {
      final groups = <String, String>{
        'maintenance_electrical': 'electrical',
        'maintenance_hvac': 'hvac',
        'maintenance_plumbing': 'plumbing',
        'maintenance_doorsWindows': 'doorsWindows',
        'maintenance_paintingRestoration': 'paintingRestoration',
      };

      return (category: 'maintenance', group: groups[key] ?? '');
    }

    return (category: key, group: '');
  }
}

class RequestDraft {
  const RequestDraft({
    required this.supervisorName,
    required this.supervisorPhone,
    required this.supervisorRole,
    required this.mosqueId,
    required this.needs,
    this.generalNotes = '',
  });

  final String supervisorName;
  final String supervisorPhone;
  final String supervisorRole;
  final int mosqueId;
  final List<RequestNeedDraft> needs;
  final String generalNotes;

  String? validate() {
    if (supervisorName.trim().isEmpty) {
      return 'يرجى إدخال اسم مقدم الطلب.';
    }

    if (!RegExp(r'^05\d{8}$').hasMatch(supervisorPhone.trim())) {
      return 'يرجى إدخال رقم جوال سعودي صحيح.';
    }

    if (supervisorRole.trim().isEmpty) {
      return 'يرجى تحديد صفة مقدم الطلب.';
    }

    if (mosqueId <= 0) {
      return 'يرجى اختيار المسجد.';
    }

    if (needs.isEmpty || needs.length > 30) {
      return 'يجب اختيار احتياج واحد إلى 30 احتياجًا.';
    }

    const priorities = {'high', 'medium', 'low'};

    for (final need in needs) {
      if (!priorities.contains(need.priority)) {
        return 'أولوية أحد الاحتياجات غير صالحة.';
      }

      if (need.itemKey == 'other' && need.notes.trim().isEmpty) {
        return 'يرجى توضيح الاحتياج عند اختيار أخرى.';
      }

      if (need.photoId < 0) {
        return 'معرّف الصورة غير صالح.';
      }
    }

    return null;
  }

  Map<String, dynamic> toApiJson() {
    return {
      'supervisor_name': supervisorName.trim(),
      'supervisor_phone': supervisorPhone.trim(),
      'supervisor_role': supervisorRole.trim(),
      'needs': needs.map((need) => need.toApiJson()).toList(),
      'inventory': <Map<String, dynamic>>[],
      'general_notes': generalNotes.trim(),
      'mosque_mode': 'existing',
      'mosque_id': mosqueId,
    };
  }
}
