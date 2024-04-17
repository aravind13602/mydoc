import 'package:flutter/material.dart';

class QRScanningScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: Icon(
                  Icons.qr_code_scanner,
                  size: 200.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
