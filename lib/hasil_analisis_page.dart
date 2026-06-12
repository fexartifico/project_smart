import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class HasilAnalisisPage extends StatefulWidget {
  final String seriNama;
  final Map<String, dynamic> hasilSmart; // hasil dari API (berisi 'ranked')
  final Map<String, double> bobot; // bobot kriteria yang digunakan

  const HasilAnalisisPage({
    super.key,
    required this.seriNama,
    required this.hasilSmart,
    required this.bobot,
  });

  @override
  State<HasilAnalisisPage> createState() => _HasilAnalisisPageState();
}

class _HasilAnalisisPageState extends State<HasilAnalisisPage> {
  final Color primaryColor = const Color(0xFF5A58F2);
  bool _isGenerating = false;

  List get _ranked => widget.hasilSmart['ranked'] as List;

  String get _tanggalAnalisis =>
    DateFormat('dd MMMM yyyy, HH:mm').format(DateTime.now());

  // ==========================================
  // GENERATE & SIMPAN PDF
  // ==========================================
  Future<void> _generatePdf() async {
    setState(() => _isGenerating = true);

    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (context) => [
            // Header
            pw.Text(
              'Hasil Analisis SMART - BMW Bimmer Guide',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 4),
            pw.Text('Seri: ${widget.seriNama}',
                style: const pw.TextStyle(fontSize: 12)),
            pw.Text('Tanggal Analisis: $_tanggalAnalisis',
                style: const pw.TextStyle(fontSize: 12)),
            pw.SizedBox(height: 16),

            // Tabel Ranking
            pw.Text('Ranking Hasil Analisis',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey400),
              columnWidths: {
                0: const pw.FlexColumnWidth(0.8),
                1: const pw.FlexColumnWidth(3),
                2: const pw.FlexColumnWidth(1.5),
                3: const pw.FlexColumnWidth(1.5),
              },
              children: [
                // Header row
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    _pdfCell('Rank', bold: true),
                    _pdfCell('Mobil', bold: true),
                    _pdfCell('Tahun', bold: true),
                    _pdfCell('Skor', bold: true),
                  ],
                ),
                // Data rows
                ..._ranked.map((item) {
                  final skor = (item['skor'] as num).toDouble();
                  return pw.TableRow(
                    children: [
                      _pdfCell('${item['rank']}'),
                      _pdfCell('${item['nama'] ?? '-'}'),
                      _pdfCell('${item['tahun'] ?? '-'}'),
                      _pdfCell('${(skor * 100).toStringAsFixed(2)}%'),
                    ],
                  );
                }),
              ],
            ),

            pw.SizedBox(height: 24),

            // Bobot Kriteria
            pw.Text('Bobot Kriteria yang Digunakan',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey400),
              columnWidths: {
                0: const pw.FlexColumnWidth(3),
                1: const pw.FlexColumnWidth(1.5),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    _pdfCell('Kriteria', bold: true),
                    _pdfCell('Bobot', bold: true),
                  ],
                ),
                ...widget.bobot.entries.map((e) => pw.TableRow(
                      children: [
                        _pdfCell(_labelKriteria(e.key)),
                        _pdfCell(e.value.toStringAsFixed(0)),
                      ],
                    )),
              ],
            ),

            pw.SizedBox(height: 24),

            // Kesimpulan
            if (_ranked.isNotEmpty) ...[
              pw.Text('Kesimpulan',
                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text(
                'Berdasarkan analisis SMART, mobil dengan rekomendasi terbaik dari '
                '${widget.seriNama} adalah ${_ranked.first['nama'] ?? '-'} '
                'dengan skor ${((_ranked.first['skor'] as num) * 100).toStringAsFixed(2)}%.',
                style: const pw.TextStyle(fontSize: 12),
              ),
            ],

            pw.SizedBox(height: 32),
            pw.Divider(),
            pw.Text(
              'Dokumen ini dihasilkan otomatis oleh aplikasi Bimmer Guide - SPK BMW (Metode SMART)',
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
            ),
          ],
        ),
      );

      // Simpan ke storage
      final dir = await getApplicationDocumentsDirectory();
      final fileName =
          'Hasil_SMART_${widget.seriNama.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(await pdf.save());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF tersimpan: $fileName'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'Buka',
            textColor: Colors.white,
            onPressed: () => OpenFilex.open(file.path),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membuat PDF: $e'), backgroundColor: Colors.redAccent),
      );
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  pw.Widget _pdfCell(String text, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  String _labelKriteria(String key) {
    const labels = {
      'harga': 'Harga Pasar Kendaraan',
      'servis': 'Biaya Rutin Tahunan',
      'sperpart': 'Ketersediaan Suku Cadang',
      'durabilitas': 'Kehandalan Mesin',
      'bahan_bakar': 'Efisiensi Bahan Bakar',
    };
    return labels[key] ?? key;
  }

  // ==========================================
  // UI
  // ==========================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Detail Hasil Analisis',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF5A58F2), Color(0xFF3B82F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hasil Analisis SMART',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Seri: ${widget.seriNama}',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  Text(
                    'Tanggal: $_tanggalAnalisis',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Rekomendasi Utama
            if (_ranked.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF5A58F2).withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF5A58F2).withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.emoji_events, color: Color(0xFFFFD700), size: 36),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Rekomendasi Terbaik',
                              style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(
                            '${_ranked.first['nama'] ?? '-'}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                          ),
                          if (_ranked.first['tahun'] != null)
                            Text('${_ranked.first['tahun']}', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                        ],
                      ),
                    ),
                    Text(
                      '${((_ranked.first['skor'] as num) * 100).toStringAsFixed(2)}%',
                      style: const TextStyle(color: Color(0xFF5A58F2), fontWeight: FontWeight.w900, fontSize: 20),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),

            // Tabel Ranking Lengkap
            _buildCard(
              title: 'RANKING LENGKAP',
              child: Column(
                children: List.generate(_ranked.length, (index) {
                  final item = _ranked[index];
                  final skor = (item['skor'] as num).toDouble();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: index == 0
                              ? const Color(0xFFFFD700).withOpacity(0.2)
                              : Colors.grey.shade100,
                          child: Text(
                            '${item['rank']}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: index == 0 ? const Color(0xFFB8860B) : Colors.grey[600],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${item['nama'] ?? '-'}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              if (item['tahun'] != null)
                                Text('${item['tahun']}', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                            ],
                          ),
                        ),
                        Text(
                          '${(skor * 100).toStringAsFixed(2)}%',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            color: index == 0 ? primaryColor : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),

            // Bobot Kriteria
            _buildCard(
              title: 'BOBOT KRITERIA YANG DIGUNAKAN',
              child: Column(
                children: widget.bobot.entries.map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_labelKriteria(e.key), style: const TextStyle(fontSize: 13)),
                        Text(e.value.toStringAsFixed(0),
                            style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Export PDF
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isGenerating ? null : _generatePdf,
                icon: _isGenerating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.picture_as_pdf_outlined),
                label: Text(_isGenerating ? 'Membuat PDF...' : 'Unduh sebagai PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}