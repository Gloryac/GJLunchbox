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

  factory UserProfile.fromJson(Map<String, dynamic>json) {
    return UserProfile(
      name: json['name'] ?? '', 
      email: json['email'] ?? '', 
      weight: (json['weight'] ?? 0).toDouble(), 
      age: json['age'] ?? 0, 
      height: (json['height'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'],
    );
  }
  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'weight': weight,
        'age': age,
        'height': height,
        'imageUrl': imageUrl,
      };
}