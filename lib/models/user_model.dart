class UserModel {
  final int id;
  final String username;
  final String email;
  final String userType;
  final String? phone;
  final double? currentLatitude;
  final double? currentLongitude;
  final String? avatarUrl;
  final String? specialization;
  final double? rating;
  final double? distance;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.userType,
    this.phone,
    this.currentLatitude,
    this.currentLongitude,
    this.avatarUrl,
    this.specialization,
    this.rating,
    this.distance,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final mockAvatarUrl = 'https://i.pravatar.cc/300?u=${json['id']}';
    const mockSpecialization = 'Development Specialist';
    const mockRating = 4.5;
    const mockDistance = 2.5;

    // Robust username parsing
    final username = (json['username'] ?? json['user_name'] ?? 'Unknown User').toString();

    return UserModel(
      id: json['id'],
      username: username,
      email: (json['email'] ?? '').toString(),
      userType: (json['user_type'] ?? '').toString(),
      phone: json['phone']?.toString(),
      currentLatitude: _safeDouble(json['current_latitude']),
      currentLongitude: _safeDouble(json['current_longitude']),
      avatarUrl: json['avatar_url'] ?? mockAvatarUrl,
      specialization: json['specialization'] ?? mockSpecialization,
      rating: _safeDouble(json['rating']) ?? mockRating,
      distance: _safeDouble(json['distance']) ?? mockDistance,
    );
  }

  static double? _safeDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }

  get token => null;
}
