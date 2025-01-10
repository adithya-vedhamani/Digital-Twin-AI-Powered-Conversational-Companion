class User {
  String name;
  int age;
  String sex;
  String location;
  String education;
  String professionalDetails;

  User({
    required this.name,
    required this.age,
    required this.sex,
    required this.location,
    required this.education,
    required this.professionalDetails,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'sex': sex,
      'location': location,
      'education': education,
      'professional_details': professionalDetails,
    };
  }
}
