class Users {
  int? id;
  String? fullname;
  String? email;
  String? password;
  String? gender;

  Users({
    this.id,
    this.fullname,
    this.email,
    this.password,
    this.gender
  });
// Factory method to create a User from JSON
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: int.parse(json['id']), // Parsing string ID to integer
      fullname: json['fullname'],
      email: json['email'],
      password: json['password'],
      gender: json['gender'],
    );
  }
}
