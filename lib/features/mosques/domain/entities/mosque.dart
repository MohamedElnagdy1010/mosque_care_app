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
}
