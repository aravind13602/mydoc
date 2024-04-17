import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class QRDisplayScreen extends StatelessWidget {
  final String qrData;

  QRDisplayScreen({required this.qrData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generated QR Code'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveQrImage(context),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<Uint8List?>(
          future: _generateQrImageData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return Image.memory(snapshot.data!);
            } else {
              return Text('No data');
            }
          },
        ),
      ),
    );
  }

  Future<Uint8List?> _generateQrImageData() async {
    ByteData? byteData = await QrPainter(
      data: qrData,
      version: QrVersions.auto,
    ).toImageData(200);
    if (byteData != null) {
      return byteData.buffer.asUint8List();
    }
    return null;
  }

  Future<void> _saveQrImage(BuildContext context) async {
    final Uint8List? qrImageData = await _generateQrImageData();
    if (qrImageData != null) {
      await ImageGallerySaver.saveImage(qrImageData);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('QR code image saved to gallery'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to save QR code image'),
      ));
    }
  }
}
