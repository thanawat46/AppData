import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

// --- Model Class ---
class CaneData {
  final String carId;
  final String descr;
  final double itemQty;
  final double ccs;
  final double ccsPriceTon;
  final double priceItem;
  final String dayOutS;

  CaneData({
    required this.carId,
    required this.descr,
    required this.itemQty,
    required this.ccs,
    required this.ccsPriceTon,
    required this.priceItem,
    required this.dayOutS,
  });

  factory CaneData.fromJson(Map<String, dynamic> json) {
    return CaneData(
      carId: json['CarID'] ?? '',
      descr: json['Descr'] ?? '',
      itemQty: (json['ItemQty'] as num?)?.toDouble() ?? 0.0,
      ccs: (json['CCS'] as num?)?.toDouble() ?? 0.0,
      ccsPriceTon: (json['CCSPriceTon'] as num?)?.toDouble() ?? 0.0,
      priceItem: (json['PriceItem'] as num?)?.toDouble() ?? 0.0,
      dayOutS: json['DayOutS'] ?? '',
    );
  }
}

class Income_year extends StatefulWidget {
  const Income_year({super.key});

  @override
  State<Income_year> createState() => _IncomeState();
}

class _IncomeState extends State<Income_year> {
  late Future<List<CaneData>> futureData;
  int? _selectedIndex;
  final String ID = '114603';
  final Dio _dio = Dio();

  final numberFormatter = NumberFormat("#,##0.00", "en_US");
  final integerFormatter = NumberFormat("#,##0", "en_US");

  // Theme Colors (Premium Soft Red)
  final Color primaryRed = const Color(0xFFD32F2F);
  final Color softPinkBg = const Color(0xFFFFF5F5);

  // Column Widths
  final double colDate = 110;
  final double colCar = 100;
  final double colCane = 90;
  final double colTon = 80;
  final double colCCS = 70;
  final double colPrice = 90;
  final double colTotal = 110;

  // *** ตัวควบคุมการเลื่อนเพื่อให้หัวตารางและเนื้อหาไปพร้อมกัน ***
  final ScrollController _headerScrollCtrl = ScrollController();
  final ScrollController _bodyScrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    futureData = fetchData();

    // เชื่อม ScrollController เข้าด้วยกัน
    _headerScrollCtrl.addListener(() {
      if (_headerScrollCtrl.hasClients && _bodyScrollCtrl.hasClients) {
        if (_headerScrollCtrl.offset != _bodyScrollCtrl.offset) {
          _bodyScrollCtrl.jumpTo(_headerScrollCtrl.offset);
        }
      }
    });

    _bodyScrollCtrl.addListener(() {
      if (_headerScrollCtrl.hasClients && _bodyScrollCtrl.hasClients) {
        if (_bodyScrollCtrl.offset != _headerScrollCtrl.offset) {
          _headerScrollCtrl.jumpTo(_bodyScrollCtrl.offset);
        }
      }
    });
  }

  @override
  void dispose() {
    _headerScrollCtrl.dispose();
    _bodyScrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    setState(() {
      futureData = fetchData();
    });
  }

  Future<List<CaneData>> fetchData() async {
    try {
      final response = await _dio.get('http://110.164.149.104:91/crapi/transectionview/$ID');
      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        if (jsonResponse['success'] == false) throw Exception('ไม่พบข้อมูล');
        final List<dynamic> dataList = jsonResponse['data'] ?? [];
        return dataList.map((data) => CaneData.fromJson(data)).toList();
      } else {
        throw Exception('Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double totalTableWidth = colDate + colCar + colCane + colTon + colCCS + colPrice + colTotal + 40;

    return Scaffold(
      backgroundColor: softPinkBg, // พื้นหลังชมพูจางๆ
      body: Stack(
        children: [
          // Header Gradient Background
          Container(
            height: 280,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB71C1C), Color(0xFFFF5252)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // AppBar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      _buildGlassButton(
                        icon: Icons.arrow_back_ios_new,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      const Expanded(
                        child: Text(
                          'รายงานรายได้',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: FutureBuilder<List<CaneData>>(
                    future: futureData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: Colors.white));
                      } else if (snapshot.hasError) {
                        return Center(child: Text("${snapshot.error}", style: const TextStyle(color: Colors.white)));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("ไม่พบข้อมูล", style: TextStyle(color: Colors.white)));
                      } else {
                        final data = snapshot.data!;
                        final itemCount = data.length;
                        final totalTons = data.fold<double>(0, (sum, item) => sum + item.itemQty);
                        final totalIncome = data.fold<double>(0, (sum, item) => sum + item.priceItem);
                        final totalCCSxQty = data.fold<double>(0, (sum, item) => sum + (item.ccs * item.itemQty));
                        final averageCCS = totalTons > 0 ? totalCCSxQty / totalTons : 0.0;

                        return CustomScrollView(
                          physics: const BouncingScrollPhysics(),
                          slivers: [
                            // 1. Dashboard (Premium UI)
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: Column(
                                  children: [
                                    _buildPremiumIncomeCard(totalIncome),
                                    const SizedBox(height: 15),
                                    Row(
                                      children: [
                                        Expanded(child: _buildSummaryCard(Icons.local_shipping, "เที่ยววิ่ง", integerFormatter.format(itemCount), "เที่ยว", const Color(0xFFD32F2F))),
                                        const SizedBox(width: 10),
                                        Expanded(child: _buildSummaryCard(Icons.scale, "นน.รวม", numberFormatter.format(totalTons), "ตัน", Colors.orange[800]!)),
                                        const SizedBox(width: 10),
                                        Expanded(child: _buildSummaryCard(Icons.science, "CCS เฉลี่ย", averageCCS.toStringAsFixed(2), "%", Colors.teal[700]!)),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ),

                            // 2. Sticky Header (Premium UI + Synced Scroll)
                            SliverPersistentHeader(
                              pinned: true,
                              delegate: _TableHeaderDelegate(
                                minHeight: 60,
                                maxHeight: 60,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 60,
                                          color: const Color(0xFFFFEBEE), // พื้นหลังหัวตารางสีชมพูอ่อน
                                          child: SingleChildScrollView(
                                            controller: _headerScrollCtrl, // <--- Controller A
                                            scrollDirection: Axis.horizontal,
                                            physics: const ClampingScrollPhysics(),
                                            child: SizedBox(
                                              width: totalTableWidth,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                                child: Row(
                                                  children: [
                                                    _buildHeadCell("วันเวลา", colDate, TextAlign.left),
                                                    _buildHeadCell("ทะเบียน", colCar, TextAlign.center),
                                                    _buildHeadCell("อ้อย", colCane, TextAlign.center),
                                                    _buildHeadCell("ตัน", colTon, TextAlign.right),
                                                    _buildHeadCell("CCS", colCCS, TextAlign.right),
                                                    _buildHeadCell("ราคา/ตัน", colPrice, TextAlign.right),
                                                    _buildHeadCell("รวมเงิน", colTotal, TextAlign.right),
                                                  ],
                                                ),
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

                            // 3. Body Data (Premium UI + Synced Scroll)
                            SliverToBoxAdapter(
                              child: Container(
                                color: Colors.white,
                                child: SingleChildScrollView(
                                  controller: _bodyScrollCtrl, // <--- Controller B
                                  scrollDirection: Axis.horizontal,
                                  physics: const ClampingScrollPhysics(),
                                  child: SizedBox(
                                    width: totalTableWidth,
                                    child: Column(
                                      children: data.asMap().entries.map((entry) {
                                        final index = entry.key;
                                        final item = entry.value;
                                        final bool isSelected = _selectedIndex == index;

                                        return InkWell(
                                          onTap: () => setState(() => _selectedIndex = isSelected ? null : index),
                                          child: Container(
                                            height: 60,
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            // Zebra Striping แบบสวยงาม
                                            color: isSelected
                                                ? const Color(0xFFFFCDD2)
                                                : (index.isEven ? Colors.white : const Color(0xFFFFF2F5)),
                                            child: Row(
                                              children: [
                                                // วันเวลา
                                                _buildBodyCell(
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(item.dayOutS.split(' ')[0], style: TextStyle(color: Colors.grey[800], fontSize: 13, fontWeight: FontWeight.bold)),
                                                        if(item.dayOutS.split(' ').length > 1)
                                                          Text(item.dayOutS.split(' ')[1], style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                                                      ],
                                                    ), colDate, Alignment.centerLeft
                                                ),

                                                // ทะเบียนรถ (Badge Style)
                                                _buildBodyCell(
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(color: Colors.red.shade100),
                                                          borderRadius: BorderRadius.circular(8)
                                                      ),
                                                      child: Text(item.carId, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red[800], fontSize: 12)),
                                                    ), colCar, Alignment.center
                                                ),

                                                // ข้อมูลอื่นๆ
                                                _buildBodyCell(Text(item.descr, style: TextStyle(color: Colors.grey[700], fontSize: 13), overflow: TextOverflow.ellipsis), colCane, Alignment.center),
                                                _buildBodyCell(Text(numberFormatter.format(item.itemQty), style: const TextStyle(fontWeight: FontWeight.w500)), colTon, Alignment.centerRight),
                                                _buildBodyCell(Text(item.ccs.toStringAsFixed(2), style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)), colCCS, Alignment.centerRight),
                                                _buildBodyCell(Text(numberFormatter.format(item.ccsPriceTon), style: TextStyle(color: Colors.grey[600])), colPrice, Alignment.centerRight),
                                                _buildBodyCell(Text(numberFormatter.format(item.priceItem), style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFFC62828))), colTotal, Alignment.centerRight),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Bottom Spacer
                            const SliverToBoxAdapter(child: SizedBox(height: 50)),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- UI Components (Premium Style) ---

  Widget _buildHeadCell(String text, double width, TextAlign align) {
    return SizedBox(width: width, child: Text(text, textAlign: align, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red[900], fontSize: 13)));
  }

  Widget _buildBodyCell(Widget child, double width, Alignment align) {
    return SizedBox(width: width, child: Align(alignment: align, child: child));
  }

  Widget _buildPremiumIncomeCard(double totalIncome) {
    String incomeStr = numberFormatter.format(totalIncome);
    List<String> parts = incomeStr.split('.');
    return Container(
      width: double.infinity, height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(colors: [Color(0xFFB71C1C), Color(0xFFFF5252)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        boxShadow: [BoxShadow(color: const Color(0xFFD32F2F).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Stack(
        children: [
          Positioned(right: 20, top: 20, child: Icon(Icons.account_balance_wallet, size: 80, color: Colors.white.withOpacity(0.1))),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle), child: const Icon(Icons.attach_money, color: Colors.white, size: 18)),
                  const SizedBox(width: 10),
                  const Text("รายได้รวมสุทธิ", style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500)),
                ]),
                RichText(text: TextSpan(children: [
                  TextSpan(text: parts[0], style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white, height: 1.0)),
                  TextSpan(text: ".${parts.length > 1 ? parts[1] : '00'}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.8))),
                ])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(IconData icon, String title, String value, String unit, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 3))],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 5),
          Text(title, style: TextStyle(color: Colors.grey[500], fontSize: 10)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
          Text(unit, style: TextStyle(color: Colors.grey[400], fontSize: 9)),
        ],
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

// --- Sticky Header Delegate ---
class _TableHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _TableHeaderDelegate({required this.minHeight, required this.maxHeight, required this.child});

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => SizedBox.expand(child: child);
  @override
  bool shouldRebuild(_TableHeaderDelegate oldDelegate) => true;
}