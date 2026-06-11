import 'package:flutter/material.dart';
import 'dart:ui'; // Untuk scroll pakai mouse di Windows
import 'homepage.dart';
import 'data_mobil_page.dart';
import 'tahap1_page.dart';
import 'tahap2_page.dart';
import 'login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';



class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {

  int _selectedIndex = 0;
  final Color primaryColor = const Color(0xFF5A58F2);
  User? get user => FirebaseAuth.instance.currentUser;

  Future<void> _logout() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();

    setState(() {
      _selectedIndex = 0;
    });

    if (mounted) {
      Navigator.pop(context);
    }
  }

  // Daftar halaman yang akan berubah saat menu sidebar diklik
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    DataMobilPage(),
    Tahap1Page(),
    Tahap2Page(),
    LoginPage(), 
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Menutup sidebar secara otomatis setelah menu dipilih
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.adjust_rounded, color: primaryColor),
            const SizedBox(width: 8),
            const Text(
              'Bimmer Guide',
              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),

      // END DRAWER (Sidebar Kanan)
      endDrawer: Drawer(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(left: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // ==========================================
            // HEADER SIDEBAR: PROFILE CARD MASA KINI
            // ==========================================
            Container(
              padding: const EdgeInsets.fromLTRB(24, 64, 24, 24),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA), // Latar abu-abu sangat muda
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
              child: Row(
                children: [
                  // Foto Profil dengan Bingkai Gradient
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF5A58F2), Color(0xFF3B82F6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                     child: CircleAvatar(
                        radius: 26,
                        backgroundColor: const Color(0xFFE0E7FF),
                        backgroundImage: user?.photoURL != null
                            ? NetworkImage(user!.photoURL!)
                            : null,
                        child: user?.photoURL == null
                            ? const Icon(
                                Icons.person_rounded,
                                size: 32,
                                color: Color(0xFF5A58F2),
                              )
                            : null,
                      ),
                                          ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Nama dan Status
                  // Nama dan Status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user != null
                              ? 'Halo, ${user!.displayName ?? "User"}'
                              : 'Halo, Guest',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.black87,
                            letterSpacing: -0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        if (user != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            user!.email ?? '',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],

                        const SizedBox(height: 6),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.green.shade200,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.green.shade500,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                user != null ? 'Online' : 'Guest',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Ikon panah kecil untuk kesan bisa di-klik ke menu profil
                  Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
                ],
              ),
            ),

            // ==========================================
            // ISI MENU SIDEBAR (Tetap dengan Warna Ikon)
            // ==========================================
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 12),
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildDrawerItem(0, Icons.home_rounded, 'Home', const Color(0xFF3B82F6)),
                  _buildDrawerItem(1, Icons.directions_car_rounded, 'Data Mobil', const Color(0xFFF59E0B)),
                  _buildDrawerItem(2, Icons.calculate_rounded, 'Tahap 1: Hitung', const Color(0xFF10B981)),
                  _buildDrawerItem(3, Icons.analytics_rounded, 'Tahap 2: Analisis', const Color(0xFF8B5CF6)),
                  
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Divider(color: Color(0xFFEEEEEE), thickness: 1),
                  ),
                  
                  if (user == null)
                _buildDrawerItem(
                  4,
                  Icons.person,
                  'Login / Daftar',
                  const Color(0xFF64748B),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: InkWell(
                    onTap: _logout,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.logout_rounded,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ],
              ),
            ),
          ],
        ),
      ),

      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }

  // ==========================================
  // HELPER WIDGET UNTUK TOMBOL MENU
  // ==========================================
  Widget _buildDrawerItem(int index, IconData icon, String title, Color iconColor) {
    bool isSelected = _selectedIndex == index;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () => _onItemTapped(index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor.withOpacity(0.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor.withOpacity(0.15) : iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? primaryColor : iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? primaryColor : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}