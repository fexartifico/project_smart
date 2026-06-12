import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Jangan lupa install package intl jika belum
import 'api_service.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  final Color primaryColor = const Color(0xFF5A58F2);
  
  List<dynamic> _riwayatList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRiwayat();
  }

  // Mengambil data riwayat dari API
  Future<void> _fetchRiwayat() async {
    setState(() => _isLoading = true);
    final data = await ApiService().getRiwayat();
    
    if (mounted) {
      setState(() {
        _riwayatList = data;
        _isLoading = false;
      });
    }
  }

  // Menghapus data riwayat lewat API
  Future<void> _hapusRiwayat(int id, int index) async {
    // Tampilkan dialog konfirmasi
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Riwayat?'),
        content: const Text('Data analisis ini akan dihapus secara permanen.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Batal', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ) ?? false;

    if (!confirm) return;

    // Hapus di Backend
    bool success = await ApiService().deleteRiwayat(id);

    if (success && mounted) {
      // Hapus di UI (Frontend)
      setState(() {
        _riwayatList.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Riwayat berhasil dihapus!'), backgroundColor: Colors.green),
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus riwayat.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // Format tanggal dari Laravel (Y-m-d H:i:s) ke format yang lebih cantik
  String _formatTanggal(String tanggalString) {
    try {
      DateTime dt = DateTime.parse(tanggalString);
      return DateFormat('dd MMM yyyy, HH:mm').format(dt);
    } catch (e) {
      return tanggalString; // Kembalikan string asli jika gagal parse
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Riwayat Analisis',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : _riwayatList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history_toggle_off, size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text('Belum ada riwayat analisis.', style: TextStyle(color: Colors.grey[500], fontSize: 16)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _riwayatList.length,
                  itemBuilder: (context, index) {
                    final item = _riwayatList[index];
                    
                    // Hitung persentase skor
                    final double skorAkhir = double.tryParse(item['skor_akhir'].toString()) ?? 0.0;
                    final String skorPersen = '${(skorAkhir * 100).toStringAsFixed(2)}%';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 4))
                        ],
                      ),
                      child: Row(
                        children: [
                          // Thumbnail Mobil
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'images/${item['model_gambar'] ?? 'default_bmw.jpg'}',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[100],
                                child: Icon(Icons.directions_car, color: primaryColor),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          
                          // Detail Riwayat
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['model_nama'] ?? 'Mobil BMW', 
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['seri_nama'] ?? '-', 
                                  style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.access_time, size: 12, color: Colors.grey[400]),
                                    const SizedBox(width: 4),
                                    Text(
                                      _formatTanggal(item['created_at']), 
                                      style: TextStyle(color: Colors.grey[500], fontSize: 11),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          // Skor & Action
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                skorPersen, 
                                style: TextStyle(color: primaryColor, fontWeight: FontWeight.w900, fontSize: 16),
                              ),
                              const SizedBox(height: 12),
                              // TOMBOL HAPUS
                              GestureDetector(
                                onTap: () => _hapusRiwayat(item['id'], index),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50, 
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.delete_outline, color: Colors.red, size: 14),
                                      SizedBox(width: 4),
                                      Text('Hapus', style: TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}