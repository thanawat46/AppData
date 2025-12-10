import 'package:flutter/material.dart';

class Messagepage extends StatefulWidget {
  const Messagepage({super.key});

  @override
  State<Messagepage> createState() => _MessagepageState();
}

class _MessagepageState extends State<Messagepage> {
  // Theme Colors
  final Color primaryColor = const Color(0xFFE13E53);
  final Color secondaryRed = const Color(0xFFFF6B6B);
  final Color backgroundColor = const Color(0xFFF5F7FA);

  // ข้อมูลจำลอง
  final List<Map<String, String>> tableData = [
    {'date': '15/07/67', 'details': 'ประกาศปิดปรับปรุงระบบประจำเดือน เพื่ออัปเกรดประสิทธิภาพ Server', 'type': 'alert'},
    {'date': '12/07/67', 'details': 'ข่าวสาร: เปิดตัวฟีเจอร์ใหม่ สแกน QR Code ได้รวดเร็วยิ่งขึ้น', 'type': 'news'},
    {'date': '10/07/67', 'details': 'โปรโมชั่นสำหรับสมาชิกใหม่ รับส่วนลดทันที 500 บาท', 'type': 'promo'},
    {'date': '05/07/67', 'details': 'แจ้งเตือนการบำรุงรักษา', 'type': 'system'},
    {'date': '05/07/67', 'details': 'สรุปยอดประจำเดือนมิถุนายนตรวจสอบได้ที่เมนูรายงาน', 'type': 'report'},
    {'date': '05/07/67', 'details': 'แจ้งเตือนความปลอดภัย: กรุณาเปลี่ยนรหัสผ่าน', 'type': 'alert'},
    {'date': '01/07/67', 'details': 'ยินดีต้อนรับเข้าใช้งาน Application', 'type': 'news'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // 1. พื้นหลังไล่สีด้านบน (Gradient Background)
          Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, secondaryRed],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // 2. ส่วนหัว (Custom Header)
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
                          "ข่าวสาร",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            shadows: [Shadow(offset: Offset(0, 1), blurRadius: 3.0, color: Colors.black26)],
                          ),
                        ),
                      ),
                      const SizedBox(width: 40), // จัดสมดุล Title
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // 3. พื้นที่แสดงตาราง (Content Area)
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: Column(
                          children: [
                            // การ์ดครอบตาราง
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.grey.shade100),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 32),
                                    child: Table(
                                      // กำหนดความกว้างคอลัมน์
                                      columnWidths: const {
                                        0: FixedColumnWidth(90),  // วันที่
                                        1: FixedColumnWidth(260), // รายละเอียด
                                        2: FixedColumnWidth(80),  // ปุ่ม
                                      },
                                      border: TableBorder(
                                        horizontalInside: BorderSide(color: Colors.grey.shade100, width: 1),
                                      ),
                                      children: [
                                        // --- Header Row ---
                                        TableRow(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFF0F0), // สีพื้นหลังหัวตารางจางๆ
                                            border: Border(bottom: BorderSide(color: primaryColor.withOpacity(0.2))),
                                          ),
                                          children: [
                                            _buildHeaderCell('วันที่'),
                                            _buildHeaderCell('รายละเอียด'),
                                            _buildHeaderCell('เพิ่มเติม'),
                                          ],
                                        ),

                                        // --- Data Rows ---
                                        ...tableData.asMap().entries.map((entry) {
                                          final index = entry.key;
                                          final item = entry.value;
                                          return TableRow(
                                            decoration: BoxDecoration(
                                              color: index.isEven ? Colors.white : const Color(0xFFFAFAFA),
                                            ),
                                            children: [
                                              _buildDataCell(
                                                item['date']!,
                                                isDate: true,
                                                type: item['type']!, // ส่ง type ไปเลือกสี/ไอคอน
                                              ),
                                              _buildDataCell(item['details']!, align: TextAlign.left),
                                              _buildButtonCell(() {
                                                print("กดดูข่าว: ${item['details']}");
                                              }),
                                            ],
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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

  // --- Widget Helpers ---

  // ปุ่มย้อนกลับสไตล์ Glassmorphism
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

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: primaryColor, // ใช้สีแดงธีม
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildDataCell(String text, {TextAlign align = TextAlign.center, bool isDate = false, String? type}) {
    // เลือกไอคอนตามประเภทข่าว
    IconData? typeIcon;
    Color iconColor = Colors.grey;

    if (isDate && type != null) {
      switch (type) {
        case 'alert': typeIcon = Icons.warning_rounded; iconColor = Colors.orange; break;
        case 'news': typeIcon = Icons.campaign_rounded; iconColor = Colors.blue; break;
        case 'promo': typeIcon = Icons.card_giftcard_rounded; iconColor = Colors.purple; break;
        case 'report': typeIcon = Icons.assignment_rounded; iconColor = Colors.green; break;
        default: typeIcon = Icons.info_outline; break;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: isDate
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (typeIcon != null) Icon(typeIcon, size: 18, color: iconColor),
          if (typeIcon != null) const SizedBox(height: 4),
          Text(text, textAlign: align, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87)),
        ],
      )
          : Text(
        text,
        textAlign: align,
        style: const TextStyle(color: Colors.black87, fontSize: 13, height: 1.4),
      ),
    );
  }

  Widget _buildButtonCell(VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Center(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [primaryColor, secondaryRed]),
              shape: BoxShape.circle, // ปุ่มวงกลมเล็กๆ
              boxShadow: [
                BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 3))
              ],
            ),
            child: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.white),
          ),
        ),
      ),
    );
  }
}