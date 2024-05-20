// import 'package:flutter/material.dart';
// import 'QRScanningScreen.dart';
//
// class ScanQRScreen extends StatefulWidget {
//   @override
//   _ScanQRScreenState createState() => _ScanQRScreenState();
// }
//
// class _ScanQRScreenState extends State<ScanQRScreen> {
//   TextEditingController documentNumberController = TextEditingController();
//   TextEditingController toController = TextEditingController();
//   TextEditingController commentController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Scan QR Code'),
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
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       // Action for incoming
//                       print('Incoming action...');
//                       // Show dialog when incoming button is pressed
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: Text("File Status Updated"),
//                             actions: <Widget>[
//                               TextButton(
//                                 onPressed: () {
//                                   Navigator.of(context).pop();
//                                 },
//                                 child: Text("OK"),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     },
//                     icon: Icon(Icons.arrow_downward),
//                     label: Text('Incoming'),
//                   ),
//                 ),
//                 SizedBox(width: 16.0),
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       // Action for outgoing
//                       print('Outgoing action...');
//                       // Show form for outgoing when button is pressed
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: Text("Outgoing Form"),
//                             content: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 TextFormField(
//                                   controller: toController,
//                                   decoration: InputDecoration(
//                                     labelText: 'To:',
//                                   ),
//                                 ),
//                                 SizedBox(height: 16.0),
//                                 TextFormField(
//                                   controller: commentController,
//                                   decoration: InputDecoration(
//                                     labelText: 'Comment:',
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             actions: <Widget>[
//                               TextButton(
//                                 onPressed: () {
//                                   Navigator.of(context).pop();
//                                 },
//                                 child: Text("Cancel"),
//                               ),
//                               ElevatedButton(
//                                 onPressed: () {
//                                   // Send outgoing form
//                                   print('Sending outgoing form...');
//                                   print('To: ${toController.text}');
//                                   print('Comment: ${commentController.text}');
//                                   // Close dialog
//                                   Navigator.of(context).pop();
//                                 },
//                                 child: Text("Send"),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     },
//                     icon: Icon(Icons.arrow_upward),
//                     label: Text('Outgoing'),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }






import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:firebase_auth/firebase_auth.dart';
import 'QRScanningScreen.dart';

class ScanQRScreen extends StatefulWidget {
  @override
  _ScanQRScreenState createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  TextEditingController documentNumberController = TextEditingController();
  TextEditingController toController = TextEditingController();

  // MongoDB connection settings
  final String connectionString = 'mongodb+srv://chandirasegaran:25032002@myangadi.bxernfz.mongodb.net/?retryWrites=true&w=majority&appName=MyAngadi';
  mongo.Db? db;
  mongo.DbCollection? collection;

  String? _userName; // Variable to store username

  @override
  void initState() {
    super.initState();
    initDb();
    fetchUserName(); // Fetch username when screen initializes
  }

  void initDb() async {
    db = await mongo.Db.create(connectionString);
    await db!.open();
    collection = db!.collection('mydoc');
  }

  void fetchUserName() async {
    // Get the current user from FirebaseAuth
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // If user is signed in, set the username without '@'
      setState(() {
        _userName = user.displayName?.split('@')[0] ?? user.email?.split('@')[0] ?? 'Unknown User';
      });
    } else {
      // If user is not signed in, handle accordingly
      // For now, let's set it as 'Unknown User'
      setState(() {
        _userName = 'Unknown User';
      });
    }
  }

  @override
  void dispose() {
    db?.close();
    super.dispose();
  }

  Future<void> handleIncomingAction() async {
    String documentNumber = documentNumberController.text;

    // Check if username is null
    if (_userName != null) {
      // Find the document by its number and update the incoming status to false
      var document = await collection?.findOne(mongo.where.eq('documentNumber', documentNumber));
      if (document != null) {
        await collection?.update(
          mongo.where.eq('documentNumber', documentNumber),
          mongo.modify
              .set('status', false)
              .set('intermediate', _userName),
        );

        // Show dialog
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
      }
    } else {
      // Show error message or handle accordingly if username is null
      print('Username is null');
    }
  }

  Future<void> handleOutgoingAction() async {
    String documentNumber = documentNumberController.text;
    String to = toController.text;

    // Find the document by its number
    var document = await collection?.findOne(mongo.where.eq('documentNumber', documentNumber));
    if (document != null) {
      // Check if intermediate field already exists
      if (document.containsKey('intermediate')) {
        // Increment the intermediate counter
        int counter = document['intermediate_counter'] ?? 1;
        counter++;
        // Update the current document's intermediate field
        await collection?.update(
          mongo.where.eq('_id', document['_id']),
          mongo.modify
            .set('intermediate_$counter', to)
            .set('intermediate_counter', counter),
        );
      } else {
        // Create a new intermediate field
        await collection?.update(
          mongo.where.eq('_id', document['_id']),
          mongo.modify
            .set('intermediate', to)
            .set('intermediate_counter', 1),
        );
      }

      // Update the current document's status to completed
      await collection?.update(
        mongo.where.eq('_id', document['_id']),
        mongo.modify
          .set('outgoing', true)
          .set('status', 'completed'),
      );

      // Show dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Outgoing Form Sent"),
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
    } else {
      // Handle case when document is not found
      print('Document not found');
    }
  }

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
                    onPressed: () async {
                      await handleIncomingAction();
                    },
                    icon: Icon(Icons.arrow_downward),
                    label: Text('Incoming'),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
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
                                onPressed: () async {
                                  await handleOutgoingAction();
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

void main() {
  runApp(MaterialApp(
    home: ScanQRScreen(),
  ));
}


