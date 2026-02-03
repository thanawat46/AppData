import 'package:flutter/material.dart';
import 'dart:math' as math;

// --- 1. Custom Painter ที่อัปเกรดให้ดูเหมือนแปลงที่ดินมากขึ้น ---
class PremiumPlotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. วาดเส้น Grid จางๆ เป็นพื้นหลัง (Map Grid)
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;

    double step = 20;
    for(double i = 0; i <= size.width; i+=step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for(double i = 0; i <= size.height; i+=step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    // 2. วาดรูปร่างแปลงที่ดิน
    final paintStroke = Paint()
      ..color = const Color(0xFFD32F2F) // เส้นขอบสีแดงเข้ม
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final paintFill = Paint()
      ..color = const Color(0xFFE53935).withOpacity(0.15) // ถมสีแดงจางๆ ข้างใน
      ..style = PaintingStyle.fill;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;

    // สร้างรูปทรงสี่เหลี่ยมข้าวหลามตัด (Diamond Shape)
    path.moveTo(center.dx, center.dy - radius); // Top
    path.lineTo(center.dx + radius, center.dy); // Right
    path.lineTo(center.dx, center.dy + radius); // Bottom
    path.lineTo(center.dx - radius, center.dy); // Left
    path.close();

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(math.pi / 5); // หมุนนิดหน่อยให้ดูสมจริง
    canvas.translate(-center.dx, -center.dy);

    // วาดสีพื้นและเส้นขอบ
    canvas.drawPath(path, paintFill);
    canvas.drawPath(path, paintStroke);
    final markerPaint = Paint()..color = const Color(0xFFD32F2F);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class PlotDetails extends StatefulWidget {
  const PlotDetails({super.key});

  @override
  State<PlotDetails> createState() => _PlotDetailsState();
}

class _PlotDetailsState extends State<PlotDetails> {

  // Theme Colors
  final Color primaryRed = const Color(0xFFE13E53);
  final Color bgSoft = const Color(0xFFF9FAFB);
  final Color textDark = const Color(0xFF2D3436);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgSoft,
      extendBodyBehindAppBar: true, // ให้ Body ทะลุขึ้นไปหลัง AppBar
      appBar: AppBar(
        title: const Text("รายละเอียดแปลง", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent, // โปร่งใสเพื่อให้เห็น Gradient ด้านหลัง
        foregroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- ส่วน Header และ แผนที่ ---
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                // 1. พื้นหลัง Gradient โค้งๆ
                Container(
                  width: double.infinity,
                  height: 260,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryRed, const Color(0xFFFF6B6B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                ),

                // 2. การ์ดแสดงแผนที่ (Map Card)
                Positioned(
                  top: 100, // ขยับลงมาจากด้านบน
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: primaryRed.withOpacity(0.2),
                          spreadRadius: 0,
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // พื้นที่วาดรูปแปลง
                        Center(
                          child: SizedBox(
                            width: 200,
                            height: 200,
                            child: CustomPaint(
                              painter: PremiumPlotPainter(), // ใช้ Painter ตัวใหม่
                            ),
                          ),
                        ),
                        // ปุ่มขยายแผนที่ (ตกแต่ง)
                        Positioned(
                          bottom: 15, right: 15,
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[100],
                            radius: 20,
                            child: Icon(Icons.fullscreen, color: primaryRed),
                          ),
                        ),
                        // ป้ายกำกับ
                        Positioned(
                          top: 15, left: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.orange.shade100)),
                            child: Text("GIS MAP", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.orange[800])),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),

            // ดันเนื้อหาลงมาให้พ้นส่วน Map Card (260 คือความสูง Header, -100 คือตำแหน่งวาง Map, +220 คือความสูง Map)
            // คำนวณคร่าวๆ คือประมาณ 80-100 px
            const SizedBox(height: 80),

            // --- ส่วนข้อมูลรายละเอียด (Info Cards) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  // แถวที่ 1: รหัสแปลง และ พื้นที่
                  Row(
                    children: [
                      Expanded(child: _buildDetailCard(Icons.qr_code, "รหัสแปลง", "1111111", Colors.blue)),
                      const SizedBox(width: 15),
                      Expanded(child: _buildDetailCard(Icons.landscape, "พื้นที่", "25 ไร่", Colors.green)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  // แถวที่ 2: พิกัด (เต็มความกว้าง)
                  _buildDetailCard(Icons.location_on, "ที่ตั้งแปลง", "111 / 5 ต.จักรราช อ.จักรราช\nจ.นครราชสีมา 30230", primaryRed, isFullWidth: true),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- ส่วนตารางกิจกรรม (Activity Table) ---
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // หัวข้อตาราง
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Row(
                      children: [
                        Icon(Icons.history, color: primaryRed),
                        const SizedBox(width: 10),
                        const Text("ประวัติกิจกรรม", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // ส่วนหัวคอลัมน์
                  Container(
                    color: Colors.red.shade50.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                    child: const Row(
                      children: [
                        Expanded(flex: 2, child: Text("กิจกรรม", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                        Expanded(flex: 2, child: Text("คำอธิบาย", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                        Expanded(flex: 2, child: Text("วันที่", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                      ],
                    ),
                  ),
                  // ข้อมูลในตาราง (สมมติข้อมูล)
                  _buildTableRow("ใส่ปุ๋ย", "สูตร 15-15-15", "12 ม.ค. 67"),
                  _buildTableRow("รดน้ำ", "ระบบหยด", "15 ม.ค. 67"),
                  _buildTableRow("ตัดอ้อย", "แปลง A1", "20 ก.พ. 67", isLast: true),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- Widget: การ์ดข้อมูล (Icon + Title + Value) ---
  Widget _buildDetailCard(IconData icon, String title, String value, Color color, {bool isFullWidth = false}) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        crossAxisAlignment: isFullWidth ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                const SizedBox(height: 2),
                Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textDark)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTableRow(String activity, String desc, String date, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(activity, style: TextStyle(fontWeight: FontWeight.bold, color: textDark))),
          Expanded(flex: 2, child: Text(desc, style: TextStyle(color: Colors.grey[600], fontSize: 13))),
          Expanded(flex: 2, child: Text(date, textAlign: TextAlign.right, style: TextStyle(color: primaryRed, fontWeight: FontWeight.bold, fontSize: 13))),
        ],
      ),
    );
  }
}