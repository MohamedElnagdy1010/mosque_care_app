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
  });
}
