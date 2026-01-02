class UserModel {
  final String username;
  final String fullName;
  final String avatar;
  final String email;
  final String phone;

  UserModel({
    required this.username,
    required this.fullName,
    required this.avatar,
    this.email = '',
    this.phone = '',
  });

  // Factory untuk parse dari Random User API
  factory UserModel.fromRandomUserApi(Map<String, dynamic> json) {
    final name = json['name'];
    final login = json['login'];
    final picture = json['picture'];
    
    return UserModel(
      username: '@${login['username']}',
      fullName: '${name['first']} ${name['last']}',
      avatar: picture['large'] ?? picture['medium'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  // Factory untuk data dummy (fallback)
  factory UserModel.dummy() {
    return UserModel(
      username: '@bravestar71',
      fullName: 'Karina Stephia',
      avatar: 'https://i.pravatar.cc/300',
      email: 'karina@example.com',
      phone: '+1234567890',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullName': fullName,
      'avatar': avatar,
      'email': email,
      'phone': phone,
    };
  }
}
