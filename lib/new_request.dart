import 'package:flutter/material.dart';
import 'package:mydoc/QRDisplayScreen.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:doctrack/QRDisplayScreen.dart';

class NewRequestScreen extends StatelessWidget {
  final String userName;

  NewRequestScreen({required this.userName});

  @override
  Widget build(BuildContext context) {
    TextEditingController toController = TextEditingController();
    TextEditingController documentNumberController = TextEditingController();
    TextEditingController subController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('New Request'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'From: $userName',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: toController,
              decoration: InputDecoration(labelText: 'To'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: documentNumberController,
              decoration: InputDecoration(labelText: 'Document Number'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: subController,
              decoration: InputDecoration(labelText: 'Sub:'),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                String documentNumber = documentNumberController.text;
                String sub = subController.text;
                String to = toController.text;

                // Generate QR code data
                String qrData = 'Document Number: $documentNumber';

                // Navigate to QRDisplayScreen and pass qrData
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRDisplayScreen(qrData: qrData),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(230, 18, 14, 1), // Set button color
              ),
              child: Text('Generate QR', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
