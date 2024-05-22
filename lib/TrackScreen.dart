// import 'package:flutter/material.dart';
// import 'package:mydoc/QRScanningScreen.dart'; // Import the QRScanningScreen
//
// class TrackScreen extends StatefulWidget {
//   @override
//   _TrackScreenState createState() => _TrackScreenState();
// }
//
// class _TrackScreenState extends State<TrackScreen> {
//   TextEditingController documentNumberController = TextEditingController();
//
//   String from = '';
//   String to = '';
//   String mid = '';
//   bool showPath = false;
//
//   void addMidToDatabase(String newMid) {
//     // Assume you have a function to add mid to the database
//     // After adding mid to the database, update the tracking details
//     setState(() {
//       mid = newMid;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Track Document'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: documentNumberController,
//               decoration: InputDecoration(
//                 labelText: 'Enter Document Number',
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.qr_code_scanner),
//                   onPressed: () async {
//                     // Navigate to QR scanning screen and get the scanned data
//                     String scannedData = await Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => QRScanningScreen()),
//                     );
//                     // Set the scanned data to the text field
//                     if (scannedData != null) {
//                       documentNumberController.text = scannedData;
//                     }
//                   },
//                 ),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 // Perform action to track document with document number
//                 String documentNumber = documentNumberController.text;
//                 print('Tracking document number: $documentNumber');
//                 // Set some dummy data for demonstration
//                 setState(() {
//                   from = 'HOD Cs';
//                   mid = 'Ass Registrar';
//                   to = 'Registrar';
//                   showPath = true;
//                 });
//               },
//               child: Text('Track'),
//             ),
//             SizedBox(height: 16.0),
//             // Display the straight line path with tracking details only if showPath is true
//             if (showPath)
//               Expanded(
//                 child: CustomPaint(
//                   painter: PathPainter(from, to, mid),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class PathPainter extends CustomPainter {
//   final String from;
//   final String to;
//   final String mid;
//
//   PathPainter(this.from, this.to, this.mid);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     // Define paint properties
//     Paint paint = Paint()
//       ..color = Colors.blue
//       ..strokeWidth = 4.0
//       ..strokeCap = StrokeCap.round;
//
//     // Define starting point
//     Offset startPoint = Offset(20, size.height / 2);
//     // Define ending point
//     Offset endPoint = Offset(size.width -  60, size.height / 2);
//     // Define mid point
//     Offset midPoint = Offset(size.width / 2, size.height / 2);
//
//     // Draw the straight line path
//     canvas.drawLine(startPoint, endPoint, paint);
//
//     // Draw circles for from, to, and mid locations
//     paint.color = Colors.green; // From color
//     canvas.drawCircle(startPoint, 8.0, paint);
//     paint.color = Colors.red; // To color
//     canvas.drawCircle(endPoint, 8.0, paint);
//     paint.color = Colors.orange; // Mid color
//     canvas.drawCircle(midPoint, 8.0, paint);
//
//     // Draw text for from, to, and mid locations
//     TextPainter(
//       text: TextSpan(text: from, style: TextStyle(color: Colors.green)),
//       textDirection: TextDirection.ltr,
//     )..layout(minWidth: 0, maxWidth: size.width - 40)
//       ..paint(canvas, startPoint - Offset(0, 20));
//     TextPainter(
//       text: TextSpan(text: to, style: TextStyle(color: Colors.red)),
//       textDirection: TextDirection.ltr,
//     )..layout(minWidth: 0, maxWidth: size.width - 40)
//       ..paint(canvas, endPoint - Offset(0, 20));
//     TextPainter(
//       text: TextSpan(text: mid, style: TextStyle(color: Colors.orange)),
//       textDirection: TextDirection.ltr,
//     )..layout(minWidth: 0, maxWidth: size.width - 40)
//       ..paint(canvas, midPoint - Offset(0, 20));
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:mydoc/QRScanningScreen.dart'; // Import the QRScanningScreen

class TrackScreen extends StatefulWidget {
  @override
  _TrackScreenState createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  TextEditingController documentNumberController = TextEditingController();

  List<Map<String, dynamic>> documents = [];
  bool showPath = false;

  mongo.Db? db;
  mongo.DbCollection? collection;

  final String connectionString =
      'mongodb+srv://chandirasegaran:25032002@myangadi.bxernfz.mongodb.net/?retryWrites=true&w=majority&appName=MyAngadi';

  @override
  void initState() {
    super.initState();
    initDb();
  }

  void initDb() async {
    db = await mongo.Db.create(connectionString);
    await db!.open();
    collection = db!.collection('mydoc');
  }

  void fetchDocumentDetails(String documentNumber) async {
    // Fetch the document with the given document number
    var result = await collection?.findOne(mongo.where.eq('documentNumber', documentNumber));
    var fetchedDocument = result as Map<String, dynamic>?;

    if (fetchedDocument != null) {
      setState(() {
        documents = [fetchedDocument];
        showPath = true;
      });
    } else {
      setState(() {
        documents = [];
        showPath = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Document'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: documentNumberController,
              decoration: InputDecoration(
                labelText: 'Enter Document Number',
                suffixIcon: IconButton(
                  icon: Icon(Icons.qr_code_scanner),
                  onPressed: () async {
                    // Navigate to QR scanning screen and get the scanned data
                    String scannedData = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QRScanningScreen()),
                    );
                    // Set the scanned data to the text field
                    if (scannedData != null) {
                      documentNumberController.text = scannedData;
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Perform action to track document with document number
                String documentNumber = documentNumberController.text;
                print('Tracking document number: $documentNumber');
                fetchDocumentDetails(documentNumber);
              },
              child: Text('Track'),
            ),
            SizedBox(height: 16.0),
            // Display the straight line path with tracking details only if showPath is true
            if (showPath)
              Expanded(
                child: CustomPaint(
                  painter: PathPainter(documents),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    db?.close();
    super.dispose();
  }
}

class PathPainter extends CustomPainter {
  final List<Map<String, dynamic>> documents;

  PathPainter(this.documents);

  @override
  void paint(Canvas canvas, Size size) {
    // Define paint properties
    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    if (documents.isNotEmpty) {
      // Extract "from", "to", and "intermediate" values from the first document
      String from = documents.first['from'];
      String to = documents.first['to'];
      List<String> intermediates = [];

      // Iterate through document keys to find intermediates
      documents.first.forEach((key, value) {
        if (key.startsWith('intermediate_')) {
          intermediates.add(value.toString());
        }
      });

      // Define starting point (from)
      Offset startPoint = Offset(size.width / 2, size.height / 4);
      // Define ending point (to)
      Offset endPoint = Offset(size.width / 2, size.height * 3 / 4);

      // Draw the straight line path
      canvas.drawLine(startPoint, endPoint, paint);

      // Calculate the spacing between intermediate points
      double spacing = (endPoint.dy - startPoint.dy) / (intermediates.length + 1);

      // Draw circles and text for intermediate points
      for (int i = 0; i < intermediates.length; i++) {
        double y = startPoint.dy + (i + 1) * spacing;
        Offset midPoint = Offset(size.width / 2, y);
        canvas.drawCircle(midPoint, 8.0, paint);

        // Draw text for intermediate locations
        TextPainter(
          text: TextSpan(text: "Intermediate: ${intermediates[i]}", style: TextStyle(color: Colors.black)),
          textDirection: TextDirection.ltr,
        )
          ..layout(minWidth: 0, maxWidth: size.width - 40)
          ..paint(canvas, midPoint - Offset(0, 20));
      }

      // Draw circles and text for "from" and "to" points
      canvas.drawCircle(startPoint, 8.0, paint); // From
      TextPainter(
        text: TextSpan(text: "From: $from", style: TextStyle(color: Colors.black)),
        textDirection: TextDirection.ltr,
      )
        ..layout(minWidth: 0, maxWidth: size.width - 40)
        ..paint(canvas, startPoint - Offset(0, 40));

      canvas.drawCircle(endPoint, 8.0, paint); // To
      TextPainter(
        text: TextSpan(text: "To: $to", style: TextStyle(color: Colors.black)),
        textDirection: TextDirection.ltr,
      )
        ..layout(minWidth: 0, maxWidth: size.width - 40)
        ..paint(canvas, endPoint - Offset(0, 40));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}



void main() {
  runApp(MaterialApp(
    home: TrackScreen(),
  ));
}
