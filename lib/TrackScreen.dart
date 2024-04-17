import 'package:flutter/material.dart';
// import 'package:doctrack/QRScanningScreen.dart';
import 'package:mydoc/QRScanningScreen.dart'; // Import the QRScanningScreen

class TrackScreen extends StatefulWidget {
  @override
  _TrackScreenState createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  TextEditingController documentNumberController = TextEditingController();

  String from = '';
  String to = '';
  String mid = '';
  bool showPath = false;

  void addMidToDatabase(String newMid) {
    // Assume you have a function to add mid to the database
    // After adding mid to the database, update the tracking details
    setState(() {
      mid = newMid;
    });
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
                // Set some dummy data for demonstration
                setState(() {
                  from = 'Location A';
                  to = 'Location B';
                  showPath = true;
                });
              },
              child: Text('Track'),
            ),
            SizedBox(height: 16.0),
            // Display the straight line path with tracking details only if showPath is true
            if (showPath)
              Expanded(
                child: CustomPaint(
                  painter: PathPainter(from, to, mid),
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
  final String mid;

  PathPainter(this.from, this.to, this.mid);

  @override
  void paint(Canvas canvas, Size size) {
    // Define paint properties
    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    // Define starting point
    Offset startPoint = Offset(20, size.height / 2);
    // Define ending point
    Offset endPoint = Offset(size.width - 20, size.height / 2);
    // Define mid point
    Offset midPoint = Offset(size.width / 2, size.height / 2);

    // Draw the straight line path
    canvas.drawLine(startPoint, endPoint, paint);

    // Draw circles for from, to, and mid locations
    paint.color = Colors.green; // From color
    canvas.drawCircle(startPoint, 8.0, paint);
    paint.color = Colors.red; // To color
    canvas.drawCircle(endPoint, 8.0, paint);
    paint.color = Colors.orange; // Mid color
    canvas.drawCircle(midPoint, 8.0, paint);

    // Draw text for from, to, and mid locations
    TextPainter(
      text: TextSpan(text: from, style: TextStyle(color: Colors.green)),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: size.width - 40)
      ..paint(canvas, startPoint - Offset(0, 20));
    TextPainter(
      text: TextSpan(text: to, style: TextStyle(color: Colors.red)),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: size.width - 40)
      ..paint(canvas, endPoint - Offset(0, 20));
    TextPainter(
      text: TextSpan(text: mid, style: TextStyle(color: Colors.orange)),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: size.width - 40)
      ..paint(canvas, midPoint - Offset(0, 20));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
