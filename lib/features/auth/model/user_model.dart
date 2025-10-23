import 'dart:convert';

class UserModel {
  final String name;
  final String email;
  final String id;
  final String token;
  UserModel({
    required this.name,
    required this.email,
    required this.id,
    required this.token,
  });

  //This method is used to change the values of the property of object. Because the properties are final, we can't change them.
  UserModel copyWith({String? name, String? email, String? id, String? token}) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      id: id ?? this.id,
      token: token ?? this.token,
    );
  }

  //This method is used to convert the object to a map.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'id': id,
      'token': token,
    };
  }

  //This method is used to convert the map to an object.
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? String,
      email: map['email'] ?? String,
      id: map['id'] ?? String,
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, id: $id, token: $token)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.id == id &&
        other.token == token;
  }

  @override
  int get hashCode {
    return name.hashCode ^ email.hashCode ^ id.hashCode ^ token.hashCode;
  }
}
