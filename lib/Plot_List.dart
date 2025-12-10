import 'package:flutter/material.dart';
import 'Plot_details.dart'; // ตรวจสอบว่าไฟล์นี้มีอยู่จริงในโปรเจกต์ของคุณ

class PlotList extends StatefulWidget {
  final bool showBackButton;

  const PlotList({super.key, this.showBackButton = true});

  @override
  State<PlotList> createState() => _PlotListState();
}

class _PlotListState extends State<PlotList> {
  // Theme Colors
  final Color primaryRed = const Color(0xFFE13E53);
  final Color secondaryRed = const Color(0xFFFF6B6B);
  final Color softBg = const Color(0xFFF5F7FA);

  final List<Map<String, String>> _allPlotData = [
    {'รหัสแปลง': '101', 'จำนวนไร่': '50.5', 'ผู้ดูแล': 'สมชาย', 'พิกัด': '14.88, 102.01'},
    {'รหัสแปลง': '102', 'จำนวนไร่': '30.0', 'ผู้ดูแล': 'สมศรี', 'พิกัด': '14.89, 102.02'},
    {'รหัสแปลง': '103', 'จำนวนไร่': '25.2', 'ผู้ดูแล': 'สมศักดิ์', 'พิกัด': 'N/A'},
    {'รหัสแปลง': '104', 'จำนวนไร่': '100.0', 'ผู้ดูแล': 'สมหมาย', 'พิกัด': '15.00, 103.50'},
    {'รหัสแปลง': '105', 'จำนวนไร่': '75.8', 'ผู้ดูแล': 'สมใจ', 'พิกัด': 'N/A'},
    {'รหัสแปลง': '106', 'จำนวนไร่': '120.0', 'ผู้ดูแล': 'สมชาย', 'พิกัด': 'N/A'},
    {'รหัสแปลง': '107', 'จำนวนไร่': '45.5', 'ผู้ดูแล': 'สมศรี', 'พิกัด': 'N/A'},
    {'รหัสแปลง': '108', 'จำนวนไร่': '60.0', 'ผู้ดูแล': 'สมศักดิ์', 'พิกัด': 'N/A'},
    {'รหัสแปลง': '109', 'จำนวนไร่': '80.7', 'ผู้ดูแล': 'สมหมาย', 'พิกัด': 'N/A'},
    {'รหัสแปลง': '110', 'จำนวนไร่': '90.0', 'ผู้ดูแล': 'สมใจ', 'พิกัด': 'N/A'},
    {'รหัสแปลง': '111', 'จำนวนไร่': '15.0', 'ผู้ดูแล': 'สมชาย', 'พิกัด': 'N/A'},
    {'รหัสแปลง': '112', 'จำนวนไร่': '22.5', 'ผู้ดูแล': 'สมศรี', 'พิกัด': 'N/A'},
    {'รหัสแปลง': '113', 'จำนวนไร่': '33.0', 'ผู้ดูแล': 'สมศักดิ์', 'พิกัด': 'N/A'},
    {'รหัสแปลง': '114', 'จำนวนไร่': '44.0', 'ผู้ดูแล': 'สมหมาย', 'พิกัด': 'N/A'},
    {'รหัสแปลง': '115', 'จำนวนไร่': '55.5', 'ผู้ดูแล': 'สมใจ', 'พิกัด': 'N/A'},
  ];

  List<Map<String, String>> _foundPlots = [];

  @override
  void initState() {
    super.initState();
    _foundPlots = _allPlotData;
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, String>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allPlotData;
    } else {
      results = _allPlotData.where((plot) {
        final keyword = enteredKeyword.toLowerCase();
        return plot.values.any((value) => value.toLowerCase().contains(keyword));
      }).toList();
    }

    setState(() {
      _foundPlots = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBg, // พื้นหลังสีเทาอ่อน
      body: Stack(
        children: [
          // 1. พื้นหลังไล่สีด้านบน (Header Gradient)
          Container(
            height: 260,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryRed, secondaryRed],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
          ),

          // 2. เนื้อหาหลัก
          SafeArea(
            child: Column(
              children: [
                // --- Custom App Bar ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                  child: Row(
                    children: [
                      // ปุ่มย้อนกลับ (แสดงเฉพาะเมื่อกำหนดให้โชว์)
                      if (widget.showBackButton)
                        _buildGlassButton(Icons.arrow_back_ios_new, () => Navigator.of(context).pop())
                      else
                        const SizedBox(width: 40), // Placeholder เพื่อจัดกลาง

                      const Expanded(
                        child: Text(
                          'รายการแปลง',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            letterSpacing: 1,
                          ),
                        ),
                      ),

                      // พื้นที่ว่างฝั่งขวาเพื่อให้ Title อยู่ตรงกลางเป๊ะๆ
                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                // --- ปีการผลิต (Chip Style) ---
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: Colors.white.withOpacity(0.4)),
                  ),
                  child: const Text(
                    "เฉพาะปีปัจจุบัน 2568/2569",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // --- ช่องค้นหา (Floating Search Bar) ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (value) => _runFilter(value),
                      style: const TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                        hintText: 'ค้นหารหัสแปลง, ชื่อผู้ดูแล...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        prefixIcon: Icon(Icons.search, color: primaryRed),
                        suffixIcon: _foundPlots.length != _allPlotData.length
                            ? IconButton(icon: const Icon(Icons.close, color: Colors.grey), onPressed: () => _runFilter(''))
                            : null,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // --- ตารางข้อมูล (Card Style Table) ---
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                      child: _foundPlots.isNotEmpty
                          ? SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Colors.grey[200], // สีเส้นแบ่งบางๆ
                            ),
                            child: DataTable(
                              columnSpacing: 25,
                              horizontalMargin: 20,
                              dataRowMinHeight: 65,
                              dataRowMaxHeight: 65,
                              headingRowColor: MaterialStateProperty.all(const Color(0xFFFFF0F0)), // หัวตารางสีชมพูอ่อน

                              columns: [
                                _buildHeader("รหัสแปลง"),
                                _buildHeader("จำนวนไร่"),
                                _buildHeader("ผู้ดูแล"),
                                _buildHeader("พิกัด"),
                                _buildHeader("รายละเอียด", align: TextAlign.center),
                              ],

                              rows: _foundPlots.asMap().entries.map((entry) {
                                final index = entry.key;
                                final plot = entry.value;
                                return DataRow(
                                  color: MaterialStateProperty.resolveWith<Color?>((states) {
                                    // Zebra Striping (สลับสีขาว/เทาอ่อน)
                                    return index.isEven ? Colors.white : const Color(0xFFFAFAFA);
                                  }),
                                  cells: [
                                    DataCell(
                                        Row(
                                          children: [
                                            Icon(Icons.landscape, size: 16, color: Colors.grey[400]),
                                            const SizedBox(width: 5),
                                            Text(plot['รหัสแปลง'] ?? '', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800])),
                                          ],
                                        )
                                    ),
                                    DataCell(Text(plot['จำนวนไร่'] ?? '', style: const TextStyle(fontWeight: FontWeight.w500))),
                                    DataCell(Text(plot['ผู้ดูแล'] ?? '', style: TextStyle(color: Colors.grey[700]))),
                                    DataCell(Text(plot['พิกัด'] ?? '', style: TextStyle(color: Colors.grey[500], fontSize: 12))),

                                    // ปุ่มกดดูรายละเอียดแบบสวยๆ
                                    DataCell(
                                      Center(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => const PlotDetails()),
                                            );
                                          },
                                          borderRadius: BorderRadius.circular(20),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(colors: [primaryRed, secondaryRed]),
                                                borderRadius: BorderRadius.circular(20),
                                                boxShadow: [BoxShadow(color: primaryRed.withOpacity(0.3), blurRadius: 5, offset: const Offset(0, 2))]
                                            ),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.visibility_outlined, size: 18, color: Colors.white),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      )
                          : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 60, color: Colors.grey[300]),
                            const SizedBox(height: 10),
                            Text("ไม่พบข้อมูล", style: TextStyle(color: Colors.grey[500], fontSize: 16)),
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

  // --- Helper Widgets ---

  // ปุ่มย้อนกลับแบบแก้ว (Glassmorphism)
  Widget _buildGlassButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  // หัวตาราง
  DataColumn _buildHeader(String title, {TextAlign align = TextAlign.start}) {
    return DataColumn(
      label: Text(
        title,
        textAlign: align,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: primaryRed, // สีแดง Theme
          fontSize: 14,
        ),
      ),
    );
  }
}