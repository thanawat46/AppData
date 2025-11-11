import 'package:appdata/Login.dart';
import 'package:flutter/material.dart';

import 'CheckQueuePage.dart';
import 'Income_year.dart';

class ListView_Choice extends StatefulWidget {
  const ListView_Choice({super.key});

  @override
  State<ListView_Choice> createState() => _State();
}

class _State extends State<ListView_Choice> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          color: const Color(0xFFDD1E36),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 125, bottom: 20),
                child: Text("ยินต้อนรับ\nนาย ธีรุตม์ ฝาสันเทียะ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
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
                      )),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text("เมนูรายการข้อมูลต่างๆ",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 300,
                              height: 80,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFDD1E36),
                                    foregroundColor: Colors.white,
                                    textStyle: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Income_year()),
                                  );
                                },
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('รายการส่งอ้อย(CCS)'),
                                    Text('>'),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 300,
                              height: 80,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFDD1E36),
                                    foregroundColor: Colors.white,
                                    textStyle: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CheckQueuePage()),
                                  );
                                },
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('คิวรถอ้อย'),
                                    Text('>'),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 300,
                              height: 80,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFDD1E36),
                                    foregroundColor: Colors.white,
                                    textStyle: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                    (Route<dynamic> route) => false,
                                  );
                                },
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('ออกจากระบบ'),
                                    Text('>'),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
