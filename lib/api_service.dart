import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Gunakan 10.0.2.2 khusus untuk Emulator Android agar bisa tembus ke Laravel di laptop
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // ==========================================
  // 1. FUNGSI UNTUK MENYIMPAN & MENGAMBIL TOKEN
  // ==========================================
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // ==========================================
  // 2. FUNGSI REGISTER
  // ==========================================
  Future<bool> register(String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/register'); 
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json', // Wajib untuk Laravel
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          await saveToken(data['token']); 
        }
        return true;
      } else {
        print('Register gagal: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error koneksi Register: $e');
      return false;
    }
  }

  // ==========================================
  // 3. FUNGSI LOGIN (EMAIL & PASSWORD)
  // ==========================================
  Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json', // Wajib untuk Laravel
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          await saveToken(data['token']); 
          return true;
        }
        return false;
      } else {
        print('Login ditolak server: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error koneksi Login: $e');
      return false;
    }
  }

  
  // ==========================================
  // 4. FUNGSI AMBIL DATA MOBIL (BISA UNTUK GUEST)
  // ==========================================
  Future<List<dynamic>> getMobil() async {
    final url = Uri.parse('$baseUrl/mobil'); 
    final token = await getToken();

    // ZOY NOTE: Hapus atau komentari baris `if (token == null) return [];`
    // Biarkan aplikasi tetap jalan ke try-catch meski tanpa token.

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          // Selipkan token hanya JIKA token-nya ada (user sudah login)
          if (token != null) 'Authorization': 'Bearer $token', 
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data; 
      } else {
        print('Gagal ambil data mobil: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetch mobil: $e');
      return [];
    }
  }
  // ==========================================
  // 5. FUNGSI AMBIL PROFIL USER (ME)
  // ==========================================
  Future<Map<String, dynamic>?> getUserProfile() async {
    final url = Uri.parse('$baseUrl/me');
    final token = await getToken();

    if (token == null) return null;

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Mengembalikan data user
      }
      return null;
    } catch (e) {
      print('Error ambil profil: $e');
      return null;
    }
  }

  // ==========================================
  // 6. FUNGSI LOGOUT LARAVEL
  // ==========================================
  Future<void> logout() async {
    final url = Uri.parse('$baseUrl/logout');
    final token = await getToken();

    if (token != null) {
      try {
        await http.post(
          url,
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      } catch (e) {
        print('Error logout Laravel: $e');
      }
    }
    await removeToken(); // Wajib hapus token dari memori HP
  }
  // --- SPK TAHAP 1 ---
  Future<Map<String, dynamic>?> getKriteriaTahap1() async {
    final response = await http.get(Uri.parse('$baseUrl/kriteria/tahap1'), headers: {'Accept': 'application/json'});
    return response.statusCode == 200 ? jsonDecode(response.body) : null;
  }

  Future<Map<String, dynamic>?> postHitungTahap1(
  Map<String, double> bobot) async {

  final token = await getToken();

  final response = await http.post(
    Uri.parse('$baseUrl/spk/tahap1'),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'bobot': bobot,
    }),
  );

  print('=== POST TAHAP 1 ===');
  print('Token: $token');
  print('Status: ${response.statusCode}');
  print('Body: ${response.body}');
  print('====================');

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  return null;
}

  // --- SPK TAHAP 2 ---
  Future<Map<String, dynamic>?> getKriteriaTahap2(int seriId) async {
    final response = await http.get(Uri.parse('$baseUrl/kriteria/tahap2?seri_id=$seriId'), headers: {'Accept': 'application/json'});
    return response.statusCode == 200 ? jsonDecode(response.body) : null;
  }

  Future<Map<String, dynamic>?> postHitungTahap2(Map<String, dynamic> payload) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/spk/tahap2'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    return response.statusCode == 200 ? jsonDecode(response.body) : null;
  }
  Future<Map<String, dynamic>?> getTahap2(int seriId) async {

  final token = await getToken();

  final response = await http.get(
    Uri.parse('$baseUrl/kriteria/tahap2?seri_id=$seriId'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  return null;
}
}