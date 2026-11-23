import '../../domain/entities/mosque.dart';

class MosqueModel extends Mosque {
  const MosqueModel({
    required super.id,
    required super.name,
    required super.neighborhood,
    super.locationUrl,
    super.latitude,
    super.longitude,
    super.imamName,
    super.muezzinName,
    super.registrationSource,
    super.mosqueType,
    super.imageUrl,
    super.serviceStatus,
    super.openNeedsCount,
  });

  factory MosqueModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final district = json['district'];

    if (id == null || name is! String || district is! String) {
      throw const FormatException(
        'بيانات المسجد المستلمة من السيرفر غير صالحة.',
      );
    }

    final featuredImage = json['featured_image'];

    String? imageUrl;

    if (featuredImage is Map) {
      final url = featuredImage['url'];

      if (url is String && url.trim().isNotEmpty) {
        imageUrl = url.trim();
      }
    }

    double? parseCoordinate(dynamic value) {
      if (value == null) return null;
      return double.tryParse(value.toString());
    }

    int? parseCount(dynamic value) {
      if (value == null) return null;
      return int.tryParse(value.toString());
    }

    String? optionalText(dynamic value) {
      if (value is! String || value.trim().isEmpty) {
        return null;
      }

      return value.trim();
    }

    return MosqueModel(
      id: id.toString(),
      name: name,
      neighborhood: district,
      locationUrl: optionalText(json['url']),
      latitude: parseCoordinate(json['lat']),
      longitude: parseCoordinate(json['lng']),
      imamName: optionalText(json['sheikh_name']),
      muezzinName: optionalText(json['muezzin_name']),
      mosqueType: optionalText(json['type']),
      imageUrl: imageUrl,
      serviceStatus: optionalText(json['service_status']),
      openNeedsCount: parseCount(json['open_needs_count']),
    );
  }
}
