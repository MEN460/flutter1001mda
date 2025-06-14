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
<<<<<<< HEAD
  final bool isOnline;
  final DateTime? lastActiveAt;
=======
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301

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
<<<<<<< HEAD
    this.isOnline = false,
    this.lastActiveAt,
=======
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
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
<<<<<<< HEAD
      username: json['username']?.toString() ?? 'Unknown User',
=======
      username: username,
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
      email: (json['email'] ?? '').toString(),
      userType: (json['user_type'] ?? '').toString(),
      phone: json['phone']?.toString(),
      currentLatitude: _safeDouble(json['current_latitude']),
      currentLongitude: _safeDouble(json['current_longitude']),
<<<<<<< HEAD
      avatarUrl: json['avatar_url'],
      specialization: json['specialization'],
      rating: _safeDouble(json['rating']),
      distance: _safeDouble(json['distance']),
      isOnline: json['is_online'] ?? false,
      lastActiveAt: json['last_active_at'] != null
          ? DateTime.parse(json['last_active_at'])
          : null,
=======
      avatarUrl: json['avatar_url'] ?? mockAvatarUrl,
      specialization: json['specialization'] ?? mockSpecialization,
      rating: _safeDouble(json['rating']) ?? mockRating,
      distance: _safeDouble(json['distance']) ?? mockDistance,
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
    );
  }

  static double? _safeDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }

<<<<<<< HEAD
  UserModel copyWith({
    int? id,
    String? username,
    String? email,
    String? userType,
    String? phone,
    double? currentLatitude,
    double? currentLongitude,
    String? avatarUrl,
    String? specialization,
    double? rating,
    double? distance,
    bool isOnline = false,
    DateTime? lastActiveAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      phone: phone ?? this.phone,
      currentLatitude: currentLatitude ?? this.currentLatitude,
      currentLongitude: currentLongitude ?? this.currentLongitude,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      specialization: specialization ?? this.specialization,
      rating: rating ?? this.rating,
      distance: distance ?? this.distance,
      isOnline: isOnline,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }
=======
  get token => null;
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
}
