import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String address;
  final String type;
  final String token;
  final List<dynamic> cart;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.address,
    required this.type,
    required this.token,
    required this.cart,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': id.toString(),
      'Name': name,
      'Email': email,
      'Password': password,
      'Address': address,
      'user_type': type,
      'token': token,
      'cart': cart,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['name_user'] ?? '',
      name: map['name_user'] ?? '',
      email: map['email_user'] ?? '',
      password: map['password_user'] ?? '',
      address: map['address_user'] ?? '',
      type: map['type_user'] ?? '',
      token: map['type_user'] ?? '',
      // cart: map[[
      //       "0",
      //       "0",
      //     ]] ??
      //     ["asss"]
      cart: List<Map<String, dynamic>>.from(
        map['cart']?.map(
          (x) => Map<String, dynamic>.from(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? address,
    String? type,
    String? token,
    List<dynamic>? cart,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      address: address ?? this.address,
      type: type ?? this.type,
      token: token ?? this.token,
      cart: cart ?? this.cart,
    );
  }
}
