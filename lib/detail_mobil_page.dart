import 'package:flutter/material.dart';

class DetailMobilPage extends StatelessWidget {
  final Map<String, dynamic> mobil;

  const DetailMobilPage({super.key, required this.mobil});

  @override
  Widget build(BuildContext context) {
    // Ambil nama seri untuk tombol kembali (misal: "BMW Seri 2")
    final String seriNama = mobil['seri_nama'] ?? 'BMW Seri';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Latar belakang abu-abu sangat muda (seperti di gambar)
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // 1. GAMBAR MOBIL (ROUNDED CORNERS)
              // ==========================================
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'images/${mobil['gambar'] ?? 'default_bmw.jpg'}',
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: 220,
                      color: Colors.grey[200],
                      child: const Icon(Icons.directions_car, size: 60, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ==========================================
              // 2. KARTU SPESIFIKASI SINGKAT
              // ==========================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SPESIFIKASI SINGKAT',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey[500],
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Baris Data Spesifikasi
                    _buildSpecRow('Kode', mobil['kode'] ?? '-'),
                    _buildDivider(),
                    _buildSpecRow('Tahun', mobil['tahun']?.toString() ?? '-'),
                    _buildDivider(),
                    _buildSpecRow('Transmisi', _capitalize(mobil['transmisi'] ?? '-')),
                    _buildDivider(),
                    _buildSpecRow('Tipe Bodi', _capitalize(mobil['tipe_bodi'] ?? '-')),
                    _buildDivider(),
                    _buildSpecRow('Bahan Bakar', _capitalize(mobil['bahan_bakar'] ?? '-')),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ==========================================
              // 3. TOMBOL KEMBALI
              // ==========================================
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.grey.shade200),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    '← Kembali ke $seriNama',
                    style: const TextStyle(
                      color: Color(0xFF334155), // Warna teks abu-abu gelap
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget untuk Baris Spesifikasi (Kiri Abu-abu, Kanan Hitam Bold)
  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget untuk Garis Pembatas Tipis
  Widget _buildDivider() {
    return Divider(
      color: Colors.grey.shade100,
      height: 1,
      thickness: 1,
    );
  }

  // Helper untuk membuat huruf pertama menjadi kapital (Biar rapi)
  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}