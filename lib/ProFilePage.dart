import 'package:flutter/material.dart';

import 'Login.dart';

class Profilepage extends StatefulWidget {
  final bool showBackButton;

  const Profilepage({super.key, this.showBackButton = true});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        automaticallyImplyLeading: false,
        title: const Text(
          'โปรไฟล์',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFE13E53),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                width: double.infinity,
                height: 150,
                decoration: const BoxDecoration(
                  color: Color(0xFFE13E53),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
              ),
              Positioned(
                top: 30,
                child: CircleAvatar(
                  radius: 90,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 85,
                    backgroundColor: Colors.grey.shade200,
                    child: Icon(
                      Icons.person,
                      size: 90,
                      color: Colors.grey.shade400, // Using better contrast color
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 80),

          // User Info Cards
          _buildInfoCard(
            label: "ชื่อ-นามสกุล",
            value: "นาย ธนวัฒน์ หนองงู",
            icon: Icons.person_outline,
          ),
          _buildInfoCard(
            label: "ที่อยู่",
            value: "บ.หนองบัวกลาง ต.จักราช อ.จักราช จ.นครราชสีมา",
            icon: Icons.location_on_outlined,
          ),
          _buildInfoCard(
            label: "อีเมล",
            value: "thanawat@rmuit.ac.th",
            icon: Icons.email_outlined,
          ),
          _buildInfoCard(
            label: "วันที่ลงทะเบียน",
            value: "13/11/2567",
            icon: Icons.calendar_today_outlined,
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (Route<dynamic> route) => false,
              );
            },
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text('ออกจากระบบ', style: TextStyle(fontSize: 18, color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE13E53).withOpacity(0.9),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 5,
            ),
          ),
          const SizedBox(height: 30),
        ]),
      ),
    );
  }

  // Reusable widget for creating user info cards
  Widget _buildInfoCard({required String label, required String value, required IconData icon}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFE13E53), size: 30),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
