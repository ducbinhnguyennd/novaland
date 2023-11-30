// user_model.dart
class UserModel {
  final String userId;
  final String username;
  final String role;
  final int coin;
  final String avatar;

  UserModel({
    required this.userId,
    required this.username,
    required this.role,
    required this.coin,
    required this.avatar
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      username: json['username'],
      role: json['role'],
      coin: json['coin'], avatar: json['avatar']
    );
  }
}
