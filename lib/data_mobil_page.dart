import 'package:flutter/material.dart';

class DataMobilPage extends StatefulWidget {
  const DataMobilPage({super.key});

  @override
  State<DataMobilPage> createState() => _DataMobilPageState();
}

class _DataMobilPageState extends State<DataMobilPage> {
  final Color primaryColor = const Color(0xFF5A58F2);
  String _selectedFilter = 'Semua';
  int _currentPage = 1;

  final List<String> _filters = ['Semua', 'Seri 2', 'Seri 3', 'Seri 4', 'Seri 5', 'Seri 7'];

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollLeft() {
    if (_scrollController.hasClients) {
      double newOffset = _scrollController.offset - 250;
      if (newOffset < 0) newOffset = 0;
      _scrollController.animateTo(
        newOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollRight() {
    if (_scrollController.hasClients) {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double newOffset = _scrollController.offset + 250;
      if (newOffset > maxScroll) newOffset = maxScroll;
      _scrollController.animateTo(
        newOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // 1. HEADER & FILTER SECTION
            // ==========================================
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      children: [
                        const TextSpan(text: 'Home / '),
                        TextSpan(
                          text: 'Data Mobil',
                          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // BUMBU 1: Judul dengan spacing rapat dan teks BMW bergaya Gradient
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF111827),
                        letterSpacing: -0.5, // Spasi rapat biar tegas
                      ),
                      children: <InlineSpan>[
                        const TextSpan(text: 'Data Mobil '),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFF5A58F2), Color(0xFF3B82F6)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds),
                            child: const Text(
                              'BMW',
                              style: TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Jelajahi koleksi lengkap BMW berdasarkan seri',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      InkWell(
                        onTap: _scrollLeft,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade100,
                          ),
                          child: Icon(Icons.chevron_left, color: Colors.grey[800], size: 20),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: _filters.map((filter) {
                              bool isActive = _selectedFilter == filter;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedFilter = filter;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 14),
                                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isActive ? primaryColor : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isActive ? primaryColor : Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Text(
                                    filter,
                                    style: TextStyle(
                                      color: isActive ? Colors.white : Colors.black87,
                                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: _scrollRight,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade100,
                          ),
                          child: Icon(Icons.chevron_right, color: Colors.grey[800], size: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ==========================================
            // 2. CAR LIST SECTION
            // ==========================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BUMBU 2: Label dengan letter spacing renggang
                  Text(
                    'KOLEKSI MOBIL',
                    style: TextStyle(
                      color: primaryColor, 
                      fontSize: 11, 
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5, // Spasi renggang biar premium
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pilihan Mobil BMW',
                    style: TextStyle(
                      fontSize: 28, 
                      fontWeight: FontWeight.w900, 
                      color: Colors.black87,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Temukan mobil impian Anda dari lineup BMW premium kami',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Menampilkan 1–3 dari 29 model',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 16),

                  _buildCarCard(
                    series: 'BMW Seri 2',
                    name: 'BMW Seri 2 (F22 218i)',
                    description: 'Menjadi gerbang paling masuk akal untuk memiliki mobil sport Eropa berkonfigurasi...',
                    transmission: 'Automatic',
                    bodyType: 'Coupe',
                    fuel: 'Bensin',
                  ),
                  _buildCarCard(
                    series: 'BMW Seri 2',
                    name: 'BMW Seri 2 (F22 220i)',
                    description: 'Membawa wujud coupe mungil yang sama gantengnya, namun dengan ekstra tenaga...',
                    transmission: 'Automatic',
                    bodyType: 'Coupe',
                    fuel: 'Bensin',
                  ),
                  _buildCarCard(
                    series: 'BMW Seri 2',
                    name: 'BMW Seri 2 (F44 218i Gran)',
                    description: 'Jawaban cerdas bagi Anda yang menginginkan kelincahan bodi mungil...',
                    transmission: 'Automatic',
                    bodyType: 'Gran coupe',
                    fuel: 'Bensin',
                  ),

                  const SizedBox(height: 24),
                  _buildPagination(),
                  const SizedBox(height: 40),
                ],
              ),
            ),

            // ==========================================
            // 3. WHY CHOOSE BMW SECTION
            // ==========================================
            Container(
              color: Colors.grey[50],
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label dengan letter spacing
                  Text(
                    'KEUNGGULAN',
                    style: TextStyle(
                      color: primaryColor, 
                      fontSize: 11, 
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Judul dengan gradient
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF111827),
                        letterSpacing: -0.5,
                      ),
                      children: <InlineSpan>[
                        const TextSpan(text: 'Kenapa Memilih '),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFF5A58F2), Color(0xFF3B82F6)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds),
                            child: const Text(
                              'BMW?',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dibalik setiap BMW tersimpan passion, teknologi, dan keunggulan tanpa kompromi.',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.5),
                  ),
                  const SizedBox(height: 24),

                  _buildWhyCard(Icons.star_border, 'Desain Premium', 'Siluet ikonik dengan proporsi sempurna, setiap lekukan dirancang untuk memukau dan aerodinamis.'),
                  _buildWhyCard(Icons.track_changes, 'Teknologi Canggih', 'BMW iDrive generasi terbaru, layar curved, dan AI driving assistant untuk pengalaman berkendara masa depan.'),
                  _buildWhyCard(Icons.bolt, 'Performa Tinggi', 'Mesin TwinPower Turbo bertenaga tinggi dengan respons spontan dan sensasi berkendara sporty yang tak tertandingi.'),
                  _buildWhyCard(Icons.location_on_outlined, 'Kenyamanan Berkendara', 'Kabin mewah dengan material premium, sistem suspensi adaptif, dan isolasi suara kelas satu.'),
                ],
              ),
            ),

            // ==========================================
            // 4. BOTTOM STATS & CTA SECTION
            // ==========================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2B449A), Color(0xFF3B82F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Platform SPK BMW Kami',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sistem rekomendasi cerdas berbasis metode SMART',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  
                  Row(
                    children: [
                      Expanded(child: _buildBlueStatCard(Icons.copy, '20+', 'Model BMW')),
                      const SizedBox(width: 16),
                      Expanded(child: _buildBlueStatCard(Icons.grid_view, '5', 'Kategori Mobil')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildBlueStatCard(Icons.person_outline, '200+', 'Pengguna Aktif')),
                      const SizedBox(width: 16),
                      Expanded(child: _buildBlueStatCard(Icons.lightbulb_outline, 'SMART', 'Metode Rekomendasi')),
                    ],
                  ),
                ],
              ),
            ),

            // ==========================================
            // 5. FOOTER
            // ==========================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              color: Colors.grey[50],
              child: Column(
                children: [
                  Text(
                    '© 2026 BMW SPK — Sistem Pendukung Keputusan dibuat dengan metode SMART',
                    style: TextStyle(color: Colors.grey[500], fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Laravel • Tailwind CSS',
                    style: TextStyle(color: Colors.grey[400], fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========================
  // HELPER WIDGETS
  // ========================

  Widget _buildCarCard({
    required String series,
    required String name,
    required String description,
    required String transmission,
    required String bodyType,
    required String fuel,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
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
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              'images/ilusi_bmw.png', 
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: double.infinity,
                height: 180,
                color: Colors.grey[200],
                child: const Icon(Icons.directions_car, size: 50, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  series,
                  style: TextStyle(
                    color: primaryColor, 
                    fontSize: 12, 
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 22, 
                    fontWeight: FontWeight.w900, 
                    color: Colors.black87,
                    letterSpacing: -0.5, // Spasi rapat biar tegas
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.5),
                ),
                const SizedBox(height: 16),
                
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildTag(Icons.settings_outlined, transmission, const Color(0xFF3B82F6)), // Biru untuk Transmisi
                    _buildTag(Icons.directions_car_outlined, bodyType, const Color(0xFFF59E0B)), // Oranye untuk Tipe Bodi
                    _buildTag(Icons.local_gas_station_outlined, fuel, const Color(0xFF10B981)), // Hijau untuk Bahan Baka
                  ],
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.visibility, size: 16, color: Colors.grey[700]),
                    label: Text('Lihat detail', style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1), // Latar belakang transparan tipis senada dengan warna ikon
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color), // Ikon berwarna
          const SizedBox(width: 6),
          Text(text, style: TextStyle(fontSize: 11, color: Colors.grey[800], fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('← Prev', style: TextStyle(color: Colors.grey[400], fontSize: 13)),
        const SizedBox(width: 16),
        _buildPageNumber(1),
        _buildPageNumber(2),
        _buildPageNumber(3),
        _buildPageNumber(4),
        _buildPageNumber(5),
        const SizedBox(width: 8),
        const Text('Next →', style: TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPageNumber(int number) {
    bool isActive = number == _currentPage;
    return GestureDetector(
      onTap: () => setState(() => _currentPage = number),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? primaryColor : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: isActive ? primaryColor : Colors.grey.shade300),
        ),
        child: Text(
          number.toString(),
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black87,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildWhyCard(IconData icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.blue.shade600, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black87, letterSpacing: -0.3),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBlueStatCard(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white70, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}