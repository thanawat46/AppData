import 'dart:async';
import 'package:flutter/material.dart';
import '../models/data_model.dart';
import '../repositories/cane_repository.dart';

class CheckQueuePage extends StatefulWidget {
  final String? fullName;
  final dynamic dataUser;
  const CheckQueuePage({
    super.key,
    this.fullName,
    required this.dataUser,
  });

  @override
  State<CheckQueuePage> createState() => _CheckQueuePageState();
}

class _CheckQueuePageState extends State<CheckQueuePage> {
  final Color primaryColor = const Color(0xFFE13E53);
  final Color backgroundColor = const Color(0xFFF5F5F5);
  final CaneRepository _repository = CaneRepository();

  Map<String, RobshowData> _uniqueQueues = {};
  bool _isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchAllQueuesSequentially();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchAllQueuesSequentially({bool isAutoRefresh = false}) async {
    try {
      if (!isAutoRefresh && _uniqueQueues.isEmpty)
        setState(() => _isLoading = true);

      Map<String, RobshowData> filterMap = {};
      List<String> typeIds = ["1", "2", "3", "4", "5", "6", "7"];

      for (String id in typeIds) {
        try {
          final data = await _repository.getQueueStatus(id);
          for (var item in data) {
            String key = item.carTypeName;
            if (!filterMap.containsKey(key) ||
                (int.tryParse(item.robNum.toString()) ?? 0) >
                    (int.tryParse(filterMap[key]!.robNum.toString()) ?? 0)) {
              filterMap[key] = item;
            }
          }
        } catch (e) {
          debugPrint("ID $id error: $e");
        }
      }

      if (mounted) {
        setState(() {
          _uniqueQueues = filterMap;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String processRealtimeBase60(dynamic robTimeData) {
    if (robTimeData == null || robTimeData.toString().isEmpty) return "0:00";
    try {
      String strValue = robTimeData.toString();
      if (strValue.contains('T')) strValue = strValue.split('T').last;
      List<String> parts = strValue.split(':');
      if (parts.length < 2) return "0:00";

      int startH = int.parse(parts[0]);
      int startM = int.parse(parts[1]);

      final now = DateTime.now();
      DateTime startTime =
      DateTime(now.year, now.month, now.day, startH, startM);

      if (startTime.isAfter(now)) {
        startTime = startTime.subtract(const Duration(days: 1));
      }

      final diff = now.difference(startTime);
      int totalMinutes = diff.inMinutes;

      if (totalMinutes < 0) return "0:00";

      int hours = totalMinutes ~/ 60;
      int minutes = totalMinutes % 60;

      return "$hours:${minutes.toString().padLeft(2, '0')}";
    } catch (e) {
      return "0:00";
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayList = _uniqueQueues.values.toList()
      ..sort((a, b) => a.carTypeName.compareTo(b.carTypeName));

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          _buildCombinedHeader(),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: primaryColor))
                : displayList.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
              onRefresh: () =>
                  _fetchAllQueuesSequentially(isAutoRefresh: true),
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
                itemCount: displayList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildQueueCard(displayList[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueCard(RobshowData q) {
    Color cardThemeColor = q.carTypeName.contains("ตัด")
        ? Colors.orange.shade700
        : (q.carTypeName.contains("เขต") ? Colors.blue.shade700 : primaryColor);
    IconData icon = q.carTypeName.contains("ตัด")
        ? Icons.agriculture_rounded
        : (q.carTypeName.contains("เขต")
        ? Icons.person_pin_circle_rounded
        : Icons.local_shipping_rounded);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: cardThemeColor.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        children: [
          _buildCardHeader(q, cardThemeColor, icon),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: _buildInfoItem(
                            "จากคิวที่", "${q.robStartQ}", cardThemeColor)),
                    Container(width: 1, height: 40, color: Colors.grey[200]),
                    Expanded(
                        child: _buildInfoItem(
                            "ถึงคิวที่", "${q.robEndQ}", cardThemeColor)),
                  ],
                ),
                const Divider(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history_toggle_off_rounded,
                        size: 18, color: cardThemeColor),
                    const SizedBox(width: 8),
                    Text(
                      "ประกาศแล้ว: ${processRealtimeBase60(q.robTime)} ชั่วโมง",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardHeader(RobshowData q, Color themeColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
          color: themeColor.withOpacity(0.05),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Container(
                padding: const EdgeInsets.all(8),
                decoration:
                BoxDecoration(color: themeColor, shape: BoxShape.circle),
                child: Icon(icon, color: Colors.white, size: 18)),
            const SizedBox(width: 12),
            Text(q.carTypeName,
                style: TextStyle(
                    color: themeColor,
                    fontSize: 17,
                    fontWeight: FontWeight.bold)),
          ]),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: themeColor.withOpacity(0.2))),
              child: Text("รอบที่ ${q.robNum}",
                  style: TextStyle(
                      color: themeColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w800))),
        ],
      ),
    );
  }

  Widget _buildEmptyState() => Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.inbox_rounded, size: 60, color: Colors.grey[300]),
        const SizedBox(height: 10),
        const Text("ไม่พบข้อมูลคิวในขณะนี้",
            style: TextStyle(color: Colors.grey))
      ]));

  Widget _buildCombinedHeader() {
    String displayName = widget.fullName ?? "ไม่พบชื่อผู้ใช้งาน";

    try {
      if (widget.fullName == null &&
          widget.dataUser != null &&
          widget.dataUser['data'] != null &&
          (widget.dataUser['data'] as List).isNotEmpty) {

        final user = widget.dataUser['data'][0];
        displayName = user['FullName'] ?? "ไม่ได้ระบุชื่อ";
      }
    } catch (e) {
      debugPrint("Error parsing Name in CheckQueuePage: $e");
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30))),
      child: SafeArea(
        bottom: false,
        child: Column(children: [
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Row(children: [
              _buildGlassButton(
                  icon: Icons.arrow_back_ios_new,
                  onTap: () => Navigator.of(context).pop()),
              const Expanded(
                  child: Text('สถานะคิวทั้งหมด',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22))),
              const SizedBox(width: 40),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
            child: Row(children: [
              const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child:
                  Icon(Icons.person, color: Color(0xFFE13E53), size: 30)),
              const SizedBox(width: 15),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text("ยินดีต้อนรับ",
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
                Text(
                  displayName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ])
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, Color themeColor) =>
      Column(children: [
        Text(label,
            style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Text(value,
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: themeColor,
                letterSpacing: -0.5))
      ]);

  Widget _buildGlassButton(
      {required IconData icon, required VoidCallback onTap}) =>
      GestureDetector(
          onTap: onTap,
          child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: Colors.white, size: 20)));
}
