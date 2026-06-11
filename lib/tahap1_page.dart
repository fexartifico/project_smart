import 'package:flutter/material.dart';

class Tahap1Page extends StatefulWidget {
  const Tahap1Page({super.key});

  @override
  State<Tahap1Page> createState() => _Tahap1PageState();
}

class _Tahap1PageState extends State<Tahap1Page> {
  final Color primaryColor = const Color(0xFF5A58F2);

  // Nilai default untuk masing-masing kriteria
  double _funToDrive = 20;
  double _gengsi = 20;
  double _kenyamanan = 20;
  double _fungsionalitas = 20;
  double _durabilitas = 20;

  // Menghitung total input secara dinamis
  double get _totalInput => _funToDrive + _gengsi + _kenyamanan + _fungsionalitas + _durabilitas;

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
                    const TextSpan(text: 'Home / '),
                    TextSpan(
                      text: 'Tahap 1',
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
                    const TextSpan(text: 'Tahap 1 — '),
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
                'Pilih model BMW yang ingin dianalisis, kemudian tentukan bobot untuk setiap kriteria penilaian sesuai prioritas Anda.',
                style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.5),
              ),
              const SizedBox(height: 24),

              // ==========================================
              // STEPPER INDICATOR
              // ==========================================
              Row(
                children: [
                  CircleAvatar(radius: 14, backgroundColor: primaryColor, child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
                  const SizedBox(width: 8),
                  const Text('Pilih Model & Bobot', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(width: 12),
                  Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1.5)),
                  const SizedBox(width: 12),
                  CircleAvatar(radius: 14, backgroundColor: Colors.grey.shade200, child: Text('2', style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.bold))),
                  const SizedBox(width: 8),
                  Text('Analisis SMART', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 24),

              // ==========================================
              // FORM CARD (SLIDER BOBOT)
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
                    RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.5),
                        children: const [
                          TextSpan(text: 'Tentukan tingkat kepentingan (0–100) setiap kriteria. '),
                          TextSpan(text: 'Geser slider sesuai prioritas Anda. Sistem akan otomatis menghitung proporsinya.', style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    _buildSliderItem('Fun to Drive', 'Seberapa penting sensasi berkendara yang sporty, responsif, dan menyenangkan bagi Anda?', _funToDrive, (val) => setState(() => _funToDrive = val)),
                    _buildSliderItem('Gengsi & Image Sosial', 'Seberapa penting kesan dan aura status sosial yang ditampilkan oleh seri BMW pilihan Anda?', _gengsi, (val) => setState(() => _gengsi = val)),
                    _buildSliderItem('Kenyamanan Kabin', 'Seberapa penting kenyamanan kabin — ruang kaki, keempukan jok, dan ketenangan interior?', _kenyamanan, (val) => setState(() => _kenyamanan = val)),
                    _buildSliderItem('Fungsionalitas Harian', 'Seberapa penting kemudahan parkir, kapasitas bagasi, dan kepraktisan untuk pemakaian kota sehari-hari?', _fungsionalitas, (val) => setState(() => _fungsionalitas = val)),
                    _buildSliderItem('Durabilitas & Keandalan', 'Seberapa penting ketahanan dan keandalan jangka panjang untuk pemakaian intensif?', _durabilitas, (val) => setState(() => _durabilitas = val)),

                    const SizedBox(height: 16),
                    Divider(color: Colors.grey.shade200),
                    const SizedBox(height: 16),

                    // TOTAL & BUTTONS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            children: [
                              const TextSpan(text: 'Total Input  '),
                              TextSpan(text: _totalInput.toInt().toString(), style: TextStyle(color: primaryColor, fontWeight: FontWeight.w900, fontSize: 18)),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.redo, size: 16),
                              label: const Text('Lewati'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey[700],
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Row(
                                children: [
                                  Text('Hitung Seri', style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(width: 6),
                                  Icon(Icons.arrow_forward, size: 16),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ==========================================
              // CARD: PILIHAN ANDA
              // ==========================================
              _buildSideCard(
                title: 'PILIHAN ANDA',
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Text(
                      'Klik Hitung Seri untuk melihat\nrekomendasi seri BMW',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[400], fontSize: 13),
                    ),
                  ),
                ),
              ),

              // ==========================================
              // CARD: BOBOT TERNORMALISASI
              // ==========================================
              _buildSideCard(
                title: 'BOBOT TERNORMALISASI',
                subtitle: 'Wi = wi / Σwi',
                child: Column(
                  children: [
                    _buildProgressRow('Fun to Drive', _funToDrive),
                    _buildProgressRow('Gengsi & Image Sosial', _gengsi),
                    _buildProgressRow('Kenyamanan Kabin', _kenyamanan),
                    _buildProgressRow('Fungsionalitas Harian', _fungsionalitas),
                    _buildProgressRow('Durabilitas & Keandalan', _durabilitas),
                  ],
                ),
              ),

              // ==========================================
              // CARD: TENTANG TAHAP 1
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
                    Text('Tentang Tahap 1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 8),
                    Text(
                      'Sistem SMART menghitung utility setiap seri BMW lalu memilih seri terbaik untuk dilanjutkan ke Tahap 2.',
                      style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget untuk Form Slider
  Widget _buildSliderItem(String title, String description, double value, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(4)),
                    child: Text('Benefit', style: TextStyle(color: Colors.green.shade700, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              Text(value.toInt().toString(), style: TextStyle(color: primaryColor, fontWeight: FontWeight.w900, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 8),
          Text(description, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: primaryColor,
              inactiveTrackColor: Colors.grey.shade200,
              thumbColor: primaryColor,
              overlayColor: primaryColor.withOpacity(0.2),
              trackHeight: 6.0,
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
              Text('0', style: TextStyle(color: Colors.grey[400], fontSize: 11)),
              Text('25', style: TextStyle(color: Colors.grey[400], fontSize: 11)),
              Text('50', style: TextStyle(color: Colors.grey[400], fontSize: 11)),
              Text('75', style: TextStyle(color: Colors.grey[400], fontSize: 11)),
              Text('100', style: TextStyle(color: Colors.grey[400], fontSize: 11)),
            ],
          )
        ],
      ),
    );
  }

  // Helper Widget untuk Card Samping (Pilihan Anda / Bobot Ternormalisasi)
  Widget _buildSideCard({required String title, String? subtitle, required Widget child}) {
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
          Text(title, style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(color: Colors.grey[700], fontSize: 13)),
              Text(percentText, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 13)),
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