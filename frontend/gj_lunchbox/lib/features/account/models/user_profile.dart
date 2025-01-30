class UserProfile {
  final String name;
  final String email;
  final double weight;
  final int age;
  final double height;
  final String? imageUrl;

  UserProfile({
    required this.name,
    required this.email,
    required this.weight,
    required this.age,
    required this.height,
    this.imageUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic>json){
    return UserProfile(name: json['name'], email: json['email'], weight: json['weight'], age: json['age'], height: json['height']);
  }
}