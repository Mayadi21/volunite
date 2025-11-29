class User {
  final int id;
  final String nama;
  final String email;
  final String role; 
  final String? pathProfil;
  final DetailUser? detail; 

  User({
    required this.id,
    required this.nama,
    required this.email,
    required this.role,
    this.pathProfil,
    this.detail,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nama: json['nama'], 
      email: json['email'],
      role: json['role'],
      pathProfil: json['path_profil'], 
      detail: json['detail_user'] != null 
          ? DetailUser.fromJson(json['detail_user']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'role': role,
      'path_profil': pathProfil,
    };
  }
}

class DetailUser {
  final String? tanggalLahir;
  final String? jenisKelamin;
  final String? noTelepon;
  final String? domisili;

  DetailUser({
    this.tanggalLahir,
    this.jenisKelamin,
    this.noTelepon,
    this.domisili,
  });

  factory DetailUser.fromJson(Map<String, dynamic> json) {
    return DetailUser(
      tanggalLahir: json['tanggal_lahir'],
      jenisKelamin: json['jenis_kelamin'],
      noTelepon: json['no_telepon'],
      domisili: json['domisili'],
    );
  }
}