import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/models/pendaftaran_model.dart';
import 'package:volunite/services/pendaftaran_service.dart';
import 'package:volunite/pages/Organizer/Activity/Applicants/applicant_card.dart'; // Kita buat setelah ini

class ApplicantListPage extends StatefulWidget {
  final int kegiatanId;
  const ApplicantListPage({super.key, required this.kegiatanId});

  @override
  State<ApplicantListPage> createState() => _ApplicantListPageState();
}

class _ApplicantListPageState extends State<ApplicantListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  late Future<List<Pendaftaran>> _futureData;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    _refresh();
  }

  void _refresh() {
    setState(() {
      _futureData = PendaftaranService.fetchPendaftarByKegiatan(
        widget.kegiatanId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const Text(
          "Data Pelamar",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: kSkyBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: "Masuk"), // Mengajukan
            Tab(text: "Diterima"),
            Tab(text: "Ditolak"),
          ],
        ),
      ),
      body: FutureBuilder<List<Pendaftaran>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: kSkyBlue),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final allData = snapshot.data ?? [];

          // Filter data berdasarkan Enum Database
          final listPending = allData
              .where((e) => e.status == 'Mengajukan')
              .toList();
          final listAccepted = allData
              .where((e) => e.status == 'Diterima')
              .toList();
          final listRejected = allData
              .where((e) => e.status == 'Ditolak')
              .toList();

          return TabBarView(
            controller: _tabCtrl,
            children: [
              _ApplicantList(
                data: listPending,
                onRefresh: _refresh,
                type: 'pending',
              ),
              _ApplicantList(
                data: listAccepted,
                onRefresh: _refresh,
                type: 'accepted',
              ),
              _ApplicantList(
                data: listRejected,
                onRefresh: _refresh,
                type: 'rejected',
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ApplicantList extends StatelessWidget {
  final List<Pendaftaran> data;
  final VoidCallback onRefresh;
  final String type; // 'pending', 'accepted', 'rejected'

  const _ApplicantList({
    required this.data,
    required this.onRefresh,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off_outlined, size: 60, color: kLightGray),
            const SizedBox(height: 10),
            Text("Tidak ada data pelamar", style: TextStyle(color: kBlueGray)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) {
        return ApplicantCard(
          pendaftaran: data[i],
          onUpdate: onRefresh, // Cukup ini saja
        );
      },
    );
  }
}
