import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/models/leaderboard_model.dart';
import 'package:volunite/services/leaderboard_service.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  late Future<List<LeaderboardUser>> _futureLeaderboard;

  @override
  void initState() {
    super.initState();
    _futureLeaderboard = LeaderboardService.fetchLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const Text(
          "Papan Peringkat", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        ),
        backgroundColor: kSkyBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder<List<LeaderboardUser>>(
        future: _futureLeaderboard,
        builder: (context, snapshot) {
          // 1. Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: kSkyBlue));
          }
          
          // 2. Error
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text("Gagal memuat data: ${snapshot.error}", textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      _futureLeaderboard = LeaderboardService.fetchLeaderboard();
                    }),
                    child: const Text("Coba Lagi")
                  )
                ],
              ),
            );
          }

          // 3. Data Kosong
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada data peringkat"));
          }

          final leaders = snapshot.data!;

          // 4. List Data
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: leaders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final user = leaders[index];
              final int rank = index + 1;
              
              return _buildRankItem(user, rank);
            },
          );
        },
      ),
    );
  }

  Widget _buildRankItem(LeaderboardUser user, int rank) {
    // Logic Warna & Ikon Juara
    Color rankColor = kBlueGray;
    IconData? trophyIcon;
    Color? trophyColor;
    double scale = 1.0;

    if (rank == 1) {
      trophyIcon = Icons.emoji_events;
      trophyColor = Colors.amber; // Emas
      scale = 1.2;
    } else if (rank == 2) {
      trophyIcon = Icons.emoji_events;
      trophyColor = Colors.grey; // Perak
      scale = 1.1;
    } else if (rank == 3) {
      trophyIcon = Icons.emoji_events;
      trophyColor = Colors.brown; // Perunggu
      scale = 1.0;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: rank == 1 ? Border.all(color: Colors.amber.withOpacity(0.5), width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: kLightGray.withOpacity(0.5), 
            blurRadius: 4, 
            offset: const Offset(0, 2)
          )
        ],
      ),
      child: Row(
        children: [
          // Kolom Ranking (Angka / Piala)
          SizedBox(
            width: 40,
            child: Center(
              child: trophyIcon != null 
                ? Transform.scale(
                    scale: scale,
                    child: Icon(trophyIcon, color: trophyColor, size: 28),
                  )
                : Text(
                    "#$rank", 
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold, 
                      color: rankColor
                    )
                  ),
            ),
          ),
          const SizedBox(width: 12),

          // Avatar
          CircleAvatar(
            radius: 22,
            backgroundColor: kLightGray,
            backgroundImage: user.pathProfil != null 
                ? NetworkImage(user.pathProfil!) 
                : const AssetImage('assets/images/profile_placeholder.jpeg') as ImageProvider,
          ),
          const SizedBox(width: 16),

          // Nama
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 16, 
                    color: kDarkBlueGray
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Total XP Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: kSkyBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "${user.totalXp} XP",
              style: const TextStyle(
                fontWeight: FontWeight.bold, 
                color: kSkyBlue, 
                fontSize: 12
              ),
            ),
          ),
        ],
      ),
    );
  }
}