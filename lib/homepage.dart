import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Warna utama yang diambil dari referensi desain (Biru keunguan)
    final Color primaryColor = const Color(0xFF5A58F2); 

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // 1. HERO SECTION
            // ==========================================
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge Metode Smart
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '✧ METODE SMART — SIMPLE MULTI-ATTRIBUTE RATING TECHNIQUE',
                      style: TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Main Title
                  const Text(
                    'Sistem\nPendukung\nKeputusan\nPemilihan BMW',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                      color: Color(0xFF111827), // Dark text
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Subtitle
                  Text(
                    'Temukan BMW yang sempurna untuk Anda. Analisis multi-kriteria berbasis metode SMART membantu Anda memilih model terbaik sesuai kebutuhan nyata.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  
                  // Buttons
                 // Buttons
                  Row(
                    children: [
                      // Tombol 1: Cari sekarang
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            // Padding horizontal dihapus karena lebar sudah diatur oleh Expanded
                            padding: const EdgeInsets.symmetric(vertical: 14), 
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 0,
                          ),
                          child: const Text('→ Cari sekarang', textAlign: TextAlign.center),
                        ),
                      ),
                      
                      const SizedBox(width: 12), // Jarak di antara kedua tombol
                      
                      // Tombol 2: Pelajari Metode
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('▷ Pelajari Metode', textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Car Image Placeholder (Diganti icon besar karena tidak ada asset)
                  
                  Center(
                   child: Container(
                      width: 250, // <-- Ganti double.infinity jadi angka pasti (misal 200)
                      height: 120, // <-- Sesuaikan tingginya
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    child: ClipRRect( // Menggunakan ClipRRect agar gambar ikut membulat di pojok
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'images/ilusi_bmw.png', // Ganti dengan path gambar kamu yang sebenarnya
                        fit: BoxFit.cover, // Membuat gambar mengisi container dengan rapi tanpa distorsi
                      ),
                    ),
                  ),
                  )
                ],
              ),
            ),

            // Stats Row
            // Stats Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  border: Border.symmetric(horizontal: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Column(
                  children: [
                    // Baris Pertama (2 Item)
                    Row(
                      children: [
                        Expanded(child: _buildStatItem('29', 'Model BMW tersedia', isPurple: false)),
                        Container(height: 40, width: 1, color: Colors.grey.shade200), // Garis pembatas vertikal
                        Expanded(child: _buildStatItem('5', 'Kriteria Penilaian', isPurple: false)),
                      ],
                    ),
                    
                    // Garis pembatas horizontal
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Divider(color: Colors.grey.shade200, thickness: 1),
                    ),
                    
                    // Baris Kedua (2 Item)
                    Row(
                      children: [
                        Expanded(child: _buildStatItem('Smart', 'Metode Analisis', isPurple: true)),
                        Container(height: 40, width: 1, color: Colors.grey.shade200), // Garis pembatas vertikal
                        Expanded(child: _buildStatItem('100%', 'Hasil Rekomendasi', isPurple: true)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ==========================================
            // 2. KENAPA BUTUH SPK SECTION
            // ==========================================
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'KENAPA BUTUH SPK?',
                    style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  
                  // Menggunakan RichText agar bisa beda warna dalam satu blok teks
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                        color: Color(0xFF111827), // Warna teks default (Hitam gelap)
                      ),
                      children: <TextSpan>[
                        const TextSpan(text: 'Bingung Memilih\n'),
                        TextSpan(
                          text: 'BMW Pertama ', 
                          style: TextStyle(color: primaryColor), // Warna ungu
                        ),
                        const TextSpan(text: 'Anda?'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Teks deskripsi yang diperbarui
                  Text(
                    'Memilih model BMW yang tepat bisa membingungkan. Setiap model punya keunggulan berbeda — dari performa, efisiensi, hingga gaya hidup. Sistem kami membantu Anda membuat keputusan berdasarkan data, bukan tebakan.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.6),
                  ),
                  const SizedBox(height: 20),

                  // Tombol Mulai Analisis
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.auto_awesome, size: 18), // Ikon sparkle bawaan Flutter
                    label: const Text('Mulai analisis', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Sedikit membulat
                      ),
                      elevation: 0,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // List of Criteria (Biarkan kodingan list kriteria tetap seperti sebelumnya)
                  _buildCriteriaItem(Icons.attach_money, 'Harga & Budget', 'Apakah sesuai dengan anggaran Anda?', Colors.orange),
                  _buildCriteriaItem(Icons.flash_on, 'Performa & Kecepatan', 'Seberapa bertenaga yang Anda butuhkan?', Colors.blue),
                  _buildCriteriaItem(Icons.build, 'Konsumsi Bahan Bakar', 'Efisiensi untuk penggunaan sehari-hari', Colors.green),
                  _buildCriteriaItem(Icons.auto_awesome, 'Desain & Estetika', 'Tampilan yang mencerminkan gaya Anda', Colors.pink),
                  _buildCriteriaItem(Icons.airline_seat_recline_extra, 'Kenyamanan', 'Interior mewah atau sporty?', Colors.indigo),
                ],
              ),
            ),

            // ==========================================
            // 2.5 FITUR UNGGULAN SECTION
            // ==========================================
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'KEUNGGULAN',
                    style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  
                  // RichText untuk judul beda warna
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF111827),
                      ),
                      children: <TextSpan>[
                        const TextSpan(text: 'Fitur '),
                        TextSpan(
                          text: 'Unggulan ',
                          style: TextStyle(color: primaryColor), // Warna ungu
                        ),
                        const TextSpan(text: 'Aplikasi'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Daftar Card Fitur
                  _buildFeatureCard(
                    Icons.format_list_bulleted, 
                    'Penilaian Multi-Kriteria', 
                    'Evaluasi setiap model BMW berdasarkan 5 kriteria utama dengan bobot yang dapat disesuaikan sesuai prioritas Anda.'
                  ),
                  _buildFeatureCard(
                    Icons.insights, 
                    'Metode SMART', 
                    'Simple Multi-Attribute Rating Technique — metode ilmiah yang terbukti akurat untuk pengambilan keputusan multi-atribut.'
                  ),
                  _buildFeatureCard(
                    Icons.emoji_events, // Ikon piala
                    'Rekomendasi Terbaik', 
                    'Dapatkan hasil analisis lengkap dengan peringkat dan skor untuk setiap alternatif BMW yang tersedia.'
                  ),
                  _buildFeatureCard(
                    Icons.swap_vert, 
                    'Dua Tahap Seleksi', 
                    'Pilih seri berdasarkan gaya hidup, lalu tentukan kode bodi spesifik berdasarkan kriteria teknis & finansial.'
                  ),
                  _buildFeatureCard(
                    Icons.adjust, 
                    'Data dari Ahli', 
                    'Nilai alternatif didasarkan pada data nyata dari wawancara mekanik BMW dan riset marketplace.'
                  ),
                  _buildFeatureCard(
                    Icons.diamond_outlined, 
                    'Transparan & Akurat', 
                    'Breakdown perhitungan SMART ditampilkan lengkap — utility tiap kriteria, bobot, dan skor akhir.'
                  ),
                ],
              ),
            ),
            // ==========================================
            // 3. CARA KERJA SECTION
            // ==========================================
            Container(
              color: Colors.grey[50],
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'CARA KERJA',
                    style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tiga Langkah Mudah',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Proses sederhana untuk rekomendasi yang akurat dan transparan.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  
                  _buildStepItem('01', 'Pilih Model BMW', 'Evaluasi seri BMW yang ingin Anda pertimbangkan dari daftar yang tersedia.', primaryColor),
                  _buildStepItem('02', 'Tentukan Bobot Kriteria', 'Atur tingkat kepentingan setiap kriteria. Sistem normalisasi bobot otomatis.', primaryColor),
                  _buildStepItem('03', 'Lihat Rekomendasi', 'Sistem menghitung peringkat BMW terbaik lengkap dengan breakdown perhitungan.', primaryColor),
                ],
              ),
            ),

            // ==========================================
            // 4. CTA & FOOTER SECTION
            // ==========================================
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Siap menemukan BMW pertama Anda?',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Mulai konsultasi sekarang dan dapatkan rekomendasi yang tepat berdasarkan kebutuhan Anda.',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Mulai analisis sekarang →', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),

            // Footer Sesuai Request
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Text(
                '© 2026 BMW SPK — Sistem Pendukung Keputusan dibuat dengan metode SMART',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, {required bool isPurple}) {
    final Color primaryColor = const Color(0xFF5A58F2); // Warna ungu dari desainmu
    
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            // Jika isPurple true, pakai warna ungu. Jika tidak, pakai warna hitam/gelap.
            color: isPurple ? primaryColor : const Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center, // Teks di-center biar rapi kalau panjang
          style: TextStyle(fontSize: 11, color: Colors.grey[500]),
        ),
      ],
    );
  }

  // Widget Helper untuk Kriteria
  Widget _buildCriteriaItem(IconData icon, String title, String subtitle, MaterialColor color) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color.shade400),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ),
    );
  }

  // Widget Helper untuk Langkah Kerja
  Widget _buildStepItem(String number, String title, String description, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // Widget Helper untuk Fitur Unggulan
  Widget _buildFeatureCard(IconData icon, String title, String description) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF5A58F2), size: 28), // Ikon warna ungu
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }
}