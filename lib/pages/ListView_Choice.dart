import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_storage_service.dart';
import 'CheckQueuePage.dart';
import 'Income_year.dart';
import 'Login.dart';
import 'ProFilePage.dart';
import 'Promote_API.dart';
import 'SettingPage.dart';

class AppColors {
  static const Color primary = Color(0xFFE13E53);
  static const Color primaryLight = Color(0xFFFF6B6B);
  static const Color background = Color(0xFFF5F7FA);
  static const Color textDark = Color(0xFF2D3142);
}

class ListView_Choice extends StatefulWidget {
  final String username;
  const ListView_Choice({
    super.key,
    required this.username,
  });

  @override
  State<ListView_Choice> createState() => _ListViewChoiceState();
}

class _ListViewChoiceState extends State<ListView_Choice> {
  int _selectedIndex = 0;
  DateTime? _lastPressedAt;

  List<Widget> get _widgetOptions => <Widget>[
    MainMenu(username: widget.username),
    Income_year(showBackButton: false, username: widget.username),
    Profilepage(showBackButton: false, username: widget.username),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    HapticFeedback.selectionClick();

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        _handleDoubleBackToExit();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        extendBody: false,
        body: IndexedStack(
          index: _selectedIndex,
          children: _widgetOptions,
        ),
        bottomNavigationBar: _buildDockedNavigationBar(),
      ),
    );
  }

  Widget _buildDockedNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 65,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBorderBottomItem(
                index: 0,
                icon: Icons.home_rounded,
                label: 'หน้าหลัก',
              ),
              _buildBorderBottomItem(
                index: 1,
                icon: Icons.receipt_long_rounded,
                label: 'อ้อย(CCS)',
              ),
              _buildBorderBottomItem(
                index: 2,
                icon: Icons.person_rounded,
                label: 'Info',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBorderBottomItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? AppColors.primary : Colors.grey.shade400;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: double.infinity,
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedScale(
                      scale: isSelected ? 1.2 : 1.0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.fastOutSlowIn,
                      child: Icon(
                        icon,
                        color: color,
                        size: 26,
                      ),
                    ),
                    const SizedBox(height: 6),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontFamily: 'Prompt',
                        color: color,
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                      child: Text(label),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: isSelected ? Curves.easeOutBack : Curves.easeOut,
                height: 4,
                width: isSelected ? 25 : 0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.7),
                      AppColors.primary,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    )
                  ]
                  : [],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleDoubleBackToExit() {
    final now = DateTime.now();
    final maxDuration = const Duration(seconds: 2);

    if (_lastPressedAt == null || now.difference(_lastPressedAt!) > maxDuration) {
      _lastPressedAt = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('กดอีกครั้งเพื่อออกจากแอป'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } else {
      SystemNavigator.pop();
    }
  }
}

class MainMenu extends StatelessWidget {
  final String username;
  const MainMenu({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(25, 25, 25, 15),
                      child: Text(
                        "เมนูต่างๆ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 3,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        childAspectRatio: 0.85,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        children: <Widget>[
                          _buildMenuItem(context, icon: Icons.receipt_long_rounded, label: 'อ้อย(CCS)', color: Colors.orange, page: Income_year(username: username)),
                          _buildMenuItem(context, icon: Icons.local_shipping_rounded, label: 'คิวรถอ้อย', color: Colors.blue, page: const CheckQueuePage()),
                          _buildMenuItem(context, icon: Icons.map_rounded, label: 'รายการแปลง', color: Colors.grey, isComingSoon: true),
                          _buildMenuItem(context, icon: Icons.support_agent_rounded, label: 'ส่งเสริม', color: Colors.purple, page: Promote_API(username: username)),
                          _buildMenuItem(context, icon: Icons.qr_code_scanner_rounded, label: 'QR Code', color: Colors.grey, isComingSoon: true),
                          _buildMenuItem(context, icon: Icons.newspaper_rounded, label: 'ข่าวสาร', color: Colors.grey, isComingSoon: true),
                          _buildMenuItem(context, icon: Icons.info_outline_rounded, label: 'Info', color: Colors.teal, page: Profilepage(username: username)),
                          _buildMenuItem(context, icon: Icons.settings_rounded, label: 'ตั้งค่า', color: Colors.green, page: const Settingpage()),
                          _buildLogoutItem(context),
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

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryLight],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 20, 25, 30),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 36, color: AppColors.primary),
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
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Color color,
        Widget? page,
        bool isComingSoon = false,
      }) {
    return _BaseMenuButton(
      icon: icon,
      label: label,
      color: color,
      onPressed: () {
        if (isComingSoon) {
          _showCompactNotice(context, 'Coming Soon', 'ระบบ $label ยังไม่พร้อมใช้งาน', icon);
        } else if (page != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        }
      },
    );
  }

  Widget _buildLogoutItem(BuildContext context) {
    final AuthStorageService storageService = AuthStorageService();

    return _BaseMenuButton(
      icon: Icons.logout_rounded,
      label: 'ออกจากระบบ',
      color: AppColors.primary,
      isDestructive: true,
      onPressed: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: const Text("ยืนยันการออกจากระบบ"),
            content: const Text("คุณต้องการออกจากระบบใช่หรือไม่?\nข้อมูลการจดจำรหัสผ่านจะถูกล้างออก"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("ยกเลิก", style: TextStyle(color: Colors.grey))
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await storageService.saveCredentials('', '', false);
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                          (Route<dynamic> route) => false,
                    );
                  }
                },
                child: const Text("ออกจากระบบ", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
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
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        });
        return Center(
          child: Material(
            color: Colors.transparent,
            child: ScaleTransition(
              scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.primary.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10))
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: AppColors.primary, size: 24),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                          Text(message, style: TextStyle(fontSize: 12, color: Colors.grey.shade600), maxLines: 1, overflow: TextOverflow.ellipsis),
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

class _BaseMenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color color;
  final bool isDestructive;

  const _BaseMenuButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.color,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
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
          splashColor: color.withOpacity(0.1),
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
                child: Icon(icon, size: 28, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDestructive ? color : AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}