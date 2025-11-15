import 'package:flutter/material.dart';

class Messagepage extends StatefulWidget {
  const Messagepage({super.key});

  @override
  State<Messagepage> createState() => _MessagepageState();
}

class _MessagepageState extends State<Messagepage> {
  final List<Map<String, String>> tableData = [
    {'date': '15/07/67', 'details': 'ประกาศปิดปรับปรุงระบบ', 'more_info': 'ดูเพิ่มเติม'},
    {'date': '12/07/67', 'details': 'ข่าวสาร: เปิดตัวฟีเจอร์ใหม่', 'more_info': 'ดูเพิ่มเติม'},
    {'date': '10/07/67', 'details': 'โปรโมชั่นสำหรับสมาชิกใหม่', 'more_info': 'ดูเพิ่มเติม'},
    {'date': '05/07/67', 'details': 'แจ้งเตือนการบำรุงรักษาเซิร์ฟเวอร์', 'more_info': 'ดูเพิ่มเติม'},
    {'date': '05/07/67', 'details': 'แจ้งเตือนการบำรุงรักษาเซิร์ฟเวอร์', 'more_info': 'ดูเพิ่มเติม'},
    {'date': '05/07/67', 'details': 'แจ้งเตือนการบำรุงรักษาเซิร์ฟเวอร์', 'more_info': 'ดูเพิ่มเติม'},
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            "ข่าวสาร",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFFE13E53),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 3.0,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: InteractiveViewer(
              constrained: false,
              minScale: 1.0,
              maxScale: 1.0,
              child: Table(
                columnWidths: const {
                  0: IntrinsicColumnWidth(),
                  1: IntrinsicColumnWidth(),
                  2: IntrinsicColumnWidth(),
                },
                border: TableBorder(
                  horizontalInside: BorderSide(color: Colors.grey.shade200, width: 1),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey.shade100),
                    children: [
                      _buildTableCell('วัน/เดือน/ปี', isHeader: true),
                      _buildTableCell('รายละเอียด', isHeader: true),
                      _buildTableCell('ข้อมูลเพิ่มเติม', isHeader: true),
                    ],
                  ),
                  ...tableData.map((item) {
                    return TableRow(
                      children: [
                        _buildTableCell(item['date']!),
                        _buildTableCell(item['details']!),
                        _buildClickableCell(item['more_info']!, () {
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
    );
  }

  Widget _buildTableCell(String content, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
      child: Text(
        content,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? Colors.black87 : Colors.black54,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildClickableCell(String content, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE13E53),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
        ),
        child: Text(
          content,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
