import 'package:flutter/material.dart';
import 'package:volunite/pages/Admin/data/admin_models.dart';
import 'activity_service.dart';
import 'package:volunite/color_pallete.dart';

class AdminActivityDetailPage extends StatefulWidget {
  final Activity activity;
  const AdminActivityDetailPage({super.key, required this.activity});

  @override
  State<AdminActivityDetailPage> createState() =>
      _AdminActivityDetailPageState();
}

class _AdminActivityDetailPageState extends State<AdminActivityDetailPage> {
  late Activity _activity;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _activity = widget.activity;
    debugPrint('DEBUG AdminActivityDetail - activity: ${_activity.toJson()}');
    debugPrint('DEBUG organizerName: ${_activity.organizerName}');
  }

  Future<void> _approveActivity() async {
    await _updateStatus('scheduled'); // status untuk ACC
  }

  Future<void> _rejectActivity() async {
    await _updateStatus('Rejected');
  }

  Future<void> _updateStatus(String newStatus) async {
    setState(() => _loading = true);

    try {
      final updated = await ActivityService.updateStatus(
        _activity.id,
        newStatus,
      );

      setState(() => _activity = updated);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newStatus == 'Rejected'
                ? 'Kegiatan telah ditolak.'
                : 'Kegiatan telah disetujui.',
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memperbarui status: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final img = _activity.thumbnail; // URL thumbnail dari API
    final organizer = _activity.organizerName ?? 'Penyelenggara tidak tersedia';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                _activity.judul,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  img != null
                      ? Image.network(
                          img,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey,
                            child: const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.grey,
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.white,
                            ),
                          ),
                        ),
                  Container(color: Colors.black.withOpacity(0.4)),
                ],
              ),
            ),
          ),

          // DETAIL INFO
          SliverList(
            delegate: SliverChildListDelegate([
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(organizer),
                subtitle: const Text('Penyelenggara'),
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today, color: primaryColor),
                title: Text(_activity.tanggalMulai?.toString() ?? '-'),
                subtitle: Text(_activity.tanggalBerakhir?.toString() ?? '-'),
              ),
              ListTile(
                leading: const Icon(Icons.location_on, color: primaryColor),
                title: Text(_activity.lokasi ?? '-'),
                subtitle: const Text('Lokasi'),
              ),

              // Deskripsi
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deskripsi Kegiatan',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _activity.deskripsi ?? '-',
                      style: const TextStyle(fontSize: 15, height: 1.5),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 100),
            ]),
          ),
        ],
      ),

      // Tombol ACC / Tolak (hanya tampil jika Waiting)
      bottomSheet: _activity.status == 'Waiting'
          ? _loading
                ? Container(
                    height: 80,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  )
                : Container(
                    padding: const EdgeInsets.all(16).copyWith(bottom: 24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.close_rounded),
                            label: const Text('Tolak'),
                            onPressed: _rejectActivity,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                            ),
                            label: const Text('Setujui'),
                            onPressed: _approveActivity,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
          : null,
    );
  }
}
