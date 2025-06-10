class ServiceRequest {
  final int id;
  final int carOwnerId;
  final int? mechanicId;
  final double latitude;
  final double longitude;
  final String description;
  final String status;
  final DateTime? acceptedAt;

  ServiceRequest({
    required this.id,
    required this.carOwnerId,
    this.mechanicId,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.status,
    this.acceptedAt,
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    return ServiceRequest(
      id: json['id'],
      carOwnerId: json['car_owner_id'],
      mechanicId: json['mechanic_id'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      description: json['description'],
      status: json['status'],
      acceptedAt: json['accepted_at'] != null
          ? DateTime.parse(json['accepted_at'])
          : null,
    );
  }

  get distance => null;
}
