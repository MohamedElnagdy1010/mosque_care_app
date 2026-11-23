class Mosque {
  const Mosque({
    required this.id,
    required this.name,
    required this.neighborhood,
    this.locationUrl,
    this.latitude,
    this.longitude,
    this.imamName,
    this.muezzinName,
    this.registrationSource,
    this.mosqueType,
    this.imageUrl,
    this.serviceStatus,
    this.openNeedsCount,
  });

  final String id;
  final String name;
  final String neighborhood;
  final String? locationUrl;

  final double? latitude;
  final double? longitude;

  final String? imamName;
  final String? muezzinName;
  final String? registrationSource;
  final String? mosqueType;

  // بيانات دليل المساجد من API v1.8
  final String? imageUrl;
  final String? serviceStatus;
  final int? openNeedsCount;
}
