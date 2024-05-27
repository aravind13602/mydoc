import 'package:flutter/material.dart';
import 'package:mydoc/QRScanningScreen.dart'; // Import the QRScanningScreen
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:firebase_auth/firebase_auth.dart';

class TrackScreen extends StatefulWidget {
  @override
  _TrackScreenState createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  TextEditingController documentNumberController = TextEditingController();

  String from = '';
  String to = '';
  List<String> intermediates = [];
  bool showPath = false;

  // MongoDB connection settings
  final String connectionString =
      'mongodb+srv://chandirasegaran:25032002@myangadi.bxernfz.mongodb.net/?retryWrites=true&w=majority&appName=MyAngadi';
  mongo.Db? db;
  mongo.DbCollection? collection;

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

  @override
  void dispose() {
    db?.close();
    super.dispose();
  }

  void trackDocument(String documentNumber) async {
    var document = await collection?.findOne(mongo.where.eq('documentNumber', documentNumber));

    if (document != null) {
      setState(() {
        from = document['from'] ?? '';
        to = document['to'] ?? '';
        intermediates = [];

        int counter = document['intermediate_counter'] ?? 0;
        for (int i = 1; i <= counter; i++) {
          String intermediate = document['intermediate_$i'];
          if (intermediate != null && !intermediates.contains(intermediate)) {
            intermediates.add(intermediate);
          }
        }
        showPath = true;
      });
    } else {
      // Handle case when document is not found
      setState(() {
        from = '';
        to = '';
        intermediates = [];
        showPath = false;
      });
      print('Document not found');
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
                trackDocument(documentNumber);
              },
              child: Text('Track'),
            ),
            SizedBox(height: 16.0),
            // Display the straight line path with tracking details only if showPath is true
            if (showPath)
              Expanded(
                child: CustomPaint(
                  painter: PathPainter(from, to, intermediates),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PathPainter extends CustomPainter {
  final String from;
  final String to;
  final List<String> intermediates;

  PathPainter(this.from, this.to, this.intermediates);

  @override
  void paint(Canvas canvas, Size size) {
    // Define paint properties
    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    // Define starting point
    Offset startPoint = Offset(20, size.height / 2);

    // Calculate positions for each point
    List<Offset> points = [startPoint];
    for (int i = 0; i < intermediates.length; i++) {
      points.add(Offset(size.width * (i + 1) / (intermediates.length + 2), size.height / 2));
    }
    points.add(Offset(size.width - 60, size.height / 2));

    // Draw the straight line path
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }

    // Draw circles and text for each point
    for (int i = 0; i < points.length; i++) {
      String text = i == 0 ? from : (i == points.length - 1 ? to : intermediates[i - 1]);
      paint.color = i == 0 ? Colors.green : (i == points.length - 1 ? Colors.red : Colors.orange);
      canvas.drawCircle(points[i], 8.0, paint);

      TextPainter(
        text: TextSpan(text: text, style: TextStyle(color: paint.color)),
        textDirection: TextDirection.ltr,
      )..layout(minWidth: 0, maxWidth: size.width - 40)
        ..paint(canvas, points[i] - Offset(0, 20));
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
