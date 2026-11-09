import '../entities/mosque.dart';

class MosqueLocationValidator {
  const MosqueLocationValidator._();

  static bool hasValidCoordinates(Mosque mosque) {
    final latitude = mosque.latitude;
    final longitude = mosque.longitude;

    if (latitude == null || longitude == null) {
      return false;
    }

    return latitude.isFinite &&
        longitude.isFinite &&
        latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180;
  }
}
