// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class QRDisplayScreen extends StatelessWidget {
//   final String qrData;
//
//   QRDisplayScreen({required this.qrData});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Generated QR Code'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.save),
//             onPressed: () => _saveQrImage(context),
//           ),
//         ],
//       ),
//       body: MyCenterWidget(
//         child: FutureBuilder<Uint8List?>(
//           future: _generateQrImageData(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return CircularProgressIndicator();
//             } else if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}');
//             } else if (snapshot.hasData) {
//               return Image.memory(snapshot.data!);
//             } else {
//               return Text('No data');
//             }
//           },
//         ),
//       ),
//     );
//   }
//
//   Future<Uint8List?> _generateQrImageData() async {
//     ByteData? byteData = await QrPainter(
//       data: qrData,
//       version: QrVersions.auto,
//     ).toImageData(200);
//     if (byteData != null) {
//       return byteData.buffer.asUint8List();
//     }
//     return null;
//   }
//
//   Future<void> _saveQrImage(BuildContext context) async {
//     // Request storage permissions
//     var status = await Permission.storage.request();
//     if (status.isGranted) {
//       final Uint8List? qrImageData = await _generateQrImageData();
//       if (qrImageData != null) {
//         final result = await ImageGallerySaver.saveImage(
//           qrImageData,
//           quality: 100,
//           name: "qr_code_${DateTime.now().millisecondsSinceEpoch}",
//         );
//         if (result['isSuccess']) {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Text('QR code image saved to gallery'),
//           ));
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Text('Failed to save QR code image'),
//           ));
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Failed to generate QR code image'),
//         ));
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Permission denied'),
//       ));
//     }
//   }
// }
//
// // Define MyCenterWidget
// class MyCenterWidget extends StatelessWidget {
//   final Widget child;
//
//   MyCenterWidget({required this.child});
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: child,
//     );
//   }
// }
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

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
    final qrValidationResult = QrValidator.validate(
      data: qrData,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    );
    if (qrValidationResult.status == QrValidationStatus.valid) {
      final qrCode = qrValidationResult.qrCode!;
      final painter = QrPainter.withQr(
        qr: qrCode,
        color: const Color(0xFF000000),
        emptyColor: const Color(0xFFFFFFFF),
        gapless: true,
      );
      final picData = await painter.toImageData(200, format: ImageByteFormat.png);
      return picData?.buffer.asUint8List();
    }
    return null;
  }

  Future<void> _saveQrImage(BuildContext context) async {
    // Request storage permissions
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final Uint8List? qrImageData = await _generateQrImageData();
      if (qrImageData != null) {
        final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(qrImageData),
          quality: 100,
          name: "qr_code_${DateTime.now().millisecondsSinceEpoch}",
        );
        if (result['isSuccess']) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('QR code image saved to gallery'),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to save QR code image'),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to generate QR code image'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Permission denied'),
      ));
    }
  }
}
