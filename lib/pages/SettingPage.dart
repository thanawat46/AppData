import 'package:flutter/material.dart';
import 'ResetPasswordPage.dart';

class Settingpage extends StatefulWidget {
  const Settingpage({super.key});

  @override
  State<Settingpage> createState() => _SettingpageState();
}

class _SettingpageState extends State<Settingpage> {
  // Theme Colors
  final Color primaryRed = const Color(0xFFE13E53);
  final Color secondaryRed = const Color(0xFFFF6B6B);
  final Color bgSoft = const Color(0xFFF5F7FA);

  // เพิ่ม Widget Glass Button สำหรับใช้ในหน้านี้
  Widget _buildGlassButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.25), // เอฟเฟกต์กระจกฝ้า
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgSoft,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        // แก้ไขส่วน leading เรียกใช้ _buildGlassButton แทน Container เดิม
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Center(
            child: _buildGlassButton(
              icon: Icons.arrow_back_ios_new,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        title: const Text(
          "การตั้งค่า",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryRed, secondaryRed],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- หมวดหมู่: บัญชีผู้ใช้ ---
            _buildSectionHeader("บัญชีผู้ใช้"),
            const SizedBox(height: 10),

            // เมนูเปลี่ยนรหัสผ่าน
            _buildSettingCard(
              icon: Icons.lock_outline_rounded,
              title: "เปลี่ยนรหัสผ่าน",
              subtitle: "แก้ไขรหัสผ่านเพื่อความปลอดภัย",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Resetpasswordpage()),
                );
              },
            ),

            const SizedBox(height: 25),

            // --- หมวดหมู่: แอปพลิเคชัน ---
            _buildSectionHeader("แอปพลิเคชัน"),
            const SizedBox(height: 10),

            _buildSettingCard(
              icon: Icons.info_outline_rounded,
              title: "เกี่ยวกับแอป",
              subtitle: "เวอร์ชัน 1.0.0",
              showArrow: false,
              onTap: () {},
            ),

            const SizedBox(height: 40),

            // --- Footer ---
            Center(
              child: Column(
                children: [
                  Text("KI Sugar Smart Farmer", style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text("Version 1.0.0", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 5),
      child: Text(
        title,
        style: TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool showArrow = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: primaryRed.withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(icon, color: primaryRed, size: 24),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                      ],
                    ],
                  ),
                ),
                if (showArrow)
                  Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}