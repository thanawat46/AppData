import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
  List<PromotionData> _allData = [];
  List<PromotionData> _filteredData = [];

  String _selectedFilter = 'ทั้งหมด';
  final List<String> _filterOptions = ['ทั้งหมด', 'ปุ๋ย', 'ยา', 'เงินสด', 'ปุ๋ย+ยา'];

  @override
  void initState() {
    super.initState();
    _fetchAndSetData();
  }

  Future<void> _fetchAndSetData() async {
    const url = 'ใส่ API ที่ใช้ดึง';
    final dio = Dio();

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200 && response.data is List) {
        final List<dynamic> dataList = response.data;
        setState(() {
          _allData = dataList.map((data) => PromotionData.fromJson(data)).toList();
          _applyFilter();
        });
      } else {
        throw Exception('Failed to parse data');
      }
    } catch (e) {
      print("Error fetching data: $e");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ส่งเสริม",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        backgroundColor: const Color(0xFFE13E53),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        color: const Color(0xFFE13E53),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 24.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedFilter,
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedFilter = newValue!;
                        _applyFilter();
                      });
                    },
                    items: _filterOptions.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                    dropdownColor: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    )),
                child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            primary: true,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                                child: _filteredData.isEmpty
                                  ? const Center(child: Padding(padding: EdgeInsets.all(20.0), child: Text('ไม่พบข้อมูลสำหรับตัวเลือกนี้')))
                                  : DataTable(
                                      columnSpacing: 20.0,
                                      headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                                      dataTextStyle: const TextStyle(fontSize: 14, color: Colors.black),
                                      columns: const <DataColumn>[
                                        DataColumn(label: Text('วันที่')),
                                        DataColumn(label: Text('รายการ')),
                                        DataColumn(label: Text('จำนวน')),
                                        DataColumn(label: Text('ราคา')),
                                        DataColumn(label: Text('รวม')),
                                        DataColumn(label: Text('ประเภท')),
                                      ],
                                      rows: _filteredData.map((data) => DataRow(
                                        cells: <DataCell>[
                                          DataCell(Text(data.date)),
                                          DataCell(Text(data.item)),
                                          DataCell(Text(data.quantity.toString())),
                                          DataCell(Text(data.price.toStringAsFixed(2))),
                                          DataCell(Text(data.total.toStringAsFixed(2))),
                                          DataCell(Text(data.type)),
                                        ],
                                      )).toList(),
                                    ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
