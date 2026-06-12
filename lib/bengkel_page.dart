import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BengkelPage extends StatelessWidget {
  final List<Map<String, String>> dataBengkel = [
    {
      "nama": "Astra BMW Cilandak",
      "alamat": "Jl. R.A. Kartini No.Kav. 203, Jakarta Selatan",
      "spesialisasi": "Bengkel Resmi (Authorized). Rekomendasi utama untuk General Checkup (GCU) full-scanner.",
      "url_maps": "https://maps.app.goo.gl/4pcHHsY2kyUABhTG7"
    },
    {
      "nama": "Karunia Jaya Abadi Motor",
      "alamat": "Jl. RS. Fatmawati Raya No.30, Jakarta Selatan",
      "spesialisasi": "Gudang Sparepart & Copotan. Solusi hemat untuk komponen kaki-kaki dan body parts.",
      "url_maps": "https://maps.app.goo.gl/my2NGtM531mUtHo86"
    },
    {
      "nama": "BMW Tunas Tebet",
      "alamat": "Jl. Prof. DR. Soepomo No.174, Jakarta Selatan",
      "spesialisasi": "Bengkel Resmi (Authorized). Fokus pada servis berkala dan klaim garansi BSI.",
      "url_maps": "https://maps.app.goo.gl/rX9wGST1wEab1G7o7"
    },
    {
      "nama": "BMW East Tuning",
      "alamat": "Jl. Radin Inten II No.188 2, Jakarta Timur",
      "spesialisasi": "Spesialis Mekanikal Berat. Rujukan untuk turun mesin, transmisi, dan coding.",
      "url_maps": "https://maps.app.goo.gl/Q2zeBUfXQiUehiTH7"
    }
  ];

  BengkelPage({super.key});

  // Fungsi untuk buka Maps
  Future<void> _launchMaps(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Tidak bisa membuka $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bengkel Rekomendasi')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dataBengkel.length,
        itemBuilder: (context, index) {
          final bengkel = dataBengkel[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bengkel['nama']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(bengkel['alamat']!, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.blue.shade50,
                    child: Text('Spesialisasi: ${bengkel['spesialisasi']}', style: const TextStyle(fontSize: 12)),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => _launchMaps(bengkel['url_maps']!),
                    icon: const Icon(Icons.map),
                    label: const Text('Buka di Google Maps'),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}