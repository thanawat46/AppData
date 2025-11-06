import 'package:flutter/material.dart';

class CheckQueuePage extends StatefulWidget {
  const CheckQueuePage({super.key});

  @override
  State<CheckQueuePage> createState() => _CheckQueuePageState();
}

class _CheckQueuePageState extends State<CheckQueuePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFDD1E36),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("ยินดีต้อนรับ นาย ธนวัฒน์ หนองงู",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFDD1E36),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Container(
                        width: 120,
                        height: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDD1E36),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: const Center(
                          child: Text(
                            'รถอ้อย',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      const Text("บริษัท อุตสาหกรรมโคราช จำกัด \n (โรงน้ำตาลพิมาย)",
                          textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 300,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 120,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFDD1E36),
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'คิวรถทางไกล',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 50,),
                                    const Text("รอบที่ 11 คิว 501",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 50,),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("ถึงคิวที่ 550",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(width: 50),
                                    Text("จากทั้งหมด 1100 คิว",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30,),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("ตกคิวรับได้ คิวที่ 451",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(width: 50,),
                                    Text("ถึงคิวที่ 500",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                const Center(
                                  child: Text("ประกาศแล้ว 5817:22 ชั่วโมง",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Container(
                          width: double.infinity,
                          height: 300,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 120,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFDD1E36),
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "คิวรถตัดอ้อย",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 50,),
                                    const Text("รอบที่ 38 คิวที่ 801",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 50,),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("ถึงคิวที่ 850",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(width: 50,),
                                    Text("จากทั้งหมด 2000 คิว",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30,),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("ตกคิวรับได้ คิวที่ 751",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(width: 50,),
                                    Text("ถึงคิวที่ 800",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                const Center(
                                  child: Text("ประกาศแล้ว 5837:00 ชั่วโมง",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Container(
                          width: double.infinity,
                          height: 300,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 170,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFDD1E36),
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'คิวอ้อยคนตัดในเขต',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20,),
                                    const Text("รอบที่ 26 คิวที่ 301",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 50,),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("ถึงคิวที่ 350",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(width: 50,),
                                    Text("จากทั้งหมด 800 คิว",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30,),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("ตกคิวรับได้ คิวที่ 251",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(width: 50,),
                                    Text("ถึงคิวที่ 300",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                const Center(
                                  child: Text("ประกาศแล้ว 5817:22 ชั่วโมง",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
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
              ),
              const SizedBox(height: 20,),
              const Text("สอบถามคิวได้ที่เบอร์ 044-429400,ต่อ 334,176 \n สถานีวิทยุชาวไร่อ้อยดวงตะวัน 088-4926009 \n(93.5 MHz. และ 89.75 MHz)",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
