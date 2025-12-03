class ReportKegiatan {
  final int id;
  final int kegiatanId;
  final int userId;
  final String keluhan;
  final String? detailKeluhan;
  final String status;

  ReportKegiatan({
    required this.id,
    required this.kegiatanId,
    required this.userId,
    required this.keluhan,
    this.detailKeluhan,
    required this.status,
  });

  factory ReportKegiatan.fromJson(Map<String, dynamic> json) {
    return ReportKegiatan(
      id: json['id'],
      kegiatanId: json['kegiatan_id'],
      userId: json['user_id'],
      keluhan: json['keluhan'],
      detailKeluhan: json['detail_keluhan'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kegiatan_id': kegiatanId,
      'user_id': userId,
      'keluhan': keluhan,
      'detail_keluhan': detailKeluhan,
      'status': status,
    };
  }
}