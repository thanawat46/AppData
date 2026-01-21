import 'package:flutter/material.dart';

class QR_Scanner extends StatefulWidget {
  const QR_Scanner({super.key});

  @override
  State<QR_Scanner> createState() => _QR_ScannerState();
}

class _QR_ScannerState extends State<QR_Scanner> {
  // จำลองข้อมูล
  String _scannedCode = "รอการสแกน...";
  String _managerName = "-";

  // Theme Colors
  final Color primaryColor = const Color(0xFFE13E53);
  final Color backgroundColor = const Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backgroundColor,
      // ปุ่มยืนยัน (Floating Action Button)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: ใส่ Logic เมื่อกดยืนยัน
          print('Confirm button pressed');
        },
        backgroundColor: primaryColor,
        elevation: 4,
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        label: const Text(
          "ยืนยันข้อมูล",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // 1. พื้นหลังไล่สีด้านบน (Background)
          Container(
            height: size.height * 0.35, // กินพื้นที่ 35% ของจอ
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, const Color(0xFFFF6B6B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
          ),

          // 2. เนื้อหาหลัก (Content)
          SafeArea(
            child: Column(
              children: [
                // --- ส่วนหัว (Custom Header) ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                  child: Row(
                    children: [
                      _buildGlassButton(
                        icon: Icons.arrow_back_ios_new,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      const Expanded(
                        child: Text(
                          'สแกน QR Code',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 1),
                                blurRadius: 3.0,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 40), // จัดสมดุล Title
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // --- พื้นที่ Scanner (Scanner Card) ---
                Container(
                  width: size.width * 0.8,
                  height: size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // จำลองพื้นที่กล้อง (Camera Placeholder)
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.grey[100],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.qr_code_scanner, size: 80, color: Colors.grey[300]),
                              const SizedBox(height: 10),
                              Text("เปิดกล้อง...", style: TextStyle(color: Colors.grey[400])),
                            ],
                          ),
                        ),

                        // กรอบเล็ง (Visual Frame) - ตกแต่งให้ดูเหมือนกำลังสแกน
                        Container(
                          width: size.width * 0.6,
                          height: size.width * 0.6,
                          decoration: BoxDecoration(
                            border: Border.all(color: primaryColor.withOpacity(0.5), width: 2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                "วาง QR Code ให้ตรงกรอบ",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  backgroundColor: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // --- ส่วนแสดงผลข้อมูล (Info Panel) ---
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "ผลลัพธ์การสแกน",
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _scannedCode,
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.person, color: Colors.grey[600], size: 20),
                              const SizedBox(width: 8),
                              Text(
                                "ผู้จัดการ: $_managerName",
                                style: TextStyle(color: Colors.grey[800], fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  // Widget: ปุ่มย้อนกลับสไตล์ Glassmorphism
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
}