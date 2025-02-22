class UserModel {
  final String fullName;

  final String email;
  final String phoneNo;

  UserModel({
    required this.fullName,
    required this.email,
    required this.phoneNo,
  });

  // Convert a UserModel object into a map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
      'phone_no': phoneNo,
    };
  }

  // Create a UserModel object from a Firestore map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phoneNo: json['phone_no'] ?? '',
    );
  }
}
