import 'package:flutter/material.dart';

class Income_year extends StatefulWidget {
  const Income_year({super.key});

  @override
  State<Income_year> createState() => _IncomeState();
}

class _IncomeState extends State<Income_year> {
  final String day = 'วันเวลา-โรง';
  final String Code = 'ทะเบียนรถ';
  final String sugar = 'อ้อย';
  final String width = 'นน.(ต้น)';
  final String CCS = 'CCS';
  final String Price = 'ราคาตัน';
  final String Income = 'รายได้เบื้องต้น';

  final List<Map<String, String>> _data = [
    {
      "day": "01/01/24 10:00",
      "Code": "กข 1234",
      "sugar": "สด",
      "width": "15.50",
      "CCS": "13.50",
      "Price": "1200",
      "Income": "18600"
    },
    {
      "day": "02/01/24 11:30",
      "Code": "กค 5678",
      "sugar": "สด",
      "width": "16.20",
      "CCS": "13.40",
      "Price": "1200",
      "Income": "19440"
    },
    {
      "day": "03/01/24 09:15",
      "Code": "ฆง 9012",
      "sugar": "สด",
      "width": "14.80",
      "CCS": "13.60",
      "Price": "1200",
      "Income": "17760"
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFDD1E36),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "ยินดีต้อนรับ นาย ธนวัฒน์ หนองงู",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFFDD1E36),
        width: double.infinity,
        height: double.infinity,
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
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "รายการส่งอ้อย(CCS) 133 รายการ",
                      style: TextStyle(
                        color: Color(0xFFDD1E36),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "ตันรวม 2348.12 ตัน\nเฉลี่ย(CCS) 13.09",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFDD1E36),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "รายได้รวม 3,233,442.10 บาท",
                      textAlign: TextAlign.center,
                      style: TextStyle(
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
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 800, // Set a wide enough width for scrolling
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(day, style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                              Text(Code, style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                              Text(sugar, style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                              Text(width, style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                              Text(CCS, style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                              Text(Price, style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                              Text(Income, style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            ],
                          ),
                        ),
                        const Divider(color: Colors.grey, height: 1),
                        Expanded(
                          child: ListView.separated(
                            itemCount: _data.length,
                            separatorBuilder: (context, index) => const Divider(color: Colors.grey, height: 1),
                            itemBuilder: (context, index) {
                              final item = _data[index];
                              return SizedBox(
                                height: 60,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(item['day'] ?? '',style: const TextStyle(fontSize: 17)),
                                    Text(item['Code'] ?? '',style: const TextStyle(fontSize: 17)),
                                    Text(item['sugar'] ?? '',style: const TextStyle(fontSize: 17)),
                                    Text(item['width'] ?? '',style: const TextStyle(fontSize: 17)),
                                    Text(item['CCS'] ?? '',style: const TextStyle(fontSize: 17)),
                                    Text(item['Price'] ?? '',style: const TextStyle(fontSize: 17)),
                                    Text(item['Income'] ?? '',style: const TextStyle(fontSize: 17)),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
