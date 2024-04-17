import 'package:flutter/material.dart';
import 'QRScanningScreen.dart';

class ScanQRScreen extends StatefulWidget {
  @override
  _ScanQRScreenState createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  TextEditingController documentNumberController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController commentController = TextEditingController();

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
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Action for incoming
                      print('Incoming action...');
                      // Show dialog when incoming button is pressed
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("File Status Updated"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.arrow_downward),
                    label: Text('Incoming'),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Action for outgoing
                      print('Outgoing action...');
                      // Show form for outgoing when button is pressed
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Outgoing Form"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: toController,
                                  decoration: InputDecoration(
                                    labelText: 'To:',
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                TextFormField(
                                  controller: commentController,
                                  decoration: InputDecoration(
                                    labelText: 'Comment:',
                                  ),
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Send outgoing form
                                  print('Sending outgoing form...');
                                  print('To: ${toController.text}');
                                  print('Comment: ${commentController.text}');
                                  // Close dialog
                                  Navigator.of(context).pop();
                                },
                                child: Text("Send"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.arrow_upward),
                    label: Text('Outgoing'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
