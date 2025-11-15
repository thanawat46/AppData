import 'package:flutter/material.dart';
import 'Plot_details.dart';

class PlotList extends StatefulWidget {
  final bool showBackButton;

  const PlotList({super.key, this.showBackButton = true});

  @override
  State<PlotList> createState() => _PlotListState();
}

class _PlotListState extends State<PlotList> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> _plotData = [
    {'รหัสแปลง': '101', 'จำนวนไร่': '50.5', 'ผู้ดูแล': 'สมชาย', 'พิกัด': 'N/A'},
    {'รหัสแปลง': '102', 'จำนวนไร่': '30.0', 'ผู้ดูแล': 'สมศรี', 'พิกัด': 'N/A'},
    {'รหัสแปลง': '103', 'จำนวนไร่': '25.2', 'ผู้ดูแล': 'สมศักดิ์', 'พิกัด': 'N/A'},
    {'รหัสแปลง': '104', 'จำนวนไร่': '100.0', 'ผู้ดูแล': 'สมหมาย', 'พิกัด': 'N/A'},
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE13E53),
      appBar: AppBar(
        elevation: 0,
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'รายการแปลง',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFE13E53),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Text(
                "เฉพาะปัจจุบัน 2568/2569",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'รหัสแปลง',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide.none,
                      ),
                      isDense: true,
                    ),
                  ),),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Search functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                  child: const Text('ค้นหา', style: TextStyle(fontSize: 16)),
                )
              ],
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
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                child: SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                        columnSpacing: 20,
                        headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        columns: const [
                          DataColumn(label: Text('รหัสแปลง')),
                          DataColumn(label: Text('จำนวนไร่')),
                          DataColumn(label: Text('ผู้ดูแล')),
                          DataColumn(label: Text('พิกัด')),
                          DataColumn(label: Text('รายละเอียด')),
                        ],
                        rows: _plotData.asMap().entries.map((entry) {
                          final index = entry.key;
                          final plot = entry.value;
                          return DataRow(
                            color: MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.selected)) {
                                  return Theme.of(context).colorScheme.primary.withOpacity(0.08);
                                }
                                if (index.isEven) {
                                  return Colors.grey.withOpacity(0.1);
                                }
                                return null;
                              },
                            ),
                            cells: [
                              DataCell(Text(plot['รหัสแปลง'] ?? '')),
                              DataCell(Text(plot['จำนวนไร่'] ?? '')),
                              DataCell(Text(plot['ผู้ดูแล'] ?? '')),
                              DataCell(Text(plot['พิกัด'] ?? '')),
                              DataCell(
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const PlotDetails()),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE13E53),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Adjust padding as needed
                                  ),
                                  child: const Text('ดูเพิ่มเติม', style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ]
                          );
                        }).toList(),
                    ),
                  ),                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
