class UserData {
  final String uid;
  final String name;
  final int age;
  final String image;
  UserData({this.uid, this.name, this.age, this.image});
  UserData.fromJson(Map<String, Object> json)
      : this(
          uid: json['uid'] as String,
          name: json['name'] as String,
          age: json['age'] as int,
        );
  Map<String, Object> toJson() {
    return {
      'uid': uid,
      'name': name,
      'age': age,
    };
  }
}
