class User {
  final int id;
  final String nama;
  final String email;
  final String role;
  final String? pathProfil;
  final DateTime? emailVerifiedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.nama,
    required this.email,
    required this.role,
    this.pathProfil,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  /// Buat objek User dari JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      nama: json['nama'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      pathProfil: json['path_profil'] as String?, // bisa null
      emailVerifiedAt: _parseDateTime(json['email_verified_at']),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }



  /// Helper untuk parsing DateTime yang bisa null
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  /// Optional: copyWith biar gampang update sebagian field
  /// tidak mayadi buat
}
