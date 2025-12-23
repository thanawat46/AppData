import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// --- Model Class ---
class PromotionData {
  final String date;
  final String item;
  final int quantity;
  final double price;
  final double total;
  final String type;

  PromotionData({
    required this.date,
    required this.item,
    required this.quantity,
    required this.price,
    required this.total,
    required this.type,
  });

  factory PromotionData.fromJson(Map<String, dynamic> json) {
    return PromotionData(
      date: json['วันที่'] ?? '',
      item: json['รายการ'] ?? '',
      quantity: (json['จำนวน'] as num?)?.toInt() ?? 0,
      price: (json['ราคา'] as num?)?.toDouble() ?? 0.0,
      total: (json['รวม'] as num?)?.toDouble() ?? 0.0,
      type: json['ประเภท'] ?? '',
    );
  }
}

class Promote_API extends StatefulWidget {
  const Promote_API({super.key});

  @override
  State<Promote_API> createState() => _State();
}

class _State extends State<Promote_API> {
  // Theme Colors
  final Color primaryColor = const Color(0xFFE13E53);
  final Color backgroundColor = const Color(0xFFF5F7FA);

  List<PromotionData> _allData = [];
  List<PromotionData> _filteredData = [];
  bool _isLoading = true;

  String _selectedFilter = 'ทั้งหมด';
  final List<String> _filterOptions = ['ทั้งหมด', 'ปุ๋ย', 'ยา', 'เงินสด', 'ปุ๋ย+ยา'];

  final numberFormat = NumberFormat("#,##0.00", "en_US");

  @override
  void initState() {
    super.initState();
    _fetchAndSetData();
  }

  Future<void> _fetchAndSetData() async {
    const url = 'ใส่ API ที่ใช้ดึง'; // TODO: ใส่ URL จริง
    final dio = Dio();

    await Future.delayed(const Duration(seconds: 1)); // Mock delay
    final mockData = [
      {'วันที่': '01/01/2024', 'รายการ': 'ปุ๋ยยูเรีย 46-0-0', 'จำนวน': 10, 'ราคา': 850.0, 'รวม': 8500.0, 'ประเภท': 'ปุ๋ย'},
      {'วันที่': '05/01/2024', 'รายการ': 'ยาฆ่าหญ้า', 'จำนวน': 5, 'ราคา': 450.0, 'รวม': 2250.0, 'ประเภท': 'ยา'},
      {'วันที่': '10/01/2024', 'รายการ': 'เงินกู้ยืม', 'จำนวน': 1, 'ราคา': 5000.0, 'รวม': 5000.0, 'ประเภท': 'เงินสด'},
      {'วันที่': '15/01/2024', 'รายการ': 'ปุ๋ยสูตรเสมอ 15-15-15', 'จำนวน': 20, 'ราคา': 900.0, 'รวม': 18000.0, 'ประเภท': 'ปุ๋ย'},
    ];

    try {
      // Mock Data (เปลี่ยนเป็น API จริงตรงนี้ได้เลย)
      setState(() {
        _allData = mockData.map((data) => PromotionData.fromJson(data)).toList();
        _isLoading = false;
        _applyFilter();
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() => _isLoading = false);
    }
  }

  void _applyFilter() {
    if (_selectedFilter == 'ทั้งหมด') {
      _filteredData = List.from(_allData);
    } else if (_selectedFilter == 'ปุ๋ย+ยา') {
      _filteredData = _allData.where((data) => data.type == 'ปุ๋ย' || data.type == 'ยา').toList();
    } else if (_selectedFilter == 'เงินสด') {
      _filteredData = _allData.where((data) => data.type != 'ปุ๋ย' && data.type != 'ยา').toList();
    } else {
      _filteredData = _allData.where((data) => data.type == _selectedFilter).toList();
    }
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'ปุ๋ย': return Icons.grass_rounded;
      case 'ยา': return Icons.science_rounded;
      case 'เงินสด': return Icons.monetization_on_rounded;
      case 'ปุ๋ย+ยา': return Icons.layers_rounded;
      default: return Icons.grid_view_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor, // พื้นหลังหลักเป็นสีแดง เพื่อให้ Header เนียน
      body: Stack(
        children: [
          // ส่วนเนื้อหาหลัก (สีขาว/เทาอ่อน)
          Column(
            children: [
              // พื้นที่ส่วนหัว (Placeholder สำหรับ Header)
              Container(height: 100, color: primaryColor), // ปรับความสูงตามต้องการ

              // ส่วนพื้นที่สีขาวโค้งมนด้านล่าง
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      // --- Dropdown Filter ---
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 25, 25, 15),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))
                            ],
                          ),
                          child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton<String>(
                                value: _selectedFilter,
                                isExpanded: true,
                                icon: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.keyboard_arrow_down_rounded, color: primaryColor, size: 20),
                                ),
                                style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600),
                                dropdownColor: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedFilter = newValue!;
                                    _applyFilter();
                                  });
                                },
                                items: _filterOptions.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Row(
                                      children: [
                                        Icon(
                                          _getIconForType(value),
                                          size: 20,
                                          color: value == _selectedFilter ? primaryColor : Colors.grey[400],
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          value,
                                          style: TextStyle(
                                            color: value == _selectedFilter ? primaryColor : Colors.black87,
                                            fontWeight: value == _selectedFilter ? FontWeight.bold : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // --- List Data ---
                      Expanded(
                        child: _isLoading
                            ? Center(child: CircularProgressIndicator(color: primaryColor))
                            : _filteredData.isEmpty
                            ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off_rounded, size: 70, color: Colors.grey[300]),
                              const SizedBox(height: 10),
                              Text('ไม่พบข้อมูล $_selectedFilter', style: TextStyle(color: Colors.grey[500], fontSize: 16)),
                            ],
                          ),
                        )
                            : ListView.builder(
                          itemCount: _filteredData.length,
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                          itemBuilder: (context, index) {
                            final item = _filteredData[index];
                            return _buildListItem(item);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // --- Custom Header (ลอยอยู่ด้านบนสุด) ---
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                children: [
                  // 1. ปุ่มย้อนกลับแบบแก้ว (Custom Back Button)
                  _buildGlassButton(
                    icon: Icons.arrow_back_ios_new,
                    onTap: () => Navigator.of(context).pop(),
                  ),

                  // 2. Title
                  const Expanded(
                    child: Text(
                      "รายการส่งเสริม",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white,
                        shadows: [Shadow(offset: Offset(0, 1), blurRadius: 3.0, color: Colors.black26)],
                      ),
                    ),
                  ),

                  // 3. จัดสมดุล
                  const SizedBox(width: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget: สร้างรายการแต่ละแถว
  Widget _buildListItem(PromotionData item) {
    Color themeColor;
    Color lightBg;
    if (item.type == 'ปุ๋ย') {
      themeColor = Colors.green.shade700;
      lightBg = Colors.green.shade50;
    } else if (item.type == 'ยา') {
      themeColor = Colors.orange.shade800;
      lightBg = Colors.orange.shade50;
    } else if (item.type == 'เงินสด') {
      themeColor = Colors.blue.shade700;
      lightBg = Colors.blue.shade50;
    } else {
      themeColor = Colors.purple.shade700;
      lightBg = Colors.purple.shade50;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: lightBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: themeColor.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(_getIconForType(item.type), size: 14, color: themeColor),
                      const SizedBox(width: 5),
                      Text(item.type, style: TextStyle(color: themeColor, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Text(item.date, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
            const SizedBox(height: 10),
            Text(item.item, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 15),
            LayoutBuilder(builder: (context, constraints) {
              return Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate((constraints.constrainWidth() / 10).floor(), (_) => SizedBox(width: 5, height: 1, child: DecoratedBox(decoration: BoxDecoration(color: Colors.grey[300])))),
              );
            }),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("จำนวน", style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                    Text("${item.quantity} หน่วย", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("ราคารวม", style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                    Text("${numberFormat.format(item.total)} ฿", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Widget: ปุ่มย้อนกลับสไตล์ Glassmorphism
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
}