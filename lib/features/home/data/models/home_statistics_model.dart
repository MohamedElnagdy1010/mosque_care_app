class HomeStatisticsModel {
  const HomeStatisticsModel({
    required this.approvedMosques,
    required this.registeredNeeds,
    required this.completedServices,
    required this.benefitedMosques,
  });

  final int approvedMosques;
  final int registeredNeeds;
  final int completedServices;
  final int benefitedMosques;

  factory HomeStatisticsModel.fromJson(Map<String, dynamic> json) {
    int readCount(String key) {
      final value = json[key];

      if (value is int && value >= 0) {
        return value;
      }

      if (value is num && value >= 0 && value % 1 == 0) {
        return value.toInt();
      }

      throw FormatException('قيمة الإحصائية $key غير صالحة.');
    }

    return HomeStatisticsModel(
      approvedMosques: readCount('approved_mosques'),
      registeredNeeds: readCount('registered_needs'),
      completedServices: readCount('completed_services'),
      benefitedMosques: readCount('benefited_mosques'),
    );
  }
}
