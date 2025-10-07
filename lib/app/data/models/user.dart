class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
    required this.guest,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatar;
  final bool guest;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        avatar: json['avatar'] as String?,
        guest: json['guest'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'avatar': avatar,
        'guest': guest,
      };

  static User guestUser() => User(
        id: 'guest',
        name: 'Guest',
        email: 'guest@example.com',
        phone: '',
        avatar: null,
        guest: true,
      );
}
