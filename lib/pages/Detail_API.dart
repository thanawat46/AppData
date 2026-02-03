import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/data_model.dart';

class Detail_API extends StatefulWidget {
  final String title;
  final List<PromotionData> data;
  final Color? color;

  const Detail_API({
    super.key,
    required this.title,
    required this.data,
    this.color,
  });

  @override
  State<Detail_API> createState() => _Detail_APIState();
}

class _Detail_APIState extends State<Detail_API> {
  final Color backgroundColor = const Color(0xFFF5F7FA);
  late Color primaryColor;
  bool _isCollapsed = false;
  final numberFormat = NumberFormat("#,##0.00", "en_US");

  final TextEditingController _searchController = TextEditingController();
  List<PromotionData> _filteredData = [];

  @override
  void initState() {
    super.initState();
    primaryColor = widget.color ?? const Color(0xFFE13E53);
    _filteredData = widget.data;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredData = widget.data
          .where((item) => item.itemName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  double get _totalAmount => _filteredData.fold(0.0, (sum, item) => sum + item.amount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Stack(
        children: [
          Column(
            children: [
              Container(height: 110, color: primaryColor),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(35.0),
                      topRight: Radius.circular(35.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 25),
                      _buildSearchField(),
                      _buildTableHeader(),
                      Expanded(
                        child: _filteredData.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                          itemCount: _filteredData.length,
                          padding: const EdgeInsets.fromLTRB(16, 5, 16, 100),
                          itemBuilder: (context, index) {
                            final item = _filteredData[index];
                            return _buildDataRow(item);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildCustomAppBar(context),
          Positioned(
            right: 20,
            bottom: 25,
            child: _buildFloatingActionBtn(
              icon: Icons.account_balance_wallet_rounded,
              label: "รวมทั้งหมด: ${numberFormat.format(_totalAmount)} ฿",
              onTap: () => setState(() => _isCollapsed = !_isCollapsed),
              isCollapsed: _isCollapsed,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            hintText: 'ค้นหาชื่อรายการ...',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: Icon(Icons.search_rounded, color: primaryColor),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
              icon: Icon(Icons.cancel_rounded, color: Colors.grey.shade400),
              onPressed: () {
                _searchController.clear();
                _onSearchChanged('');
              },
            )
                : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    TextStyle headerTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 13,
      color: Colors.blueGrey.shade800,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.grey.shade200.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(flex: 4, child: Text("รายการ", style: headerTextStyle)),
            Expanded(flex: 2, child: Center(child: Text("วันที่", style: headerTextStyle))),
            Expanded(flex: 3, child: Text("จำนวนเงิน", textAlign: TextAlign.right, style: headerTextStyle)),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(PromotionData item) {
    String formattedDate = "-";
    if (item.dateEff != null) {
      final day = item.dateEff!.day.toString().padLeft(2, '0');
      final month = item.dateEff!.month.toString().padLeft(2, '0');
      final yearBE = item.dateEff!.year + 543;
      formattedDate = "$day/$month/$yearBE";
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    item.itemName,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.black87),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Text(
                      formattedDate,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    numberFormat.format(item.amount),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Row(
          children: [
            _buildGlassButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text("ไม่พบข้อมูลที่ค้นหา", style: TextStyle(color: Colors.grey.shade500, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFloatingActionBtn({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isCollapsed,
    required Color color,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.fastOutSlowIn,
      width: isCollapsed ? 60 : 260,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onTap,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                  if (!isCollapsed)
                    Flexible(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Padding(
                          key: ValueKey(label),
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              letterSpacing: 0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}