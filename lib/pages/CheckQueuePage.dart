import 'package:flutter/material.dart';

class CheckQueuePage extends StatefulWidget {
  const CheckQueuePage({super.key});

  @override
  State<CheckQueuePage> createState() => _CheckQueuePageState();
}

class _CheckQueuePageState extends State<CheckQueuePage> {
  final Color primaryColor = const Color(0xFFE13E53);
  final Color backgroundColor = const Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          _buildCombinedHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              children: [
                _buildQueueCard(
                  title: 'คิวรถทางไกล',
                  roundInfo: 'รอบที่ 11 คิว 501',
                  currentQueue: '550',
                  totalQueue: '1100',
                  missedQueue: '451',
                  missedUntil: '500',
                  timeAgo: 'ประกาศแล้ว 5817:22 ชั่วโมง',
                  icon: Icons.local_shipping,
                ),
                const SizedBox(height: 16),
                _buildQueueCard(
                  title: 'คิวรถตัดอ้อย',
                  roundInfo: 'รอบที่ 38 คิวที่ 801',
                  currentQueue: '850',
                  totalQueue: '2000',
                  missedQueue: '751',
                  missedUntil: '800',
                  timeAgo: 'ประกาศแล้ว 5837:00 ชั่วโมง',
                  icon: Icons.agriculture,
                ),
                const SizedBox(height: 16),
                _buildQueueCard(
                  title: 'คิวอ้อยคนตัดในเขต',
                  roundInfo: 'รอบที่ 26 คิวที่ 301',
                  currentQueue: '350',
                  totalQueue: '800',
                  missedQueue: '251',
                  missedUntil: '300',
                  timeAgo: 'ประกาศแล้ว 5817:22 ชั่วโมง',
                  icon: Icons.person,
                ),
                const SizedBox(height: 20),
                _buildContactInfo(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCombinedHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                children: [
                  _buildGlassButton(
                    icon: Icons.arrow_back_ios_new,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  const Expanded(
                    child: Text(
                      'ตรวจสอบคิว',
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
                  const SizedBox(width: 40),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
              child: Column(
                children: [
                  const Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: Color(0xFFE13E53), size: 30),
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ยินดีต้อนรับ",
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          Text(
                            "นาย ธนวัฒน์ หนองงู",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.factory, color: Colors.white, size: 24),
                        SizedBox(width: 10),
                        Text(
                          "โรงน้ำตาลพิมาย (อุตสาหกรรมโคราช)",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

  Widget _buildQueueCard({
    required String title,
    required String roundInfo,
    required String currentQueue,
    required String totalQueue,
    required String missedQueue,
    required String missedUntil,
    required String timeAgo,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                      child: Icon(icon, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      title,
                      style: TextStyle(color: primaryColor, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: primaryColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    roundInfo,
                    style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildInfoItem("ถึงคิวที่", currentQueue, isHighlight: true)),
                    Container(width: 1, height: 40, color: Colors.grey[300]),
                    Expanded(child: _buildInfoItem("จากทั้งหมด", "$totalQueue คิว")),
                  ],
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Divider()),
                Row(
                  children: [
                    Expanded(child: _buildInfoItem("ตกคิวรับได้", "คิวที่ $missedQueue", textColor: Colors.orange[800])),
                    Container(width: 1, height: 40, color: Colors.grey[300]),
                    Expanded(child: _buildInfoItem("ถึงคิวที่", missedUntil, textColor: Colors.orange[800])),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 5),
                    Text(timeAgo, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, {bool isHighlight = false, Color? textColor}) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: isHighlight ? 24 : 18,
            fontWeight: FontWeight.bold,
            color: textColor ?? (isHighlight ? primaryColor : Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          const Text("ติดต่อสอบถาม", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 15),
          _buildContactRow(Icons.phone, "สอบถามคิว", "044-429400 ต่อ 334, 176"),
          const SizedBox(height: 10),
          _buildContactRow(Icons.radio, "สถานีวิทยุ", "088-4926009 (93.5 & 89.75 MHz)"),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: primaryColor, size: 20),
        const SizedBox(width: 10),
        Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w500)),
        Expanded(
          child: Text(value, style: TextStyle(color: Colors.grey[700]), overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}