class UserModel {
  final int id;
  final String username;
  final String email;
  final String userType;
  final String? phone;
  final double? currentLatitude;
  final double? currentLongitude;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.userType,
    this.phone,
    this.currentLatitude,
    this.currentLongitude,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      userType: json['user_type'],
      phone: json['phone'],
      currentLatitude: json['current_latitude']?.toDouble(),
      currentLongitude: json['current_longitude']?.toDouble(),
    );
  }

  get token => null;
}
