
class AuthModel {
  String? id;
  String? name;
  String? email;
  DateTime? timestamp;

  AuthModel({
    this.id,
    this.name,
    this.email,
    this.timestamp,
  });


  AuthModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? '';
    email = json['email'] ?? '';

    timestamp = DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'timestamp': DateTime.now(),
    };
  }
}