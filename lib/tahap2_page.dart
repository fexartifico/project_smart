import 'package:flutter/material.dart';
import 'api_service.dart';
import 'data_mobil_page.dart';
import 'hasil_analisis_page.dart';


class Tahap2Page extends StatefulWidget {

  final int seriId;
  final String seriNama;

  const Tahap2Page({
    super.key,
    required this.seriId,
    required this.seriNama,
  });

  @override
  State<Tahap2Page> createState() => _Tahap2PageState();
} 


class _Tahap2PageState extends State<Tahap2Page> {
  final Color primaryColor = const Color(0xFF5A58F2);
  List<dynamic> _kodeBodis = [];

  

  // Nilai default untuk slider Tahap 2
  double _harga = 20;
  double _biaya = 20;
  double _sukuCadang = 20;
  double _kehandalan = 20;
  double _efisiensi = 20;

  double get _totalInput => _harga + _biaya + _sukuCadang + _kehandalan + _efisiensi;

  // Status Checkbox untuk 4 mobil contoh
  List<bool> _selectedCars = [];
  bool _isLoading = false;
  Map<String, dynamic>? _hasilSmart; // Menyimpan hasil dari API
  bool get _isAllSelected => _selectedCars.every((element) => element);

  void _toggleSelectAll() {
    setState(() {
      bool newValue = !_isAllSelected;
      for (int i = 0; i < _selectedCars.length; i++) {
        _selectedCars[i] = newValue;
      }
    });
  }
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  Future<void> _loadData() async {

  final data =
      await ApiService().getTahap2(widget.seriId);

  if (data != null) {

    setState(() {

      _kodeBodis = data['kode_bodis'];

      _selectedCars =
          List.generate(_kodeBodis.length, (_) => false);

    });

  }
  
}
Future<void> _hitungSmart() async {

  final selectedIds = <int>[];

  for (int i = 0; i < _selectedCars.length; i++) {
    if (_selectedCars[i]) {
      selectedIds.add(_kodeBodis[i]['id']);
    }
  }

  if (selectedIds.length < 2) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pilih minimal 2 mobil'),
      ),
    );
    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {

    final hasil = await ApiService().postHitungTahap2({
      'seri_id': widget.seriId,
      'selected_mobil': selectedIds,
      'bobot': {
        'harga': _harga,
        'servis': _biaya,
        'sperpart': _sukuCadang,
        'durabilitas': _kehandalan,
        'bahan_bakar': _efisiensi,
      },
    });

    print('Selected: $selectedIds');
    print('Seri: ${widget.seriId}');
    print('Hasil: $hasil');

    if (hasil != null) {
      setState(() {
        _hasilSmart = hasil;
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menghitung. Periksa koneksi atau coba lagi.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }

  } catch (e) {
    print('Error _hitungSmart: $e');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi error: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  } finally {

    setState(() {
      _isLoading = false;
    });

  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Latar belakang abu-abu sangat muda
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // HEADER & BREADCRUMB
              // ==========================================
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  children: [
                    const TextSpan(text: 'Home / Tahap 1 / '),
                    TextSpan(
                      text: 'Tahap 2',
                      style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF111827),
                    letterSpacing: -0.5,
                  ),
                  children: <InlineSpan>[
                    const TextSpan(text: 'Tahap 2 — '),
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
                          'Pemilihan Mobil BMW',
                          style: TextStyle(
                            fontSize: 28,
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
                'Pilih mobil BMW yang ingin dianalisis, kemudian tentukan bobot untuk setiap kriteria penilaian sesuai prioritas Anda.',
                style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.5),
              ),
              const SizedBox(height: 24),

              // ==========================================
              // STEPPER INDICATOR (Tahap 1 Selesai, Tahap 2 Aktif)
              // ==========================================
              Row(
                children: [
                  const CircleAvatar(radius: 14, backgroundColor: Color(0xFF10B981), child: Icon(Icons.check, color: Colors.white, size: 16)),
                  const SizedBox(width: 8),
                  const Text('Pilih Model & Bobot', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                  const SizedBox(width: 12),
                  Expanded(child: Divider(color: primaryColor.withOpacity(0.3), thickness: 1.5)),
                  const SizedBox(width: 12),
                  CircleAvatar(radius: 14, backgroundColor: primaryColor, child: const Text('2', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
                  const SizedBox(width: 8),
                  Text('Analisis SMART', style: TextStyle(color: primaryColor, fontSize: 13, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 24),

              // ==========================================
              // CARD 1: PILIH MOBIL BMW
              // ==========================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child:Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.directions_car,
                                color: Colors.redAccent,
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Pilih Mobil BMW',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                        'Dari ${widget.seriNama}',
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),

                                    const SizedBox(height: 2),

                                    const Text(
                                      'Pilih minimal 2 model untuk dibandingkan',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              OutlinedButton.icon(
                                onPressed: _toggleSelectAll,
                                icon: Icon(
                                  _isAllSelected
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  size: 16,
                                ),
                                label: const Text('Pilih Semua'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: primaryColor,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                               '${_selectedCars.where((e) => e).length}/${_kodeBodis.length} dipilih',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                                          ),
                    const SizedBox(height: 20),
                    
                    Divider(color: Colors.grey.shade200, height: 1),
                    const SizedBox(height: 20),
                    
                    // List Mobil (Horizontal Scroll)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: List.generate(
                          _kodeBodis.length,
                          (index) {

                            final mobil = _kodeBodis[index];

                            return _buildSelectCarCard(
                              index,
                              mobil['nama_lengkap'],
                              mobil['tahun'].toString(),
                              mobil['gambar'],
                            );

                          },
                        ),
                      )
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ==========================================
              // CARD 2: FORM SLIDER BOBOT
              // ==========================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Bobot Kriteria Penilaian', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text('Tentukan tingkat kepentingan (0–100) setiap kriteria. Sistem akan otomatis menghitung proporsinya.', style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.5)),
                    const SizedBox(height: 32),

                    _buildSliderItem('Harga Pasar Kendaraan', 'Seberapa penting harga beli yang terjangkau sesuai budget Anda?', _harga, true, (val) => setState(() => _harga = val)),
                    _buildSliderItem('Biaya Rutin Tahunan', 'Seberapa penting menekan total pengeluaran wajib tahunan?', _biaya, true, (val) => setState(() => _biaya = val)),
                    _buildSliderItem('Ketersediaan Suku Cadang', 'Seberapa penting kemudahan mendapatkan suku cadang di pasaran lokal?', _sukuCadang, false, (val) => setState(() => _sukuCadang = val)),
                    _buildSliderItem('Kehandalan Mesin', 'Seberapa penting ketahanan mesin dalam jangka waktu panjang?', _kehandalan, false, (val) => setState(() => _kehandalan = val)),
                    _buildSliderItem('Efisiensi Konsumsi Bahan Bakar (km/liter)', 'Seberapa penting ketersediaan jenis bahan bakar yang mudah didapat dan efisien?', _efisiensi, false, (val) => setState(() => _efisiensi = val)),

                    const SizedBox(height: 16),
                    Divider(color: Colors.grey.shade200),
                    const SizedBox(height: 16),

                    // TOTAL & BUTTONS KEMBALI / HITUNG
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                                children: [
                                  const TextSpan(text: 'Total Bobot  '),
                                  TextSpan(
                                    text: _totalInput.toInt().toString(),
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            ElevatedButton(
                              onPressed:  _isLoading ? null : _hitungSmart,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isLoading ? primaryColor.withOpacity(0.4) : primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: _isLoading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Row(
                              
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.calculate, size: 16),
                                  SizedBox(width: 6),
                                  Text(
                                    'Hitung Smart',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_back, size: 16),
                            label: const Text('Kembali'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey[700],
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ==========================================
              // CARD 3: HASIL RANKING SMART
              // ==========================================
              _buildSideCard(
                title: 'HASIL RANKING SMART',
                iconTitle: Icons.emoji_events,
                child: _hasilSmart == null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Column(
                          children: [
                            const Icon(Icons.smart_toy, size: 40, color: Color(0xFF5A58F2)),
                            const SizedBox(height: 16),
                            Text(
                              'Hasil SMART akan muncul setelah Anda memilih BMW\ndan menekan tombol Hitung Smart.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[400], fontSize: 13, height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        // Ranking list dengan medal + progress bar
                        ...List.generate(
                          (_hasilSmart!['ranked'] as List).length,
                          (index) {
                            final ranked = _hasilSmart!['ranked'] as List;
                            final item = ranked[index];
                            final rank = (item['rank'] as num).toInt();
                            final skor = (item['skor'] as num).toDouble();
                            // Skor tertinggi untuk normalisasi progress bar
                            final maxSkor = (ranked.first['skor'] as num).toDouble();
                            final persen = maxSkor > 0 ? (skor / maxSkor) : 0.0;
                            final persenText = '${(skor * 100).toStringAsFixed(2)}%';

                            // Warna & icon medal per rank
                            Color medalColor;
                            IconData medalIcon;
                            Color progressColor;
                            if (rank == 1) {
                              medalColor = const Color(0xFFFFD700); // gold
                              medalIcon = Icons.emoji_events;
                              progressColor = const Color(0xFF5A58F2);
                            } else if (rank == 2) {
                              medalColor = const Color(0xFFB0B0B0); // silver
                              medalIcon = Icons.emoji_events;
                              progressColor = Colors.grey.shade400;
                            } else if (rank == 3) {
                              medalColor = const Color(0xFFCD7F32); // bronze
                              medalIcon = Icons.emoji_events;
                              progressColor = Colors.orange.shade300;
                            } else {
                              medalColor = Colors.grey.shade300;
                              medalIcon = Icons.directions_car;
                              progressColor = Colors.grey.shade300;
                            }

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: rank == 1
                                    ? const Color(0xFF5A58F2).withOpacity(0.06)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: rank == 1
                                      ? const Color(0xFF5A58F2).withOpacity(0.2)
                                      : Colors.grey.shade200,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Medal icon
                                  Icon(medalIcon, color: medalColor, size: 28),
                                  const SizedBox(width: 12),
                                  // Nama + tahun + progress bar
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['nama'] ?? '-',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        if (item['tahun'] != null)
                                          Text(
                                            item['tahun'].toString(),
                                            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                                          ),
                                        const SizedBox(height: 8),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: LinearProgressIndicator(
                                            value: persen.toDouble(),
                                            minHeight: 5,
                                            backgroundColor: Colors.grey.shade100,
                                            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Persentase skor
                                  Text(
                                    persenText,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15,
                                      color: rank == 1
                                          ? const Color(0xFF5A58F2)
                                          : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        // Tombol Simpan & Lihat Detail
                        SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HasilAnalisisPage(
            seriNama: widget.seriNama,
            hasilSmart: _hasilSmart!,
            bobot: {
              'harga': _harga,
              'servis': _biaya,
              'sperpart': _sukuCadang,
              'durabilitas': _kehandalan,
              'bahan_bakar': _efisiensi,
            },
          ),
        ),
      );
    },
    icon: const Icon(Icons.check_circle_outline, size: 18),
    label: const Text(
      'Simpan & Lihat Detail Hasil',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF10B981),
      foregroundColor: Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  ),
),
                      ],
                    ),
              ),

              // ==========================================
              // CARD 4: BOBOT TERNORMALISASI
              // ==========================================
              _buildSideCard(
                title: 'BOBOT TERNORMALISASI',
                child: Column(
                  children: [
                    _buildProgressRow('Harga Pasar Kendaraan', _harga),
                    _buildProgressRow('Biaya Rutin Tahunan', _biaya),
                    _buildProgressRow('Ketersediaan Suku Cadang', _sukuCadang),
                    _buildProgressRow('Kehandalan Mesin', _kehandalan),
                    _buildProgressRow('Efisiensi Konsumsi Bahan Bakar (km/liter)', _efisiensi),
                  ],
                ),
              ),

              // ==========================================
              // CARD 5: TENTANG TAHAP 2
              // ==========================================
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF2B449A), Color(0xFF3B82F6)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tentang Tahap 2', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 8),
                    Text(
                      'Sistem SMART menghitung utility setiap model BMW berdasarkan bobot kriteria yang Anda tentukan, lalu meranking semua alternatif dari skor tertinggi ke terendah.',
                      style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
                    ),
                  ],
                ),
              ),

              // ==========================================
              // FOOTER
              // ==========================================
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    '© 2026 BMW SPK — Sistem Pendukung Keputusan dibuat dengan metode SMART\nLaravel • Tailwind CSS',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[400], fontSize: 11, height: 1.6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget untuk Form Slider (Ditambah Parameter isCost untuk label Cost/Benefit)
  Widget _buildSliderItem(
  String title,
  String description,
  double value,
  bool isCost,
  ValueChanged<double> onChanged,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(width: 8),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: isCost
                    ? Colors.blue.shade50
                    : Colors.green.shade50,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                isCost ? 'Cost' : 'Benefit',
                style: TextStyle(
                  color: isCost
                      ? primaryColor
                      : Colors.green.shade700,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 12),

            Text(
              value.toInt().toString(),
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        Text(
          description,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 12,
          ),
        ),

        const SizedBox(height: 8),

        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: primaryColor,
            inactiveTrackColor: Colors.grey.shade200,
            thumbColor: primaryColor,
            overlayColor: primaryColor.withOpacity(0.2),
            trackHeight: 6,
          ),
          child: Slider(
            value: value,
            min: 0,
            max: 100,
            divisions: 100,
            onChanged: onChanged,
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '0',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 11,
              ),
            ),
            Text(
              '25',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 11,
              ),
            ),
            Text(
              '50',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 11,
              ),
            ),
            Text(
              '75',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 11,
              ),
            ),
            Text(
              '100',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

  // Helper Widget untuk Card Pilihan Mobil
  Widget _buildSelectCarCard(int index, String name, String year,String imagePath) {
    
    bool isSelected =
    index < _selectedCars.length
        ? _selectedCars[index]
        : false;
    
    return GestureDetector(
      onTap: () {
       setState(() {
        if (index < _selectedCars.length) {
      _selectedCars[index] = !_selectedCars[index];
    }
      });
      },
      child: Container(
        width: 210,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? primaryColor : Colors.grey.shade200, width: isSelected ? 2 : 1),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)), // Dikurangi sedikit biar pas dengan border
              child: Image.asset(
                'images/$imagePath', 
                width: double.infinity,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: double.infinity,
                  height: 120,
                  color: Colors.grey[200],
                  child: const Icon(Icons.directions_car, size: 40, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(year, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                  const SizedBox(height: 12),
                  
                  // Tags Mini
                  _buildMiniTag(Icons.settings_outlined, 'Automatic', const Color(0xFF3B82F6)),
                  const SizedBox(height: 4),
                  _buildMiniTag(Icons.directions_car_outlined, 'Sedan', const Color(0xFFF59E0B)),
                  const SizedBox(height: 4),
                  _buildMiniTag(Icons.local_gas_station_outlined, 'Bensin', const Color(0xFF10B981)),
                  const SizedBox(height: 16),
                  Center(
                    child: Icon(
                      isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                      color: isSelected ? primaryColor : Colors.grey[300],
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi Helper _buildMiniTag diupdate untuk menerima parameter warna
  Widget _buildMiniTag(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 12, color: color), // Ikon berwarna
        const SizedBox(width: 6),
        Text(text, style: TextStyle(fontSize: 10, color: Colors.grey[700], fontWeight: FontWeight.w600)),
      ],
    );
  }

  // Helper Widget untuk Card Samping
  Widget _buildSideCard({required String title, IconData? iconTitle, String? subtitle, required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (iconTitle != null) ...[
                Icon(iconTitle, color: Colors.orange.shade300, size: 18),
                const SizedBox(width: 8),
              ],
              Text(title, style: TextStyle(color: Colors.grey[700], fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(color: Colors.grey[400], fontSize: 11)),
          ],
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  // Helper Widget untuk Bar Persentase
  Widget _buildProgressRow(String title, double value) {
    double total = _totalInput > 0 ? _totalInput : 1;
    double percentage = value / total;
    String percentText = '${(percentage * 100).toStringAsFixed(1)}%';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
  children: [
    Expanded(
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 13,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    ),

    const SizedBox(width: 8),

    Text(
      percentText,
      style: TextStyle(
        color: primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
    ),
  ],
),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 6,
              backgroundColor: Colors.grey.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}