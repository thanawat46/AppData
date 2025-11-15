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
        backgroundColor: Colors.white,
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: NavigationBar(
              height: 70,
              elevation: 0,
              backgroundColor: Colors.transparent,
              indicatorColor: const Color(0xFFE13E53),
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              destinations: const <Widget>[
                NavigationDestination(
                  selectedIcon: Icon(Icons.home, color: Colors.white),
                  icon: Icon(Icons.home_outlined),
                  label: 'หน้าหลัก',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.map, color: Colors.white),
                  icon: Icon(Icons.map_outlined),
                  label: 'รายการแปลง',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.person, color: Colors.white),
                  icon: Icon(Icons.person_outline),
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
    return Container(
      color: const Color(0xFFE13E53),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 100, bottom: 20),
            child: Text("ยินต้อนรับ\nนาย ธีรุตม์ ฝาสันเทียะ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  )),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: Text("เมนูรายการข้อมูลต่างๆ",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 60,
                      padding: const EdgeInsets.all(20),
                      children: <Widget>[
                        _buildMenuItem(
                          context,
                          icon: Icons.receipt_long,
                          label: 'อ้อย(CCS)',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Income_year()),
                            );
                          },
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.local_shipping,
                          label: 'คิวรถอ้อย',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const CheckQueuePage()),
                            );
                          },
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.map_outlined,
                          label: 'รายการแปลง',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PlotList()),
                            );
                          },
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.support_agent,
                          label: 'ส่งเสริม',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Promote_API()),
                            );
                          },
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.qr_code_scanner,
                          label: 'QR Code',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const QR_Scanner()),
                            );
                          },
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.newspaper,
                          label: 'ข่าวสาร',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Messagepage()),
                            );
                          },
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.info_outline,
                          label: 'Info',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Profilepage()),
                            );
                          },
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.settings,
                          label: 'ตั้งค่า',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Settingpage()),
                            );
                          },
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.logout,
                          label: 'ออกจากระบบ',
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                              (Route<dynamic> route) => false,
                            );
                          },
                        ),
                      ],
                    ),                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, {required IconData icon, required String label, required VoidCallback onPressed}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE13E53),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: onPressed,
              child: Icon(icon, size: 35),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
