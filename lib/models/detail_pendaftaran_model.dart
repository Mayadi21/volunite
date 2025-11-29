class DetailPendaftaran {
  final int pendaftaranId;
  final String? nomorTelepon;
  final String? domisili;
  final String? komitmen;
  final String? keterampilan;

  DetailPendaftaran({
    required this.pendaftaranId,
    this.nomorTelepon,
    this.domisili,
    this.komitmen,
    this.keterampilan,
  });

  factory DetailPendaftaran.fromJson(Map<String, dynamic> json) {
    return DetailPendaftaran(
      pendaftaranId: json['pendaftaran_id'],
      nomorTelepon: json['nomor_telepon'],
      domisili: json['domisili'],
      komitmen: json['komitmen'],
      keterampilan: json['keterampilan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pendaftaran_id': pendaftaranId,
      'nomor_telepon': nomorTelepon,
      'domisili': domisili,
      'komitmen': komitmen,
      'keterampilan': keterampilan,
    };
  }
}