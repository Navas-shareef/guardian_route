class LocationEntity {
  final double? latitude;
  final double? longitude;
  final String? status;
  final String? errorMessage;
  final DateTime timestamp;

  LocationEntity({
    this.latitude,
    this.longitude,
    this.status,
    this.errorMessage,
    required this.timestamp,
  });
}
