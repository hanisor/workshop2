class ParentModel {
  final String? id;
  final String? profilePic;
  final String name;
  final String phoneNumber;
  final String email;
  final String password;
  final String rePassword;
  final String role;

  const ParentModel ({
    this.id,
    required this.name,
    required this.profilePic,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.rePassword,
    required this.role,
  });
}