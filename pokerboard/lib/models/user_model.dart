// lib/models/user_model.dart
class UserModel {
  final String uid;
  final String email;
  final String name;
  final String photoUrl;
  final String role; // 'observer' or 'user'
  final bool isOnline;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.photoUrl,
    required this.role,
    required this.isOnline,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      email: data['email'],
      name: data['name'],
      photoUrl: data['photoUrl'],
      role: data['role'],
      isOnline: data['isOnline'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'role': role,
      'isOnline': isOnline,
    };
  }
}
