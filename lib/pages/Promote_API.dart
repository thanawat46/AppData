import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/data_model.dart';
import '../repositories/cane_repository.dart';

class SummaryCategory {
  final String typeId;
  final String title;
  final IconData icon;
  final Color color;
  int countYear1 = 0;
  double amountYear1 = 0.0;
  int countYear2 = 0;
  double amountYear2 = 0.0;

  SummaryCategory({
    required this.typeId,
    required this.title,
    required this.icon,
    required this.color,
  });
}

class Promote_API extends StatefulWidget {
  final String username;
  Promote_API({
    super.key,
    required this.username,
  });

  @override
  State<Promote_API> createState() => _State();
}

class _State extends State<Promote_API> {
  final Color primaryColor = const Color(0xFFE13E53);
  final Color backgroundColor = const Color(0xFFF5F7FA);
  final numberFormat = NumberFormat("#,##0.00", "en_US");
  final CaneRepository _repository = CaneRepository();
  bool _isLoading = true;
  String _selectedFilter = 'ทั้งหมด';
  List<String> _filterOptions = ['ทั้งหมด'];
  List<CaneYear> _apiYears = [];
  List<SummaryCategory> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    try {
      final years = await _repository.getCaneYears();
      final promotions = await _repository.getPromotionItems(widget.username);

      if (mounted) {
        setState(() {
          _apiYears = years;
          _filterOptions = ['ทั้งหมด', ...years.map((e) => e.yearNum)];
          _setupInitialCategories();
          _processPromotionSummary(promotions);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด: $e'), backgroundColor: primaryColor),
        );
      }
    }
  }

  void _setupInitialCategories() {
    _categories = [
      SummaryCategory(typeId: '1', title: 'เงิน', icon: Icons.monetization_on_rounded, color: Colors.blue.shade700),
      SummaryCategory(typeId: '2', title: 'ปุ๋ย', icon: Icons.grass_rounded, color: Colors.green.shade700),
      SummaryCategory(typeId: '3', title: 'ยา', icon: Icons.science_rounded, color: Colors.orange.shade800),
      SummaryCategory(typeId: '4', title: 'รถไถร่วม', icon: Icons.agriculture_rounded, color: Colors.deepPurple.shade700),
      SummaryCategory(typeId: '5', title: 'อื่น ๆ', icon: Icons.category_rounded, color: Colors.grey.shade700),
    ];
  }

  void _processPromotionSummary(List<PromotionData> data) {
    if (_apiYears.isEmpty) return;

    String year1 = _apiYears.isNotEmpty ? _apiYears[0].yearNum : "";
    String year2 = _apiYears.length > 1 ? _apiYears[1].yearNum : "";

    for (var item in data) {
      var category = _categories.firstWhere(
            (c) => c.typeId == item.itemType,
        orElse: () => _categories.last,
      );

      if (item.yearNum == year1) {
        category.countYear1++;
        category.amountYear1 += item.amount;
      } else if (item.yearNum == year2) {
        category.countYear2++;
        category.amountYear2 += item.amount;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Stack(
        children: [
          Column(
            children: [
              Container(height: 100, color: primaryColor),
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
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator(color: primaryColor))
                      : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 25, 25, 10),
                        child: _buildFilterDropdown(),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            return _buildSummaryCard(_categories[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildHeader(context),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: primaryColor.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10)),
        ],
        border: Border.all(
          color: _selectedFilter != 'ทั้งหมด' ? primaryColor.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedFilter,
          isExpanded: true,
          icon: Icon(Icons.unfold_more_rounded, color: primaryColor, size: 24),
          style: const TextStyle(fontFamily: 'Kanit', fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(20),
          onChanged: (String? newValue) => setState(() => _selectedFilter = newValue!),
          items: _filterOptions.map<DropdownMenuItem<String>>((String value) {
            bool isActive = _selectedFilter == value;
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Icon(
                    value == 'ทั้งหมด' ? Icons.dashboard_customize_rounded : Icons.calendar_month_rounded,
                    size: 18, color: isActive ? primaryColor : Colors.grey[400],
                  ),
                  const SizedBox(width: 12),
                  Text(
                    value == 'ทั้งหมด' ? "แสดงข้อมูลทุกปี" : "ปี $value",
                    style: TextStyle(color: isActive ? primaryColor : Colors.black87, fontWeight: isActive ? FontWeight.bold : FontWeight.normal),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(SummaryCategory category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: category.color.withOpacity(0.12), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [category.color.withOpacity(0.2), category.color.withOpacity(0.05)],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(category.icon, color: category.color, size: 24),
                  ),
                  const SizedBox(width: 15),
                  Text(category.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  const Spacer(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: _selectedFilter == 'ทั้งหมด'
                  ? Row(
                children: [
                  if (_apiYears.isNotEmpty)
                    Expanded(child: _buildModernData("ปี ${_apiYears[0].yearNum}", category.countYear1, category.amountYear1, category.color)),
                  const SizedBox(width: 12),
                  if (_apiYears.length > 1)
                    Expanded(child: _buildModernData("ปี ${_apiYears[1].yearNum}", category.countYear2, category.amountYear2, category.color)),
                ],
              )
                  : _buildModernData(
                "ปีเพาะปลูก $_selectedFilter",
                _selectedFilter == (_apiYears.isNotEmpty ? _apiYears[0].yearNum : '') ? category.countYear1 : category.countYear2,
                _selectedFilter == (_apiYears.isNotEmpty ? _apiYears[0].yearNum : '') ? category.amountYear1 : category.amountYear2,
                category.color,
                isFull: true,
              ),
            ),
            const SizedBox(height: 20),
            _buildPremiumDetailButton(category),
          ],
        ),
      ),
    );
  }

  Widget _buildModernData(String label, int count, double amount, Color themeColor, {bool isFull = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: isFull ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: themeColor.withOpacity(0.7))),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: isFull ? MainAxisAlignment.start : MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text("$count", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF2D3436))),
              const SizedBox(width: 4),
              const Text("รายการ", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 4),
          Text("${numberFormat.format(amount)} ฿", style: TextStyle(fontSize: isFull ? 20 : 15, fontWeight: FontWeight.w700, color: themeColor)),
        ],
      ),
    );
  }

  Widget _buildPremiumDetailButton(SummaryCategory category) {
    return Material(
      color: category.color.withOpacity(0.04),
      child: InkWell(
        onTap: () => _selectedFilter == 'ทั้งหมด' ? _showYearSelectionDialog(category) : debugPrint("Detail Page"),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(border: Border(top: BorderSide(color: category.color.withOpacity(0.08)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("ดูรายละเอียดเพิ่มเติม", style: TextStyle(color: category.color, fontWeight: FontWeight.w800, fontSize: 14)),
              const SizedBox(width: 8),
              Icon(Icons.arrow_right_alt_rounded, color: category.color, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showYearSelectionDialog(SummaryCategory category) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
              const Text("เลือกปีที่ต้องการดู", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ..._apiYears.asMap().entries.map((entry) {
                int idx = entry.key;
                CaneYear year = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildPopupYearOption(
                      category, year.yearNum,
                      idx == 0 ? category.countYear1 : category.countYear2,
                      idx == 0 ? category.amountYear1 : category.amountYear2
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPopupYearOption(SummaryCategory category, String year, int count, double amount) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: category.color.withOpacity(0.05), borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            Icon(Icons.calendar_today_rounded, color: category.color, size: 20),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ปี $year", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("$count รายการ | ${numberFormat.format(amount)} ฿", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: category.color, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Row(
          children: [
            _buildGlassButton(icon: Icons.arrow_back_ios_new, onTap: () => Navigator.pop(context)),
            const Expanded(
              child: Text("รายการส่งเสริม", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white)),
            ),
            const SizedBox(width: 40),
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
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}