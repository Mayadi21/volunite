class Sertifikat {
  final int id;
  final int pendaftaranId;
  final DateTime? tanggalTerbit;
  final String? pathFile; 

  Sertifikat({
    required this.id,
    required this.pendaftaranId,
    this.tanggalTerbit,
    this.pathFile,
  });

  factory Sertifikat.fromJson(Map<String, dynamic> json) {
    return Sertifikat(
      id: json['id'],
      pendaftaranId: json['pendaftaran_id'],
      tanggalTerbit: json['tanggal_terbit'] != null 
          ? DateTime.parse(json['tanggal_terbit']) 
          : null,
      pathFile: json['path_file'], 
    );
  }
}