import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Login.dart';
import '../services/auth_storage_service.dart';

class Profilepage extends StatefulWidget {
  final bool showBackButton;
  final dynamic dataUser;

  const Profilepage({
    super.key,
    this.showBackButton = true,
    required this.dataUser,
  });

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  final Color primaryRed = const Color(0xFFE13E53);
  final Color secondaryRed = const Color(0xFFFF6B6B);
  final Color bgSoft = const Color(0xFFF5F7FA);

  // ฟังก์ชันแปลงวันที่ SysReg
  String _formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return "-";
    try {
      DateTime dt = DateTime.parse(isoDate);
      return DateFormat('dd/MM/yyyy').format(dt);
    } catch (e) {
      return isoDate;
    }
  }

  Widget _buildGlassButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.25),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String fullName = "ไม่พบข้อมูล";
    String email = "-";
    String address = "ไม่พบข้อมูลที่อยู่";
    String registerDate = "-";

    try {
      if (widget.dataUser != null &&
          widget.dataUser['data'] != null &&
          (widget.dataUser['data'] as List).isNotEmpty) {

        final user = widget.dataUser['data'][0];
        fullName = user['FullName'] ?? "ไม่พบชื่อผู้ใช้งาน";
        email = (user['Email'] != null && user['Email'].toString().trim().isNotEmpty)
            ? user['Email'].toString() : "-";
        address = user['Address'] ?? "-";
        registerDate = _formatDate(user['SysReg']); // ดึงวันที่ลงทะเบียน
      }
    } catch (e) {
      debugPrint("Error parsing dataUser: $e");
    }

    return Scaffold(
      backgroundColor: bgSoft,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: widget.showBackButton
            ? Container(
          margin: const EdgeInsets.only(left: 15),
          child: Center(
            child: _buildGlassButton(
              icon: Icons.arrow_back_ios_new,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
        )
            : null,
        title: const Text('โปรไฟล์', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 260,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [primaryRed, secondaryRed]),
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
                  ),
                ),
                Positioned(
                  bottom: -60,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 66,
                      backgroundColor: Colors.grey.shade100,
                      child: Icon(Icons.person, size: 80, color: Colors.grey.shade400),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 80),
            Text(fullName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),

            // Info Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _buildProfileItem(Icons.email_outlined, "อีเมล", email),
                    const Divider(height: 1, indent: 20, endIndent: 20),
                    _buildProfileItem(Icons.phone_outlined, "เบอร์โทรศัพท์", "081-234-5678"),
                    const Divider(height: 1, indent: 20, endIndent: 20),
                    _buildProfileItem(Icons.location_on_outlined, "ที่อยู่", address),
                    const Divider(height: 1, indent: 20, endIndent: 20),
                    _buildProfileItem(Icons.calendar_today_rounded, "วันที่ลงทะเบียน", registerDate),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: OutlinedButton.icon(
                onPressed: () => _handleLogout(context),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('ออกจากระบบ'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  foregroundColor: primaryRed,
                  side: BorderSide(color: primaryRed.withOpacity(0.5)),
                  shape: const StadiumBorder(),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.code, size: 14, color: Colors.grey[400]),
                    const SizedBox(width: 5),
                    Text("Designed & Developed by", style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Thanawat No & Teerut Fa",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    final AuthStorageService storageService = AuthStorageService();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("ยืนยันการออก"),
        content: const Text("คุณต้องการออกจากระบบใช่หรือไม่?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("ยกเลิก")),
          TextButton(
            onPressed: () async {
              await storageService.saveCredentials('', '', false);
              if (context.mounted) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginPage()), (r) => false);
            },
            child: Text("ออก", style: TextStyle(color: primaryRed)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Icon(icon, color: primaryRed, size: 22),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}