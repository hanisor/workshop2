class EducatorModel {
  final String? id;
  final String name;
  final String? profilePic;
  final String expertise;
  final String phoneNumber;
  final String email;
  final String password;
  final String rePassword;
  final String role;

  const EducatorModel ({
    this.id,
    required this.name,
    required this.profilePic,
    required this.expertise,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.rePassword,
    required this.role,
  });
}