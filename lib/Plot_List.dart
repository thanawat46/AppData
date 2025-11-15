import 'package:flutter/material.dart';

import 'Plot_details.dart';

class PlotList extends StatefulWidget {
  final bool showBackButton;

  const PlotList({super.key, this.showBackButton = true});

  @override
  State<PlotList> createState() => _PlotListState();
}

class _PlotListState extends State<PlotList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemCount: 10, // Example: 10 plots
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE13E53),
                child: Icon(Icons.location_on, color: Colors.white),
              ),
              title: Text('แปลงที่ ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('รหัสแปลง: 1234-567-${index}'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlotDetails()),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
