import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:intl/intl.dart';

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
  int? _selectedIndex; // สำหรับเก็บ index ของแถวที่ถูกเลือก
  final String ID = '114603';
  final Dio _dio = Dio(); // สร้าง instance ของ Dio

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
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
        // dio จะทำการ decode json โดยอัตโนมัติ, response.data จึงเป็น Map/List อยู่แล้ว
        final jsonResponse = response.data;

        // ตรวจสอบค่า success ที่ API ส่งกลับมา
        if (jsonResponse['success'] == false) {
          // ถ้า success เป็น false, ให้โยน exception พร้อมกับข้อความที่เข้าใจง่าย
          throw Exception('ไม่พบข้อมูล กรุณาลองใหม่');
        }

        final List<dynamic> dataList = jsonResponse['data'] ?? [];
        return dataList.map((data) => CaneData.fromJson(data)).toList();
      } else {
        // ส่วนนี้อาจจะไม่ถูกเรียกใช้บ่อยนัก เพราะ Dio จะโยน DioError สำหรับการตอบกลับที่ไม่ใช่ 2xx
        throw Exception('ไม่สามารถโหลดข้อมูลจาก API : Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // จัดการข้อผิดพลาดเฉพาะของ Dio (เช่น การเชื่อมต่อหมดเวลา, ข้อผิดพลาดของเครือข่าย)
      throw Exception('การเชื่อมต่อล้มเหลว: ${e.message}');
    } catch (e) {
      // จัดการข้อผิดพลาดอื่นๆ ที่อาจเกิดขึ้น
      throw Exception('เกิดข้อผิดพลาดที่ไม่คาดคิด: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    // สร้าง instance ของ NumberFormat สำหรับการจัดรูปแบบ
    final numberFormatter = NumberFormat("#,##0.00", "en_US");
    final integerFormatter = NumberFormat("#,##0", "en_US");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFDD1E36),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'ยินดีต้อนรับ',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: const Color(0xFFDD1E36),
        width: double.infinity,
        height: double.infinity,
        child: FutureBuilder<List<CaneData>>(
          future: futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.white));
            } else if (snapshot.hasError) {
              String errorMessage =
                  snapshot.error.toString().replaceFirst("Exception: ", "");
              return Center(
                  child: Text(errorMessage,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 18)));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text("ไม่พบข้อมูล",
                      style: const TextStyle(color: Colors.white)));
            } else {
              final data = snapshot.data!;
              final itemCount = data.length;
              final totalTons =
                  data.fold<double>(0, (sum, item) => sum + item.itemQty);
              final totalIncome =
                  data.fold<double>(0, (sum, item) => sum + item.priceItem);
              final totalCCSxQty = data.fold<double>(
                  0, (sum, item) => sum + (item.ccs * item.itemQty));
              final averageCCS = totalTons > 0 ? totalCCSxQty / totalTons : 0.0;

              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "รายการส่งอ้อย(CCS) ${integerFormatter.format(itemCount)} รายการ",
                              style: const TextStyle(
                                color: Color(0xFFDD1E36),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "ตันรวม ${numberFormatter.format(totalTons)} ตัน\nเฉลี่ย(CCS) ${averageCCS.toStringAsFixed(2)}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFFDD1E36),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "รายได้รวม ${numberFormatter.format(totalIncome)} บาท",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFFDD1E36),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 30.0),
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              showCheckboxColumn: false, // คำสั่งนี้จะซ่อน checkbox
                              headingRowColor:
                                  MaterialStateProperty.all(Colors.grey[100]),
                              columnSpacing: 20,
                              columns: const [
                                DataColumn(
                                    label: Center(
                                        child: Text('วันเวลา-โรง',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)))),
                                DataColumn(
                                    label: Center(
                                        child: Text('ทะเบียนรถ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)))),
                                DataColumn(
                                    label: Center(
                                        child: Text('อ้อย',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)))),
                                DataColumn(
                                    label: Center(
                                        child: Text('นน.(ต้น)',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)))),
                                DataColumn(
                                    label: Center(
                                        child: Text('CCS',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)))),
                                DataColumn(
                                    label: Center(
                                        child: Text('ราคาตัน',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)))),
                                DataColumn(
                                    label: Center(
                                        child: Text('รายได้เบื้องต้น',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)))),
                              ],
                              rows: data.asMap().entries.map((entry) {
                                final int index = entry.key;
                                final CaneData item = entry.value;
                                return DataRow(
                                  selected: _selectedIndex == index,
                                  onSelectChanged: (bool? selected) {
                                    setState(() {
                                      _selectedIndex =
                                          (selected ?? false) ? index : null;
                                    });
                                  },
                                  cells: [
                                    DataCell(Center(
                                        child: Text(item.dayOutS,
                                            style: const TextStyle(
                                                fontSize: 16)))),
                                    DataCell(Center(
                                        child: Text(item.carId,
                                            style: const TextStyle(
                                                fontSize: 16)))),
                                    DataCell(Center(
                                        child: Text(item.descr,
                                            style: const TextStyle(
                                                fontSize: 16)))),
                                    DataCell(Center(
                                        child: Text(
                                            numberFormatter
                                                .format(item.itemQty),
                                            style: const TextStyle(
                                                fontSize: 16)))),
                                    DataCell(Center(
                                        child: Text(item.ccs.toStringAsFixed(2),
                                            style: const TextStyle(
                                                fontSize: 16)))),
                                    DataCell(Center(
                                        child: Text(
                                            numberFormatter
                                                .format(item.ccsPriceTon),
                                            style: const TextStyle(
                                                fontSize: 16)))),
                                    DataCell(Center(
                                        child: Text(
                                            numberFormatter
                                                .format(item.priceItem),
                                            style: const TextStyle(
                                                fontSize: 16)))),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
