import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appdata/Page/Login.dart';
import 'CheckQueuePage.dart';
import 'Income_year.dart';
// import 'MessagePage.dart';
// import 'Plot_List.dart';
import 'ProFilePage.dart';
import 'Promote_API.dart';
// import 'QR_scanner.dart';
import 'SettingPage.dart';

class ListView_Choice extends StatefulWidget {
  const ListView_Choice({super.key});

  @override
  State<ListView_Choice> createState() => _ListViewChoiceState();
}

class _ListViewChoiceState extends State<ListView_Choice> {
  int _selectedIndex = 0;
  DateTime? _lastPressedAt; // ตัวแปรจับเวลาสำหรับ Double Back to Exit

  static final List<Widget> _widgetOptions = <Widget>[
    const MainMenu(),
    const Income_year(showBackButton: false),
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
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        final now = DateTime.now();
        final maxDuration = const Duration(seconds: 2);

        if (_lastPressedAt == null || now.difference(_lastPressedAt!) > maxDuration) {
          _lastPressedAt = now;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('กดอีกครั้งเพื่อออกจากแอป'),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(bottom: 100, left: 20, right: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        } else {
          SystemNavigator.pop(); // ออกจากแอป
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        extendBody: true,

        body: IndexedStack(
          index: _selectedIndex,
          children: _widgetOptions,
        ),

        bottomNavigationBar: Container(
          // Logic: Margin ล่าง = 20 + Safe Area
          margin: EdgeInsets.fromLTRB(20, 0, 20, 20 + bottomPadding),
          decoration: BoxDecoration(
            color: Colors.transparent, // พื้นหลังใสเพื่อให้เห็นเงา
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
                  label: 'อ้อย(CCS)',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.person_rounded, color: Color(0xFFE13E53)),
                  icon: Icon(Icons.person_outline, color: Colors.grey),
                  label: 'info',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- Main Menu (หน้าหลัก) ---
class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE13E53),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60, left: 25, right: 25, bottom: 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE13E53), Color(0xFFFF6B6B)],
              ),
            ),
            child: Row(
              children: [
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
                  ),
                ),
                const SizedBox(width: 15),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ยินดีต้อนรับ",
                          style: TextStyle(fontSize: 16, color: Colors.white70)),
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
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Color(0xFFF5F7FA),
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
                      child: Text("เมนูต่างๆ",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                    ),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 3,
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
                        childAspectRatio: 0.85,
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
                          // Coming Soon Items
                          _buildModernMenuItem(
                            context,
                            icon: Icons.map_rounded,
                            label: 'รายการแปลง',
                            color: Colors.grey,
                            onPressed: () => _showCompactNotice(context, 'Coming Soon', 'ระบบรายการแปลง ยังไม่พร้อมใช้งาน', Icons.map_rounded),
                          ),
                          _buildModernMenuItem(
                            context,
                            icon: Icons.support_agent_rounded,
                            label: 'ส่งเสริม',
                            color: Colors.purple,
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Promote_API())),
                          ),
                          _buildModernMenuItem(
                            context,
                            icon: Icons.qr_code_scanner_rounded,
                            label: 'QR Code',
                            color: Colors.grey,
                            onPressed: () => _showCompactNotice(context, 'Coming Soon', 'ระบบ QR Code ยังไม่พร้อมใช้งาน', Icons.qr_code_scanner_rounded),
                          ),
                          _buildModernMenuItem(
                            context,
                            icon: Icons.newspaper_rounded,
                            label: 'ข่าวสาร',
                            color: Colors.grey,
                            onPressed: () => _showCompactNotice(context, 'Coming Soon', 'ระบบข่าวสาร ยังไม่พร้อมใช้งาน', Icons.newspaper_rounded),
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
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
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

  void _showCompactNotice(BuildContext context, String title, String message, IconData icon) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        // ใช้ Future.delayed เพื่อปิด dialog อัตโนมัติ โดยเช็ค mounted ก่อน
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
                curve: Curves.easeOutBack,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
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
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE13E53).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: const Color(0xFFE13E53), size: 24),
                    ),
                    const SizedBox(width: 15),
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