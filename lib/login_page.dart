import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'main_layout.dart';
import 'api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;
  final Color primaryColor = const Color(0xFF5A58F2);

  // Login controllers
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  bool _loginPasswordVisible = false;
  bool _rememberMe = false;

  // Register controllers
  final _registerNameController = TextEditingController();
  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _registerConfirmController = TextEditingController();
  bool _registerPasswordVisible = false;
  bool _registerConfirmVisible = false;

  // Fungsi untuk memproses Register API
  Future<void> _processLogin() async {
    final email = _loginEmailController.text;
    final password = _loginPasswordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password wajib diisi!')),
      );
      return;
    }

    // Tampilkan loading muter-muter
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Panggil API
    final success = await ApiService().login(email, password);
    
    if (!mounted) return;
    Navigator.pop(context); // Tutup loading

    if (success) {
      // Jika berhasil, arahkan ke MainLayout
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainLayout()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login gagal. Cek email & password kamu.')),
      );
    }
  }

  // ==========================================
  // FUNGSI PROSES REGISTER
  // ==========================================
  Future<void> _processRegister() async {
    final name = _registerNameController.text;
    final email = _registerEmailController.text;
    final password = _registerPasswordController.text;
    final confirmPassword = _registerConfirmController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua kolom wajib diisi!')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password dan Konfirmasi tidak sama!')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Cari baris ini di dalam _processRegister()
    final success = await ApiService().register(name, email, password); // Hapus confirmPassword
    
    if (!mounted) return;
    Navigator.pop(context);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Daftar berhasil! Silakan masuk.')),
      );
      // Geser otomatis ke tab 'Masuk' (index 0)
      _tabController.animateTo(0); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Daftar gagal. Coba lagi.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registerNameController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _registerConfirmController.dispose();
    super.dispose();
  }
  Future<void> _signInWithGoogle() async {
    try {
      // 1. Memanggil popup pilihan akun Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // User membatalkan login

      // 2. Mengambil detail autentikasi
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 3. Login ke Firebase
      await FirebaseAuth.instance.signInWithCredential(credential);
      
      // 4. Jika berhasil, pindah ke MainLayout (Halaman Utama)
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const MainLayout(),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      // Menampilkan pesan error jika gagal
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login gagal: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4FF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            // Logo & Brand
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.adjust_rounded, color: primaryColor, size: 36),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bimmer ',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Guide',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Sistem Pendukung Keputusan Pemilihan BMW',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Card utama
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.08),
                      blurRadius: 30,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Tab Bar
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F4FF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Colors.transparent,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey[600],
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          tabs: const [
                            Tab(text: 'Masuk'),
                            Tab(text: 'Daftar'),
                          ],
                        ),
                      ),
                    ),

                    // Tab Content
                    SizedBox(
                      height: 460,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildLoginForm(),
                          _buildRegisterForm(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ========================
  // FORM LOGIN
  // ========================
   Widget _buildLoginForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Teks sambutan dibungkus Center
            Center(
              child: Column(
                children: [
                  const Text(
                    'Selamat datang kembali!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Masuk untuk melanjutkan',
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _buildLabel('Email'),
            _buildTextField(
              controller: _loginEmailController,
              hint: 'contoh@email.com',
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 14),

            _buildLabel('Password'),
            _buildPasswordField(
              controller: _loginPasswordController,
              hint: '••••••••',
              isVisible: _loginPasswordVisible,
              onToggle: () => setState(() => _loginPasswordVisible = !_loginPasswordVisible),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: Checkbox(
                        value: _rememberMe,
                        onChanged: (v) => setState(() => _rememberMe = v ?? false),
                        activeColor: primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        side: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('Ingat saya', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Lupa password?',
                    style: TextStyle(fontSize: 12, color: primaryColor, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _processLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.login_rounded, size: 18),
                    SizedBox(width: 8),
                    Text('Masuk', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey.shade200)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('atau', style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                ),
                Expanded(child: Divider(color: Colors.grey.shade200)),
              ],
            ),
            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: _signInWithGoogle, // <--- Cukup tulis nama fungsinya di sini!
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/logo_google1.png', 
                      width: 24, 
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Lanjutkan dengan Google',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========================
  // FORM REGISTER
  // ========================
  Widget _buildRegisterForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Teks sambutan dibungkus Center
            Center(
              child: Column(
                children: [
                  const Text(
                    'Buat akun baru',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Daftar gratis dan mulai analisis BMW',
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _buildLabel('Nama Lengkap'),
            _buildTextField(
              controller: _registerNameController,
              hint: 'Nama kamu',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 12),

            _buildLabel('Email'),
            _buildTextField(
              controller: _registerEmailController,
              hint: 'contoh@email.com',
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 12),

            _buildLabel('Password'),
            _buildPasswordField(
              controller: _registerPasswordController,
              hint: 'Min. 8 karakter',
              isVisible: _registerPasswordVisible,
              onToggle: () => setState(() => _registerPasswordVisible = !_registerPasswordVisible),
            ),
            const SizedBox(height: 12),

            _buildLabel('Konfirmasi Password'),
            _buildPasswordField(
              controller: _registerConfirmController,
              hint: 'Ulangi password',
              isVisible: _registerConfirmVisible,
              onToggle: () => setState(() => _registerConfirmVisible = !_registerConfirmVisible),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFF7B79F7), primaryColor],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _processRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_add_rounded, size: 18),
                      SizedBox(width: 8),
                      Text('Daftar Sekarang', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'Dengan mendaftar, kamu menyetujui syarat & ketentuan kami',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Colors.grey[400]),
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
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
        prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
        filled: true,
        fillColor: const Color(0xFFF8F8FE),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
        prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[400], size: 20),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: Colors.grey[400], size: 20),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: const Color(0xFFF8F8FE),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }
}