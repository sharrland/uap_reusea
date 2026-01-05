class UserModel {
  final String email;
  final String token;
  final String username;
  final String fullName;
  final String avatar;
  final String phone;

  UserModel({
    this.email = '', // ← Optional dengan default ''
    this.token = '', // ← Optional dengan default ''
    this.username = '',
    this.fullName = '',
    this.avatar = '',
    this.phone = '',
  });

  // Factory untuk DummyJSON login/register
  factory UserModel.fromJson(Map<String, dynamic> json, String email) {
    return UserModel(
      email: email,
      token: json['accessToken'] ?? '',
      username: '@${json['username'] ?? ''}',
      fullName: '${json['firstName'] ?? ''} ${json['lastName'] ?? ''}',
      avatar: json['image'] ?? 'https://i.pravatar.cc/300',
      phone: json['phone'] ?? '',
    );
  }

  // Factory untuk Random User API
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
      token: '', // Random User API tidak return token
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
      token: 'dummy_token',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'token': token,
      'username': username,
      'fullName': fullName,
      'avatar': avatar,
      'phone': phone,
    };
  }

  /// 🔥 Factory untuk DummyJSON LOGIN
  factory UserModel.fromDummyJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
      token: json['accessToken'] ?? '',
      username: '@${json['username'] ?? ''}',
      fullName: '${json['firstName'] ?? ''} ${json['lastName'] ?? ''}'.trim(),
      avatar: json['image'] ?? 'https://i.pravatar.cc/300',
      phone: json['phone'] ?? '',
    );
  }

  /// 🔥 Factory untuk DummyJSON REGISTER (simulasi)
  factory UserModel.fromRegisterDummy(
    Map<String, dynamic> json,
    String email,
    String? name, // 👈 tambahan, boleh null
  ) {
    return UserModel(
      email: email,
      token: json['token'] ?? '',
      username: '@${email.split('@').first}',
      fullName: name ?? email.split('@').first,
      avatar: 'https://i.pravatar.cc/300',
      phone: '',
    );
  }
}
