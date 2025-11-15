import 'package:flutter/material.dart';
import 'dart:math' as math;

class RotatedSquarePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black45
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.5;

    path.moveTo(center.dx, center.dy - radius); // Top
    path.lineTo(center.dx + radius, center.dy); // Right
    path.lineTo(center.dx, center.dy + radius); // Bottom
    path.lineTo(center.dx - radius, center.dy); // Left
    path.close();

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(math.pi / 5); // Rotate by 36 degrees
    canvas.translate(-center.dx, -center.dy);
    canvas.drawPath(path, paint);
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
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.of(context).pop();
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("รายละเอียดแปลง"),
        centerTitle: true,
        backgroundColor: const Color(0xFFE13E53),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                Positioned(
                  top: 35,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.70,
                    height: MediaQuery.of(context).size.width * 0.70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE13E53)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: CustomPaint(
                          painter: RotatedSquarePainter(),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.75 - 90),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoChip("รหัสแปลง : 1111111"),
                  _buildInfoChip("จำนวนไร่ : 25 ไร่"),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildInfoChip(
                  "พิกัด : 111 / 5 ต.จักรราช อ.จักรราช\nจ.นครราชสีมา 30230",
                  fullWidth: true),
            ),
            const SizedBox(height: 24),

            // Table Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Table(
                border: TableBorder.all(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8.0)),
                columnWidths: const <int, TableColumnWidth>{
                  0: FlexColumnWidth(),
                  1: FlexColumnWidth(),
                  2: FlexColumnWidth(),
                },
                children: <TableRow>[
                  TableRow(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                    ),
                    children: <Widget>[
                      _buildTableCell('กิจกรรม', isHeader: true),
                      _buildTableCell('คำอธิบาย', isHeader: true),
                      _buildTableCell('วันที่แล้วเสร็จ', isHeader: true),
                    ],
                  ),
                  TableRow(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                      ),
                    ),
                    children: <Widget>[
                      Container(height: 200),
                      Container(height: 200),
                      Container(height: 200),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Helper widget for info chips
  Widget _buildInfoChip(String text, {bool fullWidth = false}) {
    return Container(
      width: fullWidth
          ? double.infinity
          : (MediaQuery.of(context).size.width / 2) - 32,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE13E53),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  // Helper widget for table cells
  Widget _buildTableCell(String content, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        content,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
      ),
    );
  }
}
