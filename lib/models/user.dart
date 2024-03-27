class FirebaseUser {
  final String email;
  final String name;
  final String profilePic;

  FirebaseUser({
    required this.email,
    required this.name,
    required this.profilePic,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'profilePic': profilePic,
    };
  }

  factory FirebaseUser.fromMap(Map<String, dynamic> map) {
    return FirebaseUser(
      email: map['email'] as String,
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
    );
  }

  FirebaseUser copyWith({
    String? email,
    String? name,
    String? profilePic,
  }) {
    return FirebaseUser(
      email: email ?? this.email,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
    );
  }
}
