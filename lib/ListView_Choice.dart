import 'package:appdata/Login.dart';
import 'package:flutter/material.dart';
import 'CheckQueuePage.dart';
import 'Income_year.dart';
import 'MessagePage.dart';
import 'Plot_List.dart';
import 'ProFilePage.dart';
import 'Promote_API.dart';
import 'QR_scanner.dart';
import 'SettingPage.dart';

class ListView_Choice extends StatefulWidget {
  const ListView_Choice({super.key});

  @override
  State<ListView_Choice> createState() => _State();
}

class _State extends State<ListView_Choice> {
  int _selectedIndex = 0;

  // Widget Options
  static final List<Widget> _widgetOptions = <Widget>[
    const MainMenu(),
    const PlotList(showBackButton: false),
    const Profilepage(showBackButton: false),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: IndexedStack(
          index: _selectedIndex,
          children: _widgetOptions,
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE13E53).withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: NavigationBar(
              height: 70,
              elevation: 0,
              backgroundColor: Colors.white,
              indicatorColor: const Color(0xFFE13E53).withOpacity(0.1),
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: const <Widget>[
                NavigationDestination(
                  selectedIcon: Icon(Icons.home_rounded, color: Color(0xFFE13E53)),
                  icon: Icon(Icons.home_outlined, color: Colors.grey),
                  label: 'หน้าหลัก',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.receipt_long_rounded, color: Color(0xFFE13E53)),
                  icon: Icon(Icons.receipt_long_outlined, color: Colors.grey),
                  label: 'CCS',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.person_rounded, color: Color(0xFFE13E53)),
                  icon: Icon(Icons.person_outline, color: Colors.grey),
                  label: 'โปรไฟล์',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE13E53), // สีพื้นหลังด้านบน
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60, left: 25, right: 25, bottom: 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE13E53), Color(0xFFFF6B6B)], // ไล่สีแดง -> ส้มแดง
              ),
            ),
            child: Row(
              children: [
                // รูปโปรไฟล์ (Avatar)
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Color(0xFFE13E53)),
                    // ถ้ามีรูปจริงใช้: backgroundImage: NetworkImage('url'),
                  ),
                ),
                const SizedBox(width: 15),
                // ข้อความต้อนรับ
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ยินดีต้อนรับ",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70)),
                      Text("นาย ธีรุตม์ ฝาสันเทียะ",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- ส่วนเนื้อหา (เมนู) ---
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Color(0xFFF5F7FA), // พื้นหลังเทาอ่อน
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  )),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(25, 25, 25, 10),
                      child: Text("บริการหลัก",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                    ),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 3,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        childAspectRatio: 0.85, // ปรับสัดส่วนการ์ดให้สวยงาม
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        children: <Widget>[
                          _buildModernMenuItem(
                            context,
                            icon: Icons.receipt_long_rounded,
                            label: 'อ้อย(CCS)',
                            color: Colors.orange,
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Income_year())),
                          ),
                          _buildModernMenuItem(
                            context,
                            icon: Icons.local_shipping_rounded,
                            label: 'คิวรถอ้อย',
                            color: Colors.blue,
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckQueuePage())),
                          ),
                          // --- 1. รายการแปลง (เปลี่ยนเป็น Popup) ---
                          _buildModernMenuItem(
                            context,
                            icon: Icons.map_rounded,
                            label: 'รายการแปลง',
                            color: Colors.grey,
                            onPressed: () {
                              _showCompactNotice(
                                context,
                                'Coming Soon',
                                'ระบบรายการแปลง ยังไม่พร้อมใช้งาน',
                                Icons.map_rounded,
                              );
                            },
                          ),
                          _buildModernMenuItem(
                            context,
                            icon: Icons.support_agent_rounded,
                            label: 'ส่งเสริม',
                            color: Colors.purple,
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Promote_API())),
                          ),
                          // --- 2. QR Code (เปลี่ยนเป็น Popup) ---
                          _buildModernMenuItem(
                            context,
                            icon: Icons.qr_code_scanner_rounded,
                            label: 'QR Code',
                            color: Colors.grey,
                            onPressed: () {
                              _showCompactNotice(
                                context,
                                'Coming Soon',
                                'ระบบ QR Code ยังไม่พร้อมใช้งาน',
                                Icons.qr_code_scanner_rounded,
                              );
                            },
                          ),
                          // --- 3. ข่าวสาร (เปลี่ยนเป็น Popup) ---
                          _buildModernMenuItem(
                            context,
                            icon: Icons.newspaper_rounded,
                            label: 'ข่าวสาร',
                            color: Colors.grey,
                            onPressed: () {
                              _showCompactNotice(
                                context,
                                'Coming Soon',
                                'ระบบข่าวสาร ยังไม่พร้อมใช้งาน',
                                Icons.newspaper_rounded,
                              );
                            },
                          ),
                          _buildModernMenuItem(
                            context,
                            icon: Icons.info_outline_rounded,
                            label: 'Info',
                            color: Colors.teal,
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Profilepage())),
                          ),
                          _buildModernMenuItem(
                            context,
                            icon: Icons.settings_rounded,
                            label: 'ตั้งค่า',
                            color: Colors.green,
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Settingpage())),
                          ),
                          _buildModernMenuItem(
                            context,
                            icon: Icons.logout_rounded,
                            label: 'ออกจากระบบ',
                            color: const Color(0xFFE13E53),
                            isDestructive: true,
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginPage()),
                                    (Route<dynamic> route) => false,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget สร้างปุ่มเมนูแบบใหม่ (Card Style)
  Widget _buildModernMenuItem(BuildContext context,
      {required IconData icon,
        required String label,
        required VoidCallback onPressed,
        Color color = const Color(0xFFE13E53),
        bool isDestructive = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // วงกลมพื้นหลังไอคอน
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: isDestructive ? color.withOpacity(0.1) : color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              // ข้อความ
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDestructive ? color : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- ฟังก์ชันแสดง Dialog แบบ Compact สวย กะทัดรัด (แบบ Capsule) ---
  void _showCompactNotice(BuildContext context, String title, String message, IconData icon) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withOpacity(0.3), // พื้นหลังจางๆ ไม่มืดเกินไป
      transitionDuration: const Duration(milliseconds: 250), // เด้งขึ้นเร็วๆ
      pageBuilder: (context, animation, secondaryAnimation) {

        // ตั้งเวลาปิดอัตโนมัติ 1.5 วินาที
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        });

        return Center(
          child: Material(
            color: Colors.transparent,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutBack, // เอฟเฟกต์เด้งดึ๋ง
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50), // ทรงแคปซูล
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE13E53).withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ไอคอนซ้าย
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE13E53).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: const Color(0xFFE13E53), size: 24),
                    ),
                    const SizedBox(width: 15),
                    // ข้อความขวา
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3142),
                            ),
                          ),
                          Text(
                            message,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}