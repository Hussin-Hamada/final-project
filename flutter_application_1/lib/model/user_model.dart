class UserModel {
  String? uid;
  String? email;
  String? name;
  String? clas;
  String? phone;

  UserModel({this.uid, this.email, this.name, this.clas, this.phone});

  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        name: map['name'],
        clas: map['clas'],
        phone: map['phone']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'clas': clas,
      'phone': phone
    };
  }
}
