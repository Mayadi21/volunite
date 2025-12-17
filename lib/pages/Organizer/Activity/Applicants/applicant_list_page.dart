import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/models/pendaftaran_model.dart';
import 'package:volunite/services/pendaftaran_service.dart';
import 'package:volunite/pages/Organizer/Activity/Applicants/applicant_card.dart';

class ApplicantListPage extends StatefulWidget {
  final int kegiatanId;
  final String statusKegiatan; 

  const ApplicantListPage({
    super.key, 
    required this.kegiatanId,
    required this.statusKegiatan, 
  });

  @override
  State<ApplicantListPage> createState() => _ApplicantListPageState();
}

class _ApplicantListPageState extends State<ApplicantListPage> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  bool _isLoading = true;
  List<Pendaftaran> _allApplicants = [];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _isLoading = true);
    try {
      final data = await PendaftaranService.fetchPendaftarByKegiatan(widget.kegiatanId);
      if (mounted) {
        setState(() {
          _allApplicants = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final listPending = _allApplicants.where((e) => e.status == 'Mengajukan').toList();
    final listAccepted = _allApplicants.where((e) => e.status == 'Diterima').toList();
    final listRejected = _allApplicants.where((e) => e.status == 'Ditolak').toList();

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const Text("Daftar Pelamar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: kSkyBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [Tab(text: "Menunggu"), Tab(text: "Diterima"), Tab(text: "Ditolak")],
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: kSkyBlue))
        : TabBarView(
            controller: _tabCtrl,
            children: [
              _ApplicantList(data: listPending, onRefresh: _refresh, statusKegiatan: widget.statusKegiatan),
              _ApplicantList(data: listAccepted, onRefresh: _refresh, statusKegiatan: widget.statusKegiatan),
              _ApplicantList(data: listRejected, onRefresh: _refresh, statusKegiatan: widget.statusKegiatan),
            ],
          ),
    );
  }
}

class _ApplicantList extends StatelessWidget {
  final List<Pendaftaran> data;
  final VoidCallback onRefresh;
  final String statusKegiatan;

  const _ApplicantList({required this.data, required this.onRefresh, required this.statusKegiatan});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const Center(child: Text("Tidak ada data", style: TextStyle(color: kBlueGray)));

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      separatorBuilder: (_,__) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) {
        return ApplicantCard(
          pendaftaran: data[i], 
          onUpdate: onRefresh,
          statusKegiatan: statusKegiatan, 
        );
      },
    );
  }
}